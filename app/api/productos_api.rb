require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'json'

require 'app/dominio/producto'
require 'app/aplicacion/producto_bo'
require 'app/util/utilidad'

# Clase que se encarga del acceso a la API de Producto
class ProductosAPI < Sinatra::Base

  # Configuracion inicial
  configure do
    register Sinatra::ActiveRecordExtension
    puts 'configurando API de productos...'
    @@producto_bo = ProductoBO.new
  end

  # Configuracion mientras se esta desarrollando
  configure :development do
    puts 'activando reloader de productos...'
    register Sinatra::Reloader
  end

  # Listado de los productos en oferta en JSON
  get '/ofertas' do
    content_type :json
    status 200
    @@producto_bo.ofertas.to_json
  end

  # Devuelve un listado con todos los productos del proovedor
  get '/proovedor/:id' do
    params_parseados = Utilidad.parse_params(params)
    p = @@producto_bo.select_by_proovedor(params['id'], params_parseados)
    content_type :json
    status 200
    result = Utilidad.paginacion(request.env['REQUEST_PATH'], p, params_parseados)
    result.to_json
  end

  # Devuelve un listado con todos los productos que contengan la subcadena
  get '/buscar/:subcadena' do
    params_parseados = Utilidad.parse_params(params)
    p = @@producto_bo.select_by_nombre(params['subcadena'], params_parseados)
    content_type :json
    status 200
    result = Utilidad.paginacion(request.env['REQUEST_PATH'], p, params_parseados)
    result.to_json
  end

  # Todos los productos en JSON
  get '/all' do
    params_parseados = Utilidad.parse_params(params)
    p = @@producto_bo.all(params_parseados)
    status 200
    content_type :json
    result = Utilidad.paginacion(request.env['REQUEST_PATH'], p, params_parseados)
    result.to_json
  end

  # Un producto en JSON. Si no existe lanza un 404
  get '/:id' do
    begin
      p = @@producto_bo.find_by_id(params['id'])
      status 200
      content_type :json
      p.to_json
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # Crea un producto nuevo. Si ya existe o esta mal formado el formulario lanza un 400
  post '/new' do
    datos = {:nombre => params['nombre'],
             :descripcion => params['descripcion'],
             :precioKg => params['precioKg'],
             :stock => params['stock'],
             :ofertas => params['ofertas'],
             :proovedor_id => params['proovedor_id']
    }
    begin
      p = @@producto_bo.create(datos,request.env['HTTP_X_AUTH_TOKEN'])
      status 201
      content_type :json
      p.to_json
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end

  # Actualiza los campos de un producto. Si se viola alguna regla de la base de datos lanza un 400
  put '/update' do
    if params['id'].nil?
      status 400
      'Error 400: Falta el id en el formulario'
    else
      datos = {:id => params['id']}

      # Permite elegir que parametro van a ser modificados
      if !params['nombre'].nil?
        datos.store('nombre',params['nombre'])
      end

      if !params['descripcion'].nil?
        datos.store('descripcion',params['descripcion'])
      end

      if !params['precioKg'].nil?
        datos.store('precioKg',params['precioKg'])
      end

      if !params['stock'].nil?
        datos.store('stock',params['stock'])
      end

      if !params['ofertas'].nil?
        datos.store('ofertas',params['ofertas'])
      end

      if !params['proovedor_id'].nil?
        datos.store('proovedor_id',params['proovedor_id'])
      end

      begin
        p = @@producto_bo.update(datos,request.env['HTTP_X_AUTH_TOKEN'])
        status 200
        content_type :json
        p.to_json
      rescue CustomMsgException => e
        status e.status
        e.message
      end
    end
  end

  # Borra un producto del sistema. Si no existe devuelve un 404
  delete '/:id' do
    begin
      msg = @@producto_bo.delete(params['id'],request.env['HTTP_X_AUTH_TOKEN'])
      status 200
      msg
    rescue CustomMsgException => e
      status e.status
      e.message
    end
  end
end