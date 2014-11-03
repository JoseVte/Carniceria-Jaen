require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'json'
require 'sinatra/respond_with'

require 'app/dominio/usuario'
require 'app/aplicacion/usuario_bo'
require 'app/util/custom_msg_exception'

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

  # Lista de usuarios en JSON
  get '/all' do
    @@usuario_bo.all.to_json
  end

  # Un usuario en JSON. Si no existe lanza un 404
  get '/:user' do
    u = @@usuario_bo.ver_usuario(params['user']) or not_found('Error 404: No existe el usuario')
    u.to_json
  end

  # Crea un usuario nuevo. Si ya existe o esta mal formado el formulario lanza un 400
  post '/new' do
    datos = {:user => params['user'],
             :pass => params['pass'],
             :nombre => params['nombre'],
             :apellidos => params['apellidos'],
             :email => params['email'],
             :direccion => params['direccion'],
             :telefono => params['telefono']
    }

    begin
      u = @@usuario_bo.crear_usuario(datos)
      status 201
      u.to_json
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # Actualiza los campos de un usuario. Si se viola alguna regla de la base de datos lanza un 400
  post '/update' do
    # Es necesario el nombre del usuario
    if params['user'].nil?
      status 400
      'Error 400: Falta el usuario en el formulario'
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

      begin
        u = @@usuario_bo.modificar_usuario(datos)
        status 200
        u.to_json
      rescue CustomMsgException => e
        status e.status
        e.message
      end
    end
  end

  # Borra un usuario del sistema. Si no existe devuelve un 404
  delete '/:user' do
    begin
      msg = @@usuario_bo.borrar_usuario(params['user'])
      status 200
      msg
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end
end