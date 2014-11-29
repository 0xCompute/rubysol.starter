
require './boot'   ## NOTE: will setup environemnt (that is, database connection)


require 'datafile'

datafile =<<EOS
  ## Datfile configuration (for now keep it inline)
  world 'openmundi/world.db', setup: 'countries'
EOS

DATAFILE = Datafile::Builder.load( datafile ).datafile


## download world.db dataset
task :dl_world do
  DATAFILE.download
end

## import world.db dataset
task :load_world => [:delete_world] do
  # NOTE: assume env (database connection) is setup
  DATAFILE.read
end

task :update_world do
  WorldDb::Model::CountryCode.update!   # auto-create (update) country codes (from countries)
end

task :delete_world do
  LogDb.delete!
  ConfDb.delete!
  TagDb.delete!
  WorldDb.delete!
end

## create world.db tables
task :create_world do
  LogDb.create # add logs table
  ConfDb.create # add props table
  TagDb.create # add tags, taggings table
  WorldDb.create
end

task :setup_world => [:dl_world,:create_world,:load_world,:update_world] do
  ## all work done by dependencies
end

