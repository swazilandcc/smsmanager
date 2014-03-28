require 'sidekiq'
bundle exec sidekiq -e production -d -L log/sidekiq.log
