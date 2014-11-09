require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'json'

require 'app/dominio/usuario'
require 'app/dominio/carrito'
require 'app/aplicacion/usuario_bo'
require 'app/aplicacion/carrito_bo'
require 'app/util/custom_msg_exception'
require 'app/util/utilidad'

# Clase que se encarga del acceso a la API de Usuario
class UsuariosAPI < Sinatra::Base

  # Configuracion inicial
  configure do
    puts 'configurando API de usuarios...'
    @@usuario_bo = UsuarioBO.new
    @@carrito_bo = CarritoBO.new
  end

  # Configuracion mientras se esta desarrollando
  configure :development do
    puts 'activando reloader de usuarios...'
    register Sinatra::Reloader
  end

  configure :test do
    session[:usuario] = 'root'
  end

  # Lista de usuarios en JSON
  get '/all' do
    begin
      users = @@usuario_bo.all(session[:usuario])
      result = Utilidad.paginacion(request.env['REQUEST_PATH'],users,params)
      result.to_json
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # Un usuario en JSON. Si no existe lanza un 404
  get '/:user' do
    begin
      u = @@usuario_bo.find_by_user(params['user'],session[:usuario])
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
             :password => params[:pass],
             :password_confirmation => params[:pass_conf],
             :nombre => params[:nombre],
             :apellidos => params[:apellidos],
             :email => params[:email],
             :direccion => params[:direccion],
             :telefono => params[:telefono]
    }

    begin
      u = @@usuario_bo.create(datos)
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
        datos.store(:password,params[:pass])
      end
      if !params[:pass_conf].nil?
        datos.store(:password_confirmation,params[:pass_conf])
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
        u = @@usuario_bo.update(datos,session[:usuario])
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
      msg = @@usuario_bo.delete(params['user'],session[:usuario])
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
      c = @@carrito_bo.all(params['user'],session[:usuario])
      status 200
      result = Utilidad.paginacion(request.env['REQUEST_PATH'],c,params)
      result.to_json
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # Añadir un producto al carrito
  post '/:user/carrito' do
    datos = {:carrito_id => params[:user_id],
             :producto_id => params[:prod_id]
    }

    begin
      msg = @@carrito_bo.add_prod_en_carrito(datos,session[:usuario])
      status 201
      msg
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # Borrar un producto al carrito
  delete '/:user/carrito' do
    begin
      msg = @@carrito_bo.delete_prod_en_carrito(params['user'],params[:prod_id],session[:usuario])
      status 200
      msg
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # Borrar todo el carrito a la vez
  delete '/:user/carrito/all' do
    begin
      msg = @@carrito_bo.delete_all_carrito(params['user'],session[:usuario])
      status 200
      msg
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end
end