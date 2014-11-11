# encoding: utf-8

ENV['RACK_ENV'] ||= 'development'
puts "ENV['RACK_ENV'] = #{ENV['RACK_ENV']}"


# 3rd party libs/gems
require 'sinatra/base'
require 'worlddb'

## require 'active_record'

=begin
DB_CONFIG = {
adapter: 'sqlite3',
database: 'world.db'
}
puts "DB_CONFIG:"
pp DB_CONFIG

ActiveRecord::Base.establish_connection( DB_CONFIG )
# ActiveRecord::Base.logger = Logger.new( STDOUT )
=end

require './app.rb'

