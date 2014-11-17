# encoding: utf-8


class CountryCodesApp < Sinatra::Base

include WorldDb::Models    ## (re)use world.db models


##############
# Helpers

def link_to( title, href )
  "<a href='#{href}'>#{title}</a>"
end

def link_to_country( country )
  link_to( country.name, "/#{country.key}" )
end

def link_to_continent( continent )
  link_to( continent.name, "/r/#{continent.key}" )
end


##############################################
# Controllers / Routing / Request Handlers

get '/' do
  
  where_clause = build_where_clause_from_params( params )  ## filter countries by kind/type (e.g. supra/country/dependency)
  countries    = Country.where( where_clause )

  erb :index, locals: { title:        'World',
                        countries:       countries.by_name,
                        countries_count: countries.count,
                        where_clause:    where_clause
                      }
end


get '/r/:key' do |key|

  continent = Continent.find_by_key!( key )

  where_clause = build_where_clause_from_params( params )  ## filter countries by kind/type (e.g. supra/country/dependency)
  countries = continent.countries.where( where_clause )

  erb :index, locals: { title:  "#{continent.name}",
                        countries:       countries.by_name,
                        countries_count: countries.count,
                        where_clause:  where_clause 
                      }
end


private

def build_where_clause_from_params( params )
  c = params[:c].nil? ? true : (['f','off','no','n'].include?(params[:c]) ? false : true)
  d = params[:d].nil? ? true : (['f','off','no','n'].include?(params[:d]) ? false : true)
  s = params[:s].nil? ? true : (['f','off','no','n'].include?(params[:s]) ? false : true)

  conds = []
  conds << "c = 't'"    if c
  conds << "d = 't'"    if d
  conds << "s = 't'"    if s

  conds.join(' OR ')
end

end # class CountryCodesApp

