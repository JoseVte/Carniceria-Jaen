require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'json'

require 'app/dominio/producto'
require 'app/aplicacion/producto_bo'

#Clase principal de los productos del proyecto
class ProductosAPI < Sinatra::Base

  #Configuracion inicial
  configure do
    puts 'configurando API de productos...'
    @@producto_bo = ProductoBO.new
  end

  configure :development do
    register Sinatra::Reloader
  end

  #Listado de los productos en oferta
  get '/ofertas' do
    @@producto_bo.ofertas.to_json
  end

end