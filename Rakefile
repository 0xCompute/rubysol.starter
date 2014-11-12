
require './boot'   ## NOTE: will setup environemnt (that is, database connection)


####
# download tasks for zips

def dowload_archive( url, dest )
  puts "downloading #{url} to #{dest}..."
  worker = Fetcher::Worker.new
  worker.copy( url, dest )

  puts "size: #{File.size(dest)} bytes"  ## print some file stats
end


ZIP_PATH    = "./tmp"

WORLD_NAME  = 'world.db'
WORLD_URL   = "https://github.com/openmundi/#{WORLD_NAME}/archive/master.zip"
WORLD_ZIP   = "#{ZIP_PATH}/#{WORLD_NAME}.zip"


## download world.db dataset
task :dl_world do
  dowload_archive( WORLD_URL, WORLD_ZIP )
end

## import world.db dataset
task :load_world => [:delete_world] do
  # NOTE: assume env (database connection) is setup
  WorldDb.read_setup_from_zip( WORLD_NAME, 'setups/sport.db.admin', ZIP_PATH, { skip_tags: true } )
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

task :setup_world => [:dl_world,:create_world,:load_world] do
  ## all work done by dependencies
end

