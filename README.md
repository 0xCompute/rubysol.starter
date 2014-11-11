# world.db.codes

world.db web app for country codes (alpha 2, alpha 3, internet top level domains, motor vehicle license plates, etc.)

## Live Demo

Try the live demo running on heroku @ [`countrycodes.herokuapp.com`](http://countrycodes.herokuapp.com)


## Setup in 1-2-3 Steps

Step 1: Install all libraries (gem) using bundler

    $ bundle install

Step 2: Download world.db datasets in a zip archive (~150 KiB); create world.db database and tables; load datasets using rake

    $ mkdir ./tmp       # world.db zip archive will get downloaded to tmp folder in your working folder
    $ rake setup_world

or use individual tasks

    $ rake dl_world create_world load_world

Step 3: Startup the server and open up the browser.

    $ rackup

That's it.


## License

The `world.db.codes` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the [Open Mundi (world.db) Database Forum/Mailing List](http://groups.google.com/group/openmundi).
Thanks!

