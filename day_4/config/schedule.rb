# set :environment, :development
# set :output, "#{path}/log/cron.log"

# every 1.minutes do
#   command "cd #{path} && /root/.local/share/mise/installs/ruby/3.4.4/bin/bundle add rake --quiet && /root/.local/share/mise/installs/ruby/3.4.4/bin/bundle exec rake articles:cleanup_reported"
# end

set :environment, :development
set :output, "/mnt/d/ITI/Ruby/Labs/day_4/log/cron.log"

every 1.minutes do
  command "cd /mnt/d/ITI/Ruby/Labs/day_4 && /root/.local/share/mise/installs/ruby/3.4.4/bin/bundle exec /root/.local/share/mise/installs/ruby/3.4.4/bin/rake articles:cleanup_reported"
end