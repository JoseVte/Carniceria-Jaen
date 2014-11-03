require 'minitest/autorun'
require 'rack/test'
require 'mocha/mini_test'
require 'database_cleaner'
require 'sinatra/activerecord'
require 'json'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/api/usuarios_api'

class UsuariosAPITest < MiniTest::Test
  include Rack::Test::Methods

  def app
    UsuariosAPI
  end

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

  # Test para comprobar la llamada a la API de todos los usuarios
  def test_api_all
    get '/all'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal datos.length, 1
  end

  # Test para comprobar la seleccion de un usuario que existe
  def test_api_find_user
    get '/root'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal 'root', datos['user']
  end

  # Test para comprobar que pasa si el usuario no existe
  def test_api_error_find_user_no_exist
    get '/noExiste'
    assert_equal 404, last_response.status
    datos = last_response.body
    assert_equal datos, 'Error 404: No existe el usuario noExiste'
  end

=begin
  # Test para comprobar si se crea correctamente un usuario desde la API
  def test_api_new_user
    u = Usuario.new
    u.user = 'Test'
    u.pass = 'Test'
    u.email = 'a@a.a'
    u.nombre = 'Test'
    u.apellidos = 'de prueba'
    u.direccion = 'Test'
    u.telefono = '123321123'

    u = {:user => 'Test',
         :pass => 'Test',
         :nombre => 'Test',
         :apellidos => 'de prueba',
         :email => 'a@a.a',
         :direccion => 'Test',
         :telefono => '123456789'
    }

    post '/new', u.to_json

    assert_equal 201, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal 'Test', datos['user']
  end
=end
=begin
  # Test para comprobar si el nuevo usuario ya existia
  def test_api_error_new_user_exist
    u = Usuario.new
    u.user = 'root'
    u.pass = 'Test'
    u.email = 'a@a.a'
    u.nombre = 'Test'
    u.apellidos = 'de prueba'
    u.direccion = 'Test'
    u.telefono = '123321123'

    u = {:user => 'Test',
         :pass => 'Test',
         :nombre => 'Test',
         :apellidos => 'de prueba',
         :email => 'a@a.a',
         :direccion => 'Test',
         :telefono => '123456789'
    }

    post '/new', u.to_json

    assert_equal 400, last_response.status
    datos = last_response.body
    assert datos.include? 'Error 400: El usuario Test ya existe'
  end
=end

  # Test para comprobar que se han introducido correctamente los datos en el formulario
  def test_api_error_new_user_data_error
    u = Usuario.new
    u.user = 'error'
    u.pass = 'Test'

    post '/new', u.to_json

    assert_equal 400, last_response.status
    datos = last_response.body
    assert_equal 'Error 400: Los datos son incorrectos',datos
  end

=begin
  # Test para actualizar algun campo de un usuario
  def test_api_update_user
    u = Usuario.new
    u.user = 'root'
    u.pass = 'cambioPass'

    post '/update', u.to_json

    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal 'cambioPass', datos['pass']
  end
=end
=begin
  # Test para comprobar si el usuario a modificar no existe
  def test_api_error_update_user_no_exist
    u = Usuario.new
    u.user = 'error'
    u.pass = 'cambioPass'

    post '/update', u.to_json

    assert_equal 404, last_response.status
    datos = last_response.body
    assert_equal datos, 'Error 404: No existe el usuario'
  end
=end

  # Test para comprobar que se han introducido correctamente los datos en el formulario
  def test_api_error_update_user_data_error
    u = Usuario.new
    u.user = 'error'
    u.pass = 'Test'

    post '/update', u.to_json

    assert_equal 400, last_response.status
    datos = last_response.body
    assert_equal 'Error 400: Falta el usuario en el formulario',datos
  end

  # Test para comprobar si se borra el usuario
  def test_api_delete_user
    delete '/root'
    assert_equal 200, last_response.status
    datos = last_response.body
    assert_equal 'Se ha borrado correctamente el usuario root', datos
  end

  # Test para comprobar al borrar si no existe el usuario
  def test_api_error_delete_user_no_exist
    delete '/noExiste'
    assert_equal 404, last_response.status
    datos = last_response.body
    assert_equal 'Error 404: No existe el usuario noExiste', datos
  end
end