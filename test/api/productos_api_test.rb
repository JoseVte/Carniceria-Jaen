require 'minitest/autorun'
require 'rack/test'
require 'mocha/mini_test'
require 'sinatra/activerecord'
require 'database_cleaner'
require 'json'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/api/productos_api'

# Testea todos los metodos de la clase ProductosAPI
class ProductosAPITest < MiniTest::Test
  include Rack::Test::Methods

  # API a testear
  def app
    ProductosAPI
  end

  # Configuracion de la BD
  def setup
    ActiveRecord::Base.establish_connection(
        :adapter => "sqlite3",
        #cuidado, el path de la BD es relativo al fichero actual (__FILE__)
        #si cambiáis de sitio el test, habrá que cambiar el path
        :database  => File.join(File.dirname(__FILE__),'..', '..','db','cf_test.sqlite3')
    )
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  # Test para comprobar la llamada desde la API a las ofertas
  def test_api_producto_ofertas
    get '/ofertas'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal datos.length, 1
  end

  # Test para buscar un producto a partir de una subcadena
  def test_api_producto_buscar
    get '/buscar/ja'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal datos['total'], 2
  end

  # Test para buscar un producto a partir de una subcadena
  def test_api_producto_proovedor
    get '/proovedor/1'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal datos['total'], 2
  end

  # Test para comprobar la llamada a la API de todos los productos
  def test_api_producto_all
    get '/all'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal datos['total'], 2
  end

  # Test para comprobar la seleccion de un producto que existe
  def test_api_producto_find
    get '/1'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal 1, datos['id']
  end

  # Test para comprobar que pasa si el producto no existe
  def test_api_producto_error_find_no_exist
    get '/0'
    assert_equal 404, last_response.status
    datos = last_response.body
    assert_equal datos, 'Error 404: No existe el producto con id 0'
  end

  # Test para comprobar si se crea correctamente un producto desde la API
  def test_api_producto_new
    p = {:nombre => 'Test',
         :precioKg => 2
    }

    post '/new', p, 'rack.session'=>{:usuario=>'root'}

    assert_equal 201, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal 'Test', datos['nombre']
  end

  # Test para comprobar que se han introducido correctamente los datos en el formulario
  def test_api_producto_error_new_data_error
    p = {:nombre => 'Test'}

    post '/new', p, 'rack.session'=>{:usuario=>'root'}

    assert_equal 400, last_response.status
    datos = last_response.body
    assert_equal 'Error 400: Los datos son incorrectos',datos
  end

  # Test para actualizar algun campo de un producto
  def test_api_producto_update
    p = {:id => 1,
         :nombre => 'Test'
    }

    post '/update', p, 'rack.session'=>{:usuario=>'root'}

    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal 'Test', datos['nombre']
  end

  # Test para comprobar si el producto a modificar no existe
  def test_api_producto_error_update_no_exist
    p = {:id => 0,
         :nombre => 'Test'
    }

    post '/update', p, 'rack.session'=>{:usuario=>'root'}

    assert_equal 404, last_response.status
    datos = last_response.body
    assert_equal datos,'Error 404: No existe el producto con id 0'
  end

  # Test para comprobar que se han introducido correctamente los datos en el formulario
  def test_api_producto_error_update_data_error
    p = {:nombre => 'Test'}
    post '/update', p, 'rack.session'=>{:usuario=>'root'}

    assert_equal 400, last_response.status
    datos = last_response.body
    assert_equal 'Error 400: Falta el id en el formulario',datos
  end

  # Test para comprobar si se borra el producto
  def test_api_producto_delete
    delete '/1','', 'rack.session'=>{:usuario=>'root'}
    assert_equal 200, last_response.status
    datos = last_response.body
    assert_equal 'Se ha borrado correctamente el producto 1', datos
  end

  # Test para comprobar al borrar si no existe el producto
  def test_api_producto_error_delete_no_exist
    delete '/0','', 'rack.session'=>{:usuario=>'root'}
    assert_equal 404, last_response.status
    datos = last_response.body
    assert_equal 'Error 404: No existe el producto con id 0', datos
  end
end