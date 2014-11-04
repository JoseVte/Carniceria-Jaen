require 'minitest/autorun'
require 'json'
require 'database_cleaner'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/aplicacion/producto_bo'

class ProductosBOTest < MiniTest::Test

  @@prod_bo = ProductoBO.new

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
  def test_bo_listar_ofertas
    lista = @@prod_bo.ofertas()
    assert_equal 1, lista.length
  end

  # Test para buscar un producto a partir de una subcadena
  def test_bo_buscar_prod
    lista = @@prod_bo.busqueda('ja')
    assert_equal 2, lista.length
  end

  # Test para listar todos los productos
  def test_bo_listar_todos
    lista = @@prod_bo.all()
    assert_equal 2, lista.length
  end

  # Test para listar un producto
  def test_bo_listar_id
    p = @@prod_bo.ver_producto(1)
    assert_equal 'Jamon serrano',p.nombre
  end

  # Test error al buscar un producto
  def test_bo_error_listar_id
    e = assert_raises CustomMsgException  do
      @@prod_bo.ver_producto(0)
    end
    assert_equal 'Error 404: No existe el producto con id 0',e.message
  end

  # Test para crear un producto
  def test_bo_crear_producto
    datos = {:nombre => 'Test',
             :descripcion => '',
             :precioKg => 0,
             :stock => 1,
             :ofertas => false
    }

    p = @@prod_bo.crear_producto(datos,'login')
    assert_equal 'Test', p.nombre
  end

  # Test para el error al crear un producto
  def test_bo_error_crear_producto
    datos = {}

    e = assert_raises CustomMsgException do
      @@prod_bo.crear_producto(datos,'login')
    end
    assert_equal 'Error 400: Los datos son incorrectos', e.message
  end

  # Test para modificar un producto
  def test_bo_modificar_producto
    datos = {:id => 1,
             :nombre => 'Test 2',
             :precioKg => 0
    }

    p = @@prod_bo.modificar_producto(datos,'login')
    assert_equal 'Test 2', p.nombre
  end

  # Test para modificar un producto
  def test_bo_modificar_producto_error_no_exist
    datos = {:id => 0,
             :nombre => 'Test 2',
             :precioKg => 0
    }

    e = assert_raises CustomMsgException do
      @@prod_bo.modificar_producto(datos,'login')
    end
    assert_equal 'Error 404: No existe el producto con id 0', e.message
  end

  # Test para borrar un producto de la BD
  def test_bo_delete_user
    msg = @@prod_bo.borrar_producto(1,'login')
    assert_equal 'Se ha borrado correctamente el producto 1', msg
  end

  # Test para comprobar si el producto no existe al borrar
  def test_bo_delete_user_no_exist
    e = assert_raises CustomMsgException do
      @@prod_bo.borrar_producto(0,'login')
    end
    assert_equal 'Error 404: No existe el producto con id 0', e.message
  end
end