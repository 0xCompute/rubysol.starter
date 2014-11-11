# encoding: utf-8


class CountryCodesApp < Sinatra::Base

#####################
# Models

include WorldDb::Models


##############################################
# Controllers / Routing / Request Handlers

get '/' do
  'hello'
end

get '/countries' do
  "#{Country.count} Countries"
end


end # class CountryCodesApp

