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
    @@usuario_bo = UsuarioBO.new
  end

  configure :development do
    register Sinatra::Reloader
  end

  get '/all' do
    @@usuario_bo.all.to_json
  end

  get '/:user' do
    @@usuario_bo.ver_usuario(params['user']).to_json
  end

  post '/new' do
    datos = {:user => params['user'],
             :pass => params['pass'],
             :nombre => params['nombre'],
             :apellidos => params['apellidos'],
             :email => params['email'],
             :direccion => params['direccion'],
             :telefono => params['telefono']
    }
    @@usuario_bo.crear_usuario(datos)
  end

  post '/update' do
    if params['user'].nil?
      'Error en el formulario'
    else
      datos = {'user' => params['user']}

      # Permite elegir que parametro van a ser modificados
      if !params['nombre'].nil?
        datos.store('nombre',params['nombre'])
      end

      if !params['apellidos'].nil?
        datos.store('apellidos',params['apellidos'])
      end

      if !params['email'].nil?
        datos.store('email',params['email'])
      end

      if !params['direccion'].nil?
        datos.store('direccion',params['direccion'])
      end

      if !params['telefono'].nil?
        datos.store('telefono',params['telefono'])
      end

      @@usuario_bo.modificar_usuario(datos)
    end
  end

  delete '/delete/:user' do
    @@usuario_bo.borrar_usuario(params['user'])
  end
end