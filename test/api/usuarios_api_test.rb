require 'minitest/autorun'
require 'rack/test'
require 'mocha/mini_test'
require 'sinatra/activerecord'
require 'json'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/api/usuarios_api'

class UsuariosAPITest < MiniTest::Test
  include Rack::Test::Methods

  def app
    UsuariosAPI
  end

  # Test para comprobar la llamada a la API de todos los usuarios
  def test_all
    get '/all'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal datos.length, 1
  end

  def test_find_user
    get '/root'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal datos.user, root
  end

  def test_error_find_user_no_exist
    get '/noExiste'
    assert_equal 404, last_response.status
    datos = last_response.body
    assert_equal datos, 'No existe el usuario'
  end

  def test_new_user

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