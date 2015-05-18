require 'dotenv'

namespace(:mysql) do
    desc "Backup MySQL Database"
    task :backup do
        on roles(:all) do
            timestamp = Time.now.strftime('%Y%m%d%H%M%S')
            text = capture "cat #{shared_path}/.env"
            ENV2 = Dotenv::Parser.call(text)
            execute "mkdir -p #{shared_path}/db_backups"
            execute "mysqldump -h #{ENV2['DB_HOST']} -u#{ENV2['DB_USER']} -p#{ENV2['DB_PASSWORD']} #{ENV2['DB_NAME']} > #{shared_path}/db_backups/#{timestamp}.sql"
            execute "(cd #{shared_path}/db_backups; ls -1tr | head -n -5 | xargs -d '\\n' rm)" # Keep only five latest
        end
    end
end
