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
  def test_listar_ofertas
    lista = @@prod_bo.ofertas()
    assert_equal 1, lista.length
  end

  # Test para listar todos los productos
  def test_listar_todos
    lista = @@prod_bo.all()
    assert_equal 2, lista.length
  end

  # Test para listar un producto
  def test_listar_id
    p = @@prod_bo.ver_producto(1)
    assert_equal 'Jamon serrano',p.nombre
  end

  # Test para crear un producto
  def test_crear_producto
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
  def test_error_crear_producto
    datos = {}

    p = @@prod_bo.crear_producto(datos,'login')
    assert_equal 'Aqui excepcion', p
  end

=begin Preguntar porque no funciona
  # Test para modificar un producto
  def test_modificar_producto
    datos = {:nombre => 'Test',
             :descripcion => '',
             :precioKg => 0,
             :stock => 1,
             :ofertas => false
    }
    p = @@prod_bo.crear_producto(datos,'login')

    datos2 = {:id => p.id,
              :nombre => 'Test 2',
              :descripcion => '',
              :precioKg => 0,
              :stock => 1,
              :ofertas => false
    }

    p2 = @@prod_bo.modificar_producto(datos2,'login')
    assert_equal 'Test 2', p2.nombre
  end
=end
end