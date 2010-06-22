task :default => [:bot]

task :update_db do
 `heroku db:push sqlite://log.db --force --app rmulog`
end

task :bot do
 ruby 'rmubot.rb'
end
