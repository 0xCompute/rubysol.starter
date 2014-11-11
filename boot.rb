# encoding: utf-8

require 'bundler'

ENV['RACK_ENV'] ||= 'development'
puts "ENV['RACK_ENV'] = #{ENV['RACK_ENV']}"

# only add development or production gems (depending on RACK_ENV)
Bundler.setup( :default, ENV['RACK_ENV'].to_sym )

require 'pp' ## fyi: pp is pretty printer
## puts '$LOAD_PATH:'
## pp $LOAD_PATH


# 3rd party libs/gems
require 'sinatra/base'
require 'worlddb'
require 'fetcher'   # lets us download zip archive
require 'logutils/db'

require 'active_record'

puts "ENV['DATBASE_URL'] - >#{ENV['DATABASE_URL']}<"

db = URI.parse( ENV['DATABASE_URL'] || 'sqlite3:///world.db' )

if db.scheme == 'postgres'
        config = {
          adapter:  'postgresql',
          host:     db.host,
          port:     db.port,
          username: db.user,
          password: db.password,
          database: db.path[1..-1],
          encoding: 'utf8'
        }
else   # assume sqlite3
        config = {
          adapter:  db.scheme,       # sqlite3
          database: db.path[1..-1]   # world.db (NB: cut off leading /, thus 1..-1)
        }
end

puts 'db settings:'
pp config

ActiveRecord::Base.establish_connection( config )
# ActiveRecord::Base.logger = Logger.new( STDOUT )

require './app.rb'

