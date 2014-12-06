require 'minitest/autorun'
require 'json'
require 'database_cleaner'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/aplicacion/carrito_bo'

# Testea todos los metodos de la clase CarritoBO
class CarritosBOTest < MiniTest::Test

  @@carrito_bo = CarritoBO.new
  @@token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwidXNlciI6InJvb3QiLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTAkRExsME1BdHp4L3Yva0pkMURvMjUuZVY5ME5xRi9qVk1CUUhuaFUzcFY1bm1peURocllzQ3UiLCJub21icmUiOiJBZG1pbml0cmFkb3IiLCJhcGVsbGlkb3MiOiJkZWwgc2lzdGVtYSIsImVtYWlsIjoicm9vdEByb290LnN1IiwiZGlyZWNjaW9uIjoicm9vdCIsInRlbGVmb25vIjoiOTg3NjU0MzIxIiwidXJsX2ltYWdlbiI6Ii9hc3NldHMvaW1hZ2VzL21pc3NpbmdfdXNlci5wbmcifQ.F-wE8joK_Hs6odNsx7gZItTSmL8t8HJ_TqABOOP32vk'

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

  # Test para comprobar todo el carrito de un usuario
  def test_bo_carrito_all
    lista = @@carrito_bo.all('root',@@token)
    assert_equal 1, lista.length
  end

  # Test para comprobar si no existe el usuario
  def test_bo_carrito_all_error_user_no_exist
    e = assert_raises CustomMsgException  do
      @@carrito_bo.all('noExiste',@@token)
    end
    assert_equal 'Error 404: No existe el usuario noExiste',e.message
  end

  # Test para añadir un producto al carrito
  def test_bo_carrito_add_producto_to_carrito
    datos = { :carrito_id => 1,
              :producto_id => 2
    }
    msg = @@carrito_bo.add_prod_en_carrito(datos,@@token)
    assert_equal 'Añadido el producto 2 al carrito',msg
  end

  # Test para comprobar si el usuario no existe
  def test_bo_carrito_add_producto_to_carrito_error_user_no_exist
    datos = { :carrito_id => 2,
              :producto_id => 2
    }
    e = assert_raises CustomMsgException  do
      @@carrito_bo.add_prod_en_carrito(datos,@@token)
    end
    assert_equal 'Error 404: No existe el usuario con id 2',e.message
  end

  # Test para comprobar si el producto no existe
  def test_bo_carrito_add_producto_to_carrito_error_prod_no_exist
    datos = { :carrito_id => 1,
              :producto_id => 0
    }
    e = assert_raises CustomMsgException  do
      @@carrito_bo.add_prod_en_carrito(datos,@@token)
    end
    assert_equal 'Error 404: No existe el producto 0', e.message
  end

  # Test para borrar un producto del carrito
  def test_bo_carrito_delete_producto_to_carrito
    msg = @@carrito_bo.delete_prod_en_carrito('root',1,@@token)
    assert_equal 'Se ha eliminado el producto 1 del carrito', msg
  end

  # Test para comprobar si el usuario no existe
  def test_bo_carrito_delete_producto_to_carrito_error_user_no_exist
    e = assert_raises CustomMsgException  do
      @@carrito_bo.delete_prod_en_carrito('noExiste',1,@@token)
    end
    assert_equal 'Error 404: No existe el usuario noExiste', e.message
  end

  # Test para comprobar si el producto no existe
  def test_bo_carrito_delete_producto_to_carrito_error_prod_no_exist
    e = assert_raises CustomMsgException  do
      @@carrito_bo.delete_prod_en_carrito('root',0,@@token)
    end
    assert_equal 'Error 404: No existe el producto 0', e.message
  end

  # Test para borrar todo el carrito
  def test_bo_carrito_delete_all_carrito
    msg = @@carrito_bo.delete_all_carrito('root',@@token)
    assert_equal 'Se han eliminado todos los productos del carrito', msg
  end

  # Test para comprobar si el usuario no existe
  def test_bo_carrito_delete_all_carrito_error_user_no_exist
    e = assert_raises CustomMsgException  do
      @@carrito_bo.delete_all_carrito('noExiste',@@token)
    end
    assert_equal 'Error 404: No existe el usuario noExiste', e.message
  end

  # Test para comprar todo
  def test_bo_carrito_comprar
    msg = @@carrito_bo.comprar('root',@@token)
    assert_equal 'Se han comprado todos los productos', msg
  end

  # Test para comprobar si el usuario no existe
  def test_bo_carrito_comprar_error_user_no_exist
    e = assert_raises CustomMsgException  do
      @@carrito_bo.comprar('noExiste',@@token)
    end
    assert_equal 'Error 404: No existe el usuario noExiste', e.message
  end

  # Test para comprobar si el carrito esta vacio
  def test_bo_carrito_comprar_error_carrito_empty
    e = assert_raises CustomMsgException  do
      @@carrito_bo.delete_all_carrito('root',@@token)
      @@carrito_bo.comprar('root',@@token)
    end
    assert_equal 'Error 400: El carrito esta vacio', e.message
  end
end