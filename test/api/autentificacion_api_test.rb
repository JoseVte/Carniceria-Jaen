require 'minitest/autorun'
require 'rack/test'
require 'json'
require 'mocha/mini_test'
require 'database_cleaner'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/api/autentificacion_api'

# Testea todos los metodos de la clase AutentificacionAPI
class AutentificacionAPITest < MiniTest::Test
  include Rack::Test::Methods

  # API a testear
  def app
    AutentificacionAPI
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

  # Test para el login de un usuario
  def test_login
    post '/login', {:login=>'root', :password=>'root'}.to_json
    assert_equal 200, last_response.status
  end

  # Test para el fomarto de JSON incorrecto
  def test_login_malformed_json
    post '/login', 'hola mundo'
    assert_equal 400, last_response.status
    assert_equal 'JSON incorrecto', last_response.body
  end

  # Test para cuando el usuario no existe
  def test_login_error_user_no_exist
    post '/login', {:login=>'adi', :password=>'root'}.to_json
    assert_equal 401, last_response.status
  end

  # Test para cuando la contraseña es incorrecta
  def test_login_error_pass_incorrect
    post '/login', {:login=>'root', :password=>'ado'}.to_json
    assert_equal 401, last_response.status
  end

  # Test para cuando los datos del formulario son incorrectos
  def test_login_error_data_error
    post '/login', {:hola=>'mundo'}.to_json
    assert_equal 400, last_response.status
  end

  # Test para el logout del usuario
  def test_logout
    get '/logout', {}
    assert last_response.ok?
  end
end