require 'minitest/autorun'
require 'rack/test'
require 'mocha/mini_test'
require 'sinatra/activerecord'
require 'database_cleaner'
require 'json'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/api/proovedor_api'

# Testea todos los metodos de la clase ProovedorAPI
class ProovedorAPITest < MiniTest::Test
  include Rack::Test::Methods

  @@token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwidXNlciI6InJvb3QiLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTAkRExsME1BdHp4L3Yva0pkMURvMjUuZVY5ME5xRi9qVk1CUUhuaFUzcFY1bm1peURocllzQ3UiLCJub21icmUiOiJBZG1pbml0cmFkb3IiLCJhcGVsbGlkb3MiOiJkZWwgc2lzdGVtYSIsImVtYWlsIjoicm9vdEByb290LnN1IiwiZGlyZWNjaW9uIjoicm9vdCIsInRlbGVmb25vIjoiOTg3NjU0MzIxIiwidXJsX2ltYWdlbiI6Ii9hc3NldHMvaW1hZ2VzL21pc3NpbmdfdXNlci5wbmcifQ.F-wE8joK_Hs6odNsx7gZItTSmL8t8HJ_TqABOOP32vk'

  # API a testear
  def app
    ProovedorAPI
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

  # Test para buscar un proovedor a partir de una cadena en un campo
  def test_api_proovedor_find_field
    get '/buscar/nombreEmpresa/Josrom'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal datos['total'], 1
  end

  # Test para buscar un proovedor a partir de una subcadena
  def test_api_proovedor_find_field_no_exist
    get '/buscar/noExiste/Josrom'
    assert_equal 404, last_response.status
    datos = last_response.body
    assert_equal 'Error 404: El campo noExiste no existe',datos
  end

  # Test para comprobar la llamada a la API de todos los proovedors
  def test_api_proovedor_all
    get '/all'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal datos['total'], 1
  end

  # Test para comprobar la seleccion de un proovedor que existe
  def test_api_proovedor_find_id
    get '/1'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal 1, datos['id']
  end

  # Test para comprobar que pasa si el proovedor no existe
  def test_api_proovedor_error_find_id_no_exist
    get '/0'
    assert_equal 404, last_response.status
    datos = last_response.body
    assert_equal datos, 'Error 404: No existe el proovedor con id 0'
  end

  # Test para comprobar si se crea correctamente un proovedor desde la API
  def test_api_proovedor_new
    p = {:nombreEmpresa => 'Test',
         :email => 'a@a.a',
         :direccion => '123',
         :telefono => '678123654'
    }

    post '/new', p, 'HTTP_X_AUTH_TOKEN'=> @@token

    assert_equal 201, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal 'Test', datos['nombreEmpresa']
  end

  # Test para comprobar que se han introducido correctamente los datos en el formulario
  def test_api_proovedor_error_new_data_error
    p = {:nombre => 'Test'}

    post '/new', p, 'HTTP_X_AUTH_TOKEN'=> @@token

    assert_equal 400, last_response.status
    datos = last_response.body
    assert_equal 'Error 400: Los datos son incorrectos',datos
  end

  # Test para actualizar algun campo de un proovedor
  def test_api_proovedor_update
    p = {:id => 1,
         :nombre => 'Test'
    }

    post '/update', p, 'HTTP_X_AUTH_TOKEN'=> @@token

    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal 'Test', datos['nombre']
  end

  # Test para comprobar si el proovedor a modificar no existe
  def test_api_proovedor_error_update_no_exist
    p = {:id => 0,
         :nombre => 'Test'
    }

    post '/update', p, 'HTTP_X_AUTH_TOKEN'=> @@token

    assert_equal 404, last_response.status
    datos = last_response.body
    assert_equal datos,'Error 404: No existe el proovedor con id 0'
  end

  # Test para comprobar que se han introducido correctamente los datos en el formulario
  def test_api_proovedor_error_update_data_error
    p = {:nombre => 'Test'}
    post '/update', p, 'HTTP_X_AUTH_TOKEN'=> @@token

    assert_equal 400, last_response.status
    datos = last_response.body
    assert_equal 'Error 400: Falta el id en el formulario',datos
  end

  # Test para comprobar si se borra el proovedor
  def test_api_proovedor_delete
    delete '/1','', 'HTTP_X_AUTH_TOKEN'=> @@token
    assert_equal 200, last_response.status
    datos = last_response.body
    assert_equal 'Se ha borrado correctamente el proovedor 1', datos
  end

  # Test para comprobar al borrar si no existe el proovedor
  def test_api_proovedor_error_delete_no_exist
    delete '/0','', 'HTTP_X_AUTH_TOKEN'=> @@token
    assert_equal 404, last_response.status
    datos = last_response.body
    assert_equal 'Error 404: No existe el proovedor con id 0', datos
  end
end