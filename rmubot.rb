require 'rubygems'
require 'cinch'
require 'rest_client'
require 'yaml'
require 'json'
require 'sequel'

@db = Sequel.connect 'sqlite://schema.db'
@conf = YAML.load open('conf.yml') {|f| f.read }
#URL = 'http://rmuapi.heroku.com/irc/log/insert'
URL = 'http://localhost:9393/irc/log/insert'

bot = Cinch.setup do
  server 'irc.freenode.org'
	nick   'babot'
	verbose true
end

bot.on 376 do |m|
  bot.join @conf['channel'], @conf['password']
end
r = RestClient.post('http://localhost:9393/irc/log/insert',:key=>'a',:secret=>'b',:timestamp=>'c',:nick=>'d',:text=>'e',:symbol=>'g')

def update_db(m)
  DB[:log].insert(
    Time.now,
    m.nick,
    m.text,
    m.symbol
  )
=begin
  r = RestClient.post(
    URL,
    :key => @conf['key'].to_s,
    :secret => @conf['secret'].to_s,
    :timestamp => Time.now,
    :nick => m.nick,
    :text => m.text,
    :symbol => m.symbol,
    :accept => :json
  )
=end
end

bot.on :privmsg do |m|
  update_db(m) if m.nick != bot.nick
end

bot.on :join do |m|
  update_db(m) if m.nick != bot.nick
end

bot.on :part do |m|
  update_db(m) if m.nick != bot.nick
end

bot.on :quit do |m|
  puts m.nick
  puts m.text
  puts m.symbol.to_s
end

bot.plugin 'site', :channel => ['#rmu-general'] do |m|
  bot.privmsg(
    m.nick,
    'http://seacreature.posterous.com/tag/rubymendicant'
  )
end
bot.plugin 'forum', :channel => ['#rmu-general'] do |m|
  bot.privmsg(
    m.nick,
    'http://groups.google.com/group/ruby-mendicant-university----general'
  )
end

bot.plugin '!stop', :nick => 'locks' do
	bot.privmsg( "I shall go... but I shall return!")
	bot.quit
	exit
end

bot.run