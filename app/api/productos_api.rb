require 'sinatra'
require 'sinatra/reloader'
require 'json'

require 'app/dominio/producto'
require 'app/aplicacion/producto_bo'
#require 'app/util/validacion_error'

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