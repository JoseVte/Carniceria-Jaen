require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'json'

require 'app/dominio/usuario'
require 'app/aplicacion/usuario_bo'

#Clase principal de la API de los usuarios
class UsuariosAPI < Sinatra::Base

  #Configuracion inicial
  configure do
    puts 'configurando API de usuarios...'
    @@producto_bo = ProductoBO.new
  end

  configure :development do
    register Sinatra::Reloader
  end

end