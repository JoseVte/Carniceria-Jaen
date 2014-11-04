require 'minitest/autorun'
require 'json'
require 'database_cleaner'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/aplicacion/carrito_bo'

class CarritoBOTest < MiniTest::Test

  @@carrito_bo = CarritoBO.new

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

  # Test para comprobar todo el carrito de un usuario
  def test_bo_all_carrito
    lista = @@carrito_bo.all('root','login')
    assert_equal 1, lista.length
  end

  # Test para comprobar si no existe el usuario
  def test_bo_all_carrito_error_user_no_exist
    e = assert_raises CustomMsgException  do
      @@carrito_bo.all('noExiste','login')
    end
    assert_equal 'Error 404: No existe el usuario noExiste',e.message
  end

  # Test para añadir un producto al carrito
  def test_bo_add_carrito
    datos = { :usuarios_id => 1,
              :productos_id => 2
    }
    msg = @@carrito_bo.crear_prod_en_carrito(datos,'login')
    assert_equal 'Añadido el producto 2 al carrito',msg
  end

  # Test para comprobar si el usuario no existe
  def test_bo_add_carrito_error_user_no_exist
    datos = { :usuarios_id => 2,
              :productos_id => 2
    }
    e = assert_raises CustomMsgException  do
      @@carrito_bo.crear_prod_en_carrito(datos,'login')
    end
    assert_equal 'Error 404: No existe el usuario con id 2',e.message
  end

  # Test para comprobar si el producto no existe
  def test_bo_add_carrito_error_prod_no_exist
    datos = { :usuarios_id => 1,
              :productos_id => 3
    }
    e = assert_raises CustomMsgException  do
      @@carrito_bo.crear_prod_en_carrito(datos,'login')
    end
    assert_equal 'Error 404: No existe el producto 3',e.message
  end
end