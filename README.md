# world.db.codes

world.db web app for country codes (alpha 2, alpha 3, fifa, ioc, internet top level domains, motor vehicle license plates, etc.)

```ruby
class CountryCodesApp < Sinatra::Base

  include WorldDb::Models  ## (re)use models from worlddb gem

  get '/' do
    erb :index
  end

end
```

(Source: [`app.rb`](app.rb))


Sample template snippet:

```html
<h3><%= Country.count %> Countries </h3>

<table>
  <tr>
     <td></td><td>TLD</td>
     <td></td><td>FIFA</td>
     <td></td><td>ISO3</td>
     <td>Motor</td>
     <td>UN?</td>
     <td>FIFA?</td>
     <td>Languages</td>
  </tr>

  <% Country.by_title.each do |country| %>
    <tr>
     <td class='country-key'><%= country.key %></td>
     <td>
        <% if country.net.present? %>
          <% if country.net != country.key %>
            <span class='code-ne'>≠ </span>
          <% end %>
          .<%= country.net %>
        <% else %>
            <span class='code-x'>x</span>
        <% end %>
     </td>
     <td>
        <%= country.title %>
       <span class='country-key'>
        <%= '*supra'      if country.is_supra?      %>
        <%= '*dependency' if country.is_dependency? %>
       </span>
     </td>
     <td>
        <% if country.fifa.present? %>
            <%= country.fifa %>
            <% if country.fifa != country.code %>
              <span class='code-ne'><%= country.fifa %> ≠</span>
            <% end %>
        <% else %>
            <span class='code-x'>x</span>
        <% end %>
    </td>
...
```

(Source: [`views/index.erb`](views/index.erb))


## Live Demo

Try the live demo running on heroku @ [`countrycodes.herokuapp.com`](http://countrycodes.herokuapp.com)


## Setup in 1-2-3 Steps

Step 1: Install all libraries (gem) using bundler

    $ bundle install

Step 2: Download world.db datasets in a zip archive (~150 KiB); create world.db database and tables; load datasets using rake

    $ mkdir ./tmp       # world.db zip archive will get downloaded to tmp folder
    $ rake setup_world

or use individual tasks

    $ rake dl_world create_world load_world

Step 3: Startup the web server and open up the country codes page in your web browser

    $ rackup

That's it.


## License

The `world.db.codes` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the [Open Mundi (world.db) Database Forum/Mailing List](http://groups.google.com/group/openmundi).
Thanks!

