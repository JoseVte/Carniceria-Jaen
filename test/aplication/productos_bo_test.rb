require 'minitest/autorun'
require 'json'
require 'database_cleaner'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/aplicacion/producto_bo'

# Testea todos los metodos de la clase ProductoBO
class ProductosBOTest < MiniTest::Test

  @@prod_bo = ProductoBO.new

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

  # Test para listar los productos en oferta
  def test_bo_producto_ofertas
    lista = @@prod_bo.ofertas()
    assert_equal 1, lista.length
  end

  # Test para buscar un producto a partir de una subcadena
  def test_bo_producto_buscar
    lista = @@prod_bo.select_by_nombre('ja')
    assert_equal 2, lista.length
  end

  # Test para listar todos los productos
  def test_bo_producto_all
    lista = @@prod_bo.all()
    assert_equal 2, lista.length
  end

  # Test para listar un producto
  def test_bo_producto_find
    p = @@prod_bo.find_by_id(1)
    assert_equal 'Jamon serrano',p.nombre
  end

  # Test error al buscar un producto
  def test_bo_producto_error_find_no_exist
    e = assert_raises CustomMsgException  do
      @@prod_bo.find_by_id(0)
    end
    assert_equal 'Error 404: No existe el producto con id 0',e.message
  end

  # Test para crear un producto
  def test_bo_producto_new
    datos = {:nombre => 'Test',
             :descripcion => '',
             :precioKg => 0,
             :stock => 1,
             :ofertas => false
    }

    p = @@prod_bo.create(datos,'root')
    assert_equal 'Test', p.nombre
  end

  # Test para el error al crear un producto
  def test_bo_producto_error_new_data_error
    datos = {}

    e = assert_raises CustomMsgException do
      @@prod_bo.create(datos,'root')
    end
    assert_equal 'Error 400: Los datos son incorrectos', e.message
  end

  # Test para modificar un producto
  def test_bo_producto_update
    datos = {:id => 1,
             :nombre => 'Test 2',
             :precioKg => 0
    }

    p = @@prod_bo.update(datos,'root')
    assert_equal 'Test 2', p.nombre
  end

  # Test para modificar un producto
  def test_bo_producto_error_update_no_exist
    datos = {:id => 0,
             :nombre => 'Test 2',
             :precioKg => 0
    }

    e = assert_raises CustomMsgException do
      @@prod_bo.update(datos,'root')
    end
    assert_equal 'Error 404: No existe el producto con id 0', e.message
  end

  # Test para borrar un producto de la BD
  def test_bo_producto_delete
    msg = @@prod_bo.delete(1,'root')
    assert_equal 'Se ha borrado correctamente el producto 1', msg
  end

  # Test para comprobar si el producto no existe al borrar
  def test_bo_producto_error_delete_no_exist
    e = assert_raises CustomMsgException do
      @@prod_bo.delete(0,'root')
    end
    assert_equal 'Error 404: No existe el producto con id 0', e.message
  end
end