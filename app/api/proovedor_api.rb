require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'json'

require 'app/dominio/proovedor'
require 'app/aplicacion/proovedor_bo'
require 'app/util/utilidad'

# Clase que se encarga del acceso a la API de Proovedor
class ProovedorAPI < Sinatra::Base

  # Configuracion inicial
  configure do
    puts 'configurando API de proovedores...'
    @@proovedor_bo = ProovedorBO.new
  end

  # Configuracion mientras se esta desarrollando
  configure :development do
    puts 'activando reloader de proovedor...'
    register Sinatra::Reloader
  end

  # Devuelve un listado con todos los proovedores que contengan la subcadena
  get '/buscar/:campo/:cadena' do
    begin
      p = @@proovedor_bo.select_by(params['campo'],params['cadena'])
      status 200
      result = Utilidad.paginacion(request.env['REQUEST_PATH'],p,params)
      result.to_json
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # Todos los proovedor en JSON
  get '/all' do
    begin
      p = @@proovedor_bo.all
      result = Utilidad.paginacion(request.env['REQUEST_PATH'],p,params)
      result.to_json
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # Un proovedor en JSON. Si no existe lanza un 404
  get '/:id' do
    begin
      p = @@proovedor_bo.find_by_id(params['id'])
      status 200
      p.to_json
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # Crea un proovedor nuevo. Si ya existe o esta mal formado el formulario lanza un 400
  post '/new' do
    datos = {:nombreEmpresa => params['nombreEmpresa'],
             :nombre => params['nombre'],
             :apellidos => params['apellidos'],
             :email => params['email'],
             :direccion => params['direccion'],
             :telefono => params['telefono']
    }
    begin
      p = @@proovedor_bo.create(datos,request.env['HTTP_X_AUTH_TOKEN'])
      status 201
      p.to_json
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # Actualiza los campos de un proovedor. Si se viola alguna regla de la base de datos lanza un 400
  post '/update' do
    if params['id'].nil?
      status 400
      'Error 400: Falta el id en el formulario'
    else
      datos = {:id => params['id']}

      # Permite elegir que parametro van a ser modificados
      if !params['nombreEmpresa'].nil?
        datos.store('nombreEmpresa',params['nombreEmpresa'])
      end

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
        p = @@proovedor_bo.update(datos,request.env['HTTP_X_AUTH_TOKEN'])
        status 200
        p.to_json
      rescue CustomMsgException => e
        status e.status
        e.message
      end
    end
  end

  # Borra un proovedor del sistema. Si no existe devuelve un 404
  delete '/:id' do
    begin
      msg = @@proovedor_bo.delete(params['id'],request.env['HTTP_X_AUTH_TOKEN'])
      status 200
      msg
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end
end