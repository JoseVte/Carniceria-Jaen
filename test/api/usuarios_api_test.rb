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

end