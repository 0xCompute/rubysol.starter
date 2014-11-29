# encoding: utf-8


def codes_group_by_name_and_country( codes )

  ### fix-fix-fix: move to country code model!!!!!
  
  ## note: make code.name case insensitive (use) upcase
  #   in your order clause use => CountryCode.order( 'UPPER(name),country_id')

  ## pass 1: group codes by code.name n country.name
  groups1 = []
  group1 = nil

  last_code_name    = nil
  last_country_name = nil

  codes.each do |code|
    new_code    =  last_code_name != code.name.upcase
    new_country =  last_country_name != code.country.name

    if new_code || new_country
      groups1 << group1    if group1
      group1 = []
    end

    group1 << code

    last_code_name     = code.name.upcase
    last_country_name  = code.country.name
  end
  groups1 << group1   if group1


  ### pass 2: group by code (more than once country possible per code!)
  groups2 = []
  group2 = nil

  last_code_name    = nil

  groups1.each do |group|
    new_code    =  last_code_name  != group[0].name.upcase

    if new_code
      groups2 << group2    if group2
      group2 = []
    end

    group2 << group

    last_code_name = group[0].name.upcase
  end
  groups2 << group2   if group2

  ## sort groups by size (list country w/ more codes first)
  groups2.each do |group|
    group.sort! { |l,r| r.size <=> l.size }
  end

  groups2
end



class CountryCodesApp < Sinatra::Base

include WorldDb::Models    ## (re)use world.db models


##############
# Helpers

def link_to( title, href )
  "<a href='#{href}'>#{title}</a>"
end

def link_to_country( country )
  link_to( country.name, "/c/#{country.key}" )
end

def link_to_continent( continent )
  link_to( continent.name, "/r/#{continent.key}" )
end

def link_to_codepage( page )  # e.g. A2, NET, FIPS etc. same as code.kind
  link_to( page, "/p/#{page}" )
end

def link_to_code( code )
  ## remove dots e.g. .at => at etc.
  link_to( code, "/#{code.gsub('.','').downcase}")
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

get '/codes' do
  erb :codes
end


get '/stats' do
  erb :stats
end

get '/:name' do |name|
  codes = CountryCode.where( "UPPER(name)=?", name.upcase ).order( 'country_id' )

  erb :code, locals: { name: name, codes: codes, codes_count: codes.count() }
end

get '/p/:name' do |name|
  codes = CountryCode.where( kind: name ).order( 'name' )
  
  erb :page, locals: { name: name, codes: codes, codes_count: codes.count() }
end

get '/c/:key' do |key|
  country = Country.find_by_key!( key )
  
  erb :country, locals: { country: country }
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

