require 'minitest/autorun'
require 'json'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/aplicacion/producto_bo'

class ProductosBOTest < MiniTest::Test

  def setup
    ActiveRecord::Base.establish_connection(
        :adapter => "sqlite3",
        #cuidado, el path de la BD es relativo al fichero actual (__FILE__)
        #si cambiáis de sitio el test, habrá que cambiar el path
        :database  => File.join(File.dirname(__FILE__),'..', '..','db','cf_test.sqlite3')
    )
  end

  def test_listar_ofertas
    prod_bo = ProductoBO.new
    lista = prod_bo.ofertas()
    assert_equal 1, lista.length
  end

end