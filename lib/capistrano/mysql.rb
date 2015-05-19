require 'dotenv'
require 'fileutils'

namespace(:mysql) do
    task :before do
        on roles(:db) do
            TIMESTAMP = Time.now.strftime('%Y%m%d%H%M%S')
            text = capture "cat #{shared_path}/.env"
            ENV2 = Dotenv::Parser.call(text)
        end
    end
    task :backup => :before

    desc "Backup MySQL Database"
    task :backup do
        on roles(:db) do
            create_dir("#{shared_path}/db_backups")
            create_backup(ENV2['DB_HOST'], ENV2['DB_USER'], ENV2['DB_PASSWORD'], ENV2['DB_NAME'], TIMESTAMP)
            remove_old_backups("#{shared_path}/db_backups")
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
