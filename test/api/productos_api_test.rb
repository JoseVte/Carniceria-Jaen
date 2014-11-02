require 'minitest/autorun'
require 'rack/test'
require 'mocha/mini_test'
require 'sinatra/activerecord'
require 'json'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/api/productos_api'

class ProductosAPITest < MiniTest::Test
  include Rack::Test::Methods

  def app
    ProductosAPI
  end

  # Test para comprobar la llamada desde la API a las ofertas
  def test_ofertas
    get '/ofertas'
    assert_equal 200, last_response.status
    datos = JSON.parse(last_response.body)
    assert_equal datos.length, 1
  end

end