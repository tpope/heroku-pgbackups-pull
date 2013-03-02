conn = ActiveRecord::Base.connection

conn.tables.each do |table|
  conn.drop_table table
end

config = conn.instance_variable_get(:@config)
env = {
  'PGUSER'     => config[:username].to_s,
  'PGHOST'     => config[:host].to_s,
  'PGPORT'     => config[:port].to_s,
  'PGPASSWORD' => config[:password].to_s
}.reject { |k, v| v.empty? }

ENV.update(env)

exec('pg_restore', '--no-owner', '--dbname', config[:database], *ARGV)
