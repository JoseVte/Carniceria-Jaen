require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'json'

require 'app/dominio/usuario'
require 'app/dominio/carrito'
require 'app/aplicacion/usuario_bo'
require 'app/aplicacion/carrito_bo'
require 'app/util/custom_msg_exception'

#Clase principal de la API de los usuarios
class UsuariosAPI < Sinatra::Base

  #Configuracion inicial
  configure do
    puts 'configurando API de usuarios...'
    @@usuario_bo = UsuarioBO.new
    @@carrito_bo = CarritoBO.new
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
    begin
      u = @@usuario_bo.ver_usuario(params['user'])
      status 200
      u.to_json
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # Crea un usuario nuevo. Si ya existe o esta mal formado el formulario lanza un 400
  post '/new' do
    datos = {:user => params[:user],
             :pass => params[:pass],
             :nombre => params[:nombre],
             :apellidos => params[:apellidos],
             :email => params[:email],
             :direccion => params[:direccion],
             :telefono => params[:telefono]
    }

    begin
      u = @@usuario_bo.crear_usuario(datos,'login')
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
    if params[:user].nil?
      status 400
      'Error 400: Falta el usuario en el formulario'
    else
      datos = {:user => params[:user]}

      # Permite elegir que parametro van a ser modificados
      if !params[:pass].nil?
        datos.store(:pass,params[:pass])
      end
      if !params[:nombre].nil?
        datos.store(:nombre,params[:nombre])
      end
      if !params[:apellidos].nil?
        datos.store(:apellidos,params[:apellidos])
      end
      if !params[:email].nil?
        datos.store(:email,params[:email])
      end
      if !params[:direccion].nil?
        datos.store(:direccion,params[:direccion])
      end
      if !params[:telefono].nil?
        datos.store(:telefono,params[:telefono])
      end

      begin
        u = @@usuario_bo.modificar_usuario(datos,'login')
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
      msg = @@usuario_bo.borrar_usuario(params['user'],'login')
      status 200
      msg
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # API del carrito

  # Todos los productos del carrito
  get '/:user/carrito' do
    begin
      c = @@carrito_bo.all(params['user'],'login')
      status 200
      c.to_json
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # Añadir un producto al carrito
  post '/:user/carrito' do
    datos = {:usuarios_id => params[:user_id],
             :productos_id => params[:prod_id]
    }

    begin
      c = @@carrito_bo.crear_prod_en_carrito(datos,'login')
      status 201
      c
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

end