# encoding: utf-8


class CountryCodeCursor

  def initialize( codes )
    @codes = codes
  end

  def each
    code_groups = []

    ## group codes by code.name & country.name
    group = nil

    last_code_name    = nil
    last_country_name = nil

    @codes.each_with_index do |code,i|
      new_code    =  last_code_name != code.name
      new_country =  last_country_name != code.country.name

      if new_code || new_country
        code_groups << group    if group
        group = []
      end

      group << code

      last_code_name     = code.name
      last_country_name  = code.country.name
    end

    code_groups << group   if group


    code_groups.each_with_index do |g,i|
      yield(g,self)
    end
  end  # method each

=begin
  def old_each
    prev_code_name    = nil
    prev_country_name = nil

    code_group = []

    @codes.each_with_index do |code,i|
      
      if i >= @codes.size-1   # note: last entry has no next entry (guard/special case)
        next_code_name = nil
      else
        next_code_name = @codes[i+1].name
      end

      begin_row =   prev_code_name != code.name
      end_row   =   next_code_name != code.name

      ## note: only flag new country if second (new) country in row
      new_country = begin_row == false && prev_country_name != code.country.name

      if

      ## yield( code, self )

      prev_code_name     = code.name
      prev_country_name  = code.country.name
    end
  end
=end

  def begin_row?()   @begin_row; end
  def end_row?()     @end_row;   end
  def new_country?() @new_country; end


end   # class CountryCodeCursor




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

get '/codes' do
  erb :codes
end


get '/stats' do
  erb :stats
end

get '/:key' do |key|
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

