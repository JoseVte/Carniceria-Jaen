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
  def test_all
    get '/all'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal datos.length, 1
  end

  # Test para comprobar la seleccion de un usuario que existe
  def test_find_user
    get '/root'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal 'root', datos['user']
  end

  # Test para comprobar que pasa si el usuario no existe
  def test_error_find_user_no_exist
    get '/noExiste'
    assert_equal 404, last_response.status
    datos = last_response.body
    assert_equal datos, 'No existe el usuario'
  end

=begin
  # Test para comprobar si se crea correctamente un usuario desde la API
  def test_new_user
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

  def test_error_new_user_exist

  end

  def test_update_user

  end

  def test_error_update_user_no_exist

  end

  def test_error_update_user_new_exist

  def test_delete_user

  end

  def test_error_delete_user_no_exist

  end
=end
end