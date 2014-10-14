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

  def test_ofertas
    p = Producto.new
    p.id = 1
    p.nombre = "Producto 1"
    p.descripcion = "Descripción 1"
    p.precioKg = 1
    p.stock = 1
    p.ofertas = true
    #ProductoBO.any_instance.expects(:ofertas).returns([p])


    get '/ofertas'
    assert_equal last_response.status, 200
    datos = JSON.parse(last_response.body)
    assert_equal datos.length, 1
  end

end