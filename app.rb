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


end # class CountryCodesApp

