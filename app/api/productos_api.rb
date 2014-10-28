require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'json'

require 'app/dominio/producto'
require 'app/aplicacion/producto_bo'

#Clase principal de la API de los productos
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

  get '/all' do
    @@producto_bo.all.to_json
  end

  #Mostrar un producto
  get '/:id' do
    @@producto_bo.ver_producto(params['id']).to_json
  end

  #Crear un nuevo producto
  post '/new' do
    datos = {:nombre => params['nombre'],
             :descripcion => params['descripcion'],
             :precioKg => params['precioKg'],
             :stock => params['stock'],
             :ofertas => params['ofertas']
    }
    @@producto_bo.crear_producto(datos,'login').to_json
  end

  #Modificar un producto
  post '/update' do
    if params['id'].nil?
      'Error en el formulario'
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

      @@producto_bo.modificar_producto(datos,'login').to_json
    end
  end

  #Borrar un producto
  delete '/:id' do
    @@producto_bo.borrar_producto(params['id'])
  end
end