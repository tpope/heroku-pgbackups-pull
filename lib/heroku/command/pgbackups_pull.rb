require 'heroku/command/pgbackups'

Heroku::Command::Pgbackups.class_eval do

  # pgbackups:pull [BACKUP_ID]
  #
  # load a backup into the local database with pg_restore
  #
  # -v, --verbose     # Pass --verbose to pg_restore
  def pull
    name = shift_argument
    validate_arguments!

    if name
      b = pgbackup_client.get_backup(name)
    else
      b = pgbackup_client.get_latest_backup
    end
    unless b['public_url']
      error("No backup found.")
    end

    args = []
    args << '--verbose' if options[:verbose]

    require 'net/http'
    uri = URI.parse(b['public_url'])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')

    file = File.expand_path('../../../../libexec/rails_pg_restore.rb', __FILE__)

    IO.popen(['rails', 'runner', file, *args], 'w', encoding: 'BINARY') do |pg|
      http.request_get("#{uri.path}?#{uri.query}") do |backup|
        backup.read_body do |chunk|
          pg.write(chunk)
        end
      end
    end
  end

end
