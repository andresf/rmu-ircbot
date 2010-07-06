require 'rubygems'
require 'cinch'
require 'rest_client'
require 'yaml'

@conf = YAML.load open('conf.yml')
ENV = 'DEV'

bot = Cinch::Base.new do
  server 'irc.freenode.org'
	nick   'babot'
	verbose true
end

bot.on 376 do |m|
  bot.join @conf[ENV]['channel'], @conf[ENV]['password']
end

def update_db(m)
  RestClient.post(
    @conf[ENV]['url'],
    :login => {
      :key => @conf['key'],
      :secret => @conf['secret']
    },
    :msg => {
      :timestamp => Time.now,
      :nick => m.nick,
      :text => m.text,
      :symbol => m.symbol
    }
  )
end

def putA(m)
  puts m.symbol
  puts m.nick
  puts m.raw
  puts "---"
  puts m.data.instance_variables
end

bot.on :privmsg, :channel => ['#rmu-bot'] do |m|
  puts "NNAADDAA"
#  putA(m)
end
bot.on :privmsg do |m|
  putA(m)
end

bot.on :join do |m|
  putA(m)
end

bot.on :part do |m|
  putA(m)
end

bot.on :quit do |m|
  putA(m)
end

bot.on :action do
  puts "-a-a-a-a-a-a-a-"
end

@rules = Cinch::Rules.new

@rules.add_callback('foo', Proc.new{})

bot.rule 'site', :channel => ['#rmu-general'] do |m|
  bot.privmsg(
    m.nick,
    'http://seacreature.posterous.com/tag/rubymendicant'
  )
end

bot.rule 'forum', :channel => ['#rmu-general'] do |m|
  bot.privmsg(
    m.nick,
    'http://groups.google.com/group/ruby-mendicant-university----general'
  )
end

bot.rule 'stop', :nick => 'locks' do |m|
	bot.privmsg( m.nick, "I shall go... but I shall return!" )
	bot.quit
	exit
end

bot.run