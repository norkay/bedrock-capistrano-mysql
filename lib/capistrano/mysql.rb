require 'dotenv'
require 'fileutils'

namespace(:mysql) do
  task :before do
    on roles(:db) do
      TIMESTAMP = Time.now.strftime('%Y%m%d%H%M%S')
      text = capture "cat #{shared_path}/.env"
      REMOTE_ENV = Dotenv::Parser.call(text)
      file = File.open(".env")
      text = file.read
      LOCAL_ENV = Dotenv::Parser.call(text)
    end
  end
  task :backup      => :before
  task :download    => :before
  task :change_url  => :before
  task :import      => :before

  desc "Sync MySQL Database"
  task :sync => [:backup, :download, :import, :change_url]

  desc "Backup MySQL Database"
  task :backup do
    on roles(:db) do
      create_dir("#{shared_path}/db_backups")
      create_backup(
        REMOTE_ENV['DB_HOST'],
        REMOTE_ENV['DB_USER'],
        REMOTE_ENV['DB_PASSWORD'],
        REMOTE_ENV['DB_NAME'],
        TIMESTAMP
      )
      remove_old_backups("#{shared_path}/db_backups")
    end
  end

  desc "Download the last backuped MySQL Database"
  task :download do
    on roles(:db) do
      filename = get_latest_backup_filename("#{shared_path}/db_backups")
      download! "#{shared_path}/db_backups/#{filename}", "etc/db_backups/remote.sql"
    end
  end

  desc "Change the urls in the MySQL backup file"
  task :change_url do
    on roles(:db) do
      system "cd ..; cd #{LOCAL_ENV['VAGRANT_PATH']}; vagrant ssh -c 'cd /srv/www/#{LOCAL_ENV['VAGRANT_SITE_NAME']}/current; wp search-replace \'#{REMOTE_ENV['WP_HOME']}\' \'#{LOCAL_ENV['WP_HOME']}\''"
      puts "Changed urls!"
    end
  end

  desc "Clean and import the remote MySQL database to the local one"
  task :import do
    on roles(:db) do
      import_local_mysql_database("etc/db_backups/remote.sql")
      puts "Database imported!"
    end
  end
end

private

def create_dir(path)
  execute "mkdir -p #{path}"
end

def create_backup(host, user, password, name, timestamp)
  execute "mysqldump -h #{host} -u#{user} -p#{password} #{name} > #{shared_path}/db_backups/#{timestamp}.sql"
end

def remove_old_backups(path)
  execute "(cd #{path}; ls -1tr | head -n -5 | xargs -d '\\n' rm)" # Keep only five latest
end

def get_latest_backup_filename(path)
  filename = capture "cd #{path}; ls -t | awk '{printf(\"%s\", $0); exit}'"
  filename
end

def local_mysql_credentials
  credential_params = ""

  credential_params << " -u #{LOCAL_ENV['DB_USER']} " if LOCAL_ENV['DB_USER']
  credential_params << " -p'#{LOCAL_ENV['DB_PASSWORD']}' " if LOCAL_ENV['DB_USER']
  credential_params << " -h #{LOCAL_ENV['DB_HOST']} " if LOCAL_ENV['DB_HOST']

  credential_params
end

def local_mysql_database
  LOCAL_ENV['DB_NAME']
end

def import_local_mysql_database(filename)
  system "cd ..; cd #{LOCAL_ENV['VAGRANT_PATH']}; vagrant ssh -c 'mysql #{local_mysql_credentials} -D #{local_mysql_database} < /srv/www/#{fetch(:application)}/current/#{filename}'"
end
