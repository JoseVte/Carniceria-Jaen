require 'minitest/autorun'
require 'json'
require 'database_cleaner'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/aplicacion/proovedor_bo'

# Testea todos los metodos de la clase ProductoBO
class ProovedorBOTest < MiniTest::Test

  @@proov_bo = ProovedorBO.new
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

  # Test para buscar un proovedor a partir de una subcadena
  def test_bo_proovedor_buscar
    lista = @@proov_bo.select_by('nombreEmpresa', 'Josrom', {})[:datos]
    assert_equal 1, lista.length
  end

  # Test para probar si no existe el campo de busqueda
  def test_bo_proovedor_buscar_error_no_exist
    e = assert_raises CustomMsgException  do
      @@proov_bo.select_by('noExiste', 'Josrom', {})
    end
    assert_equal 'Error 404: El campo noExiste no existe',e.message
  end

  # Test para listar todos los proovedores
  def test_bo_proovedor_all
    lista = @@proov_bo.all({})[:datos]
    assert_equal 1, lista.length
  end

  # Test para listar un proovedor
  def test_bo_proovedor_find
    p = @@proov_bo.find_by_id(1)
    assert_equal 'Josrom',p.nombreEmpresa
  end

  # Test error al buscar un proovedor
  def test_bo_proovedor_error_find_no_exist
    e = assert_raises CustomMsgException  do
      @@proov_bo.find_by_id(0)
    end
    assert_equal 'Error 404: No existe el proovedor con id 0',e.message
  end

  # Test para crear un proovedor
  def test_bo_proovedor_create
    datos = {:nombreEmpresa => 'Test',
             :email => 'a@a.a',
             :direccion => '123',
             :telefono => '678123654'
    }

    p = @@proov_bo.create(datos,@@token)
    assert_equal 'Test', p.nombreEmpresa
  end

  # Test para el error al crear un proovedor
  def test_bo_proovedor_error_create_data_error
    datos = {}

    e = assert_raises CustomMsgException do
      @@proov_bo.create(datos,@@token)
    end
    assert_equal 'Error 400: Los datos son incorrectos', e.message
  end

  # Test para modificar un proovedor
  def test_bo_proovedor_update
    datos = {:id => 1,
             :nombre => 'Test 1'
    }

    p = @@proov_bo.update(datos,@@token)
    assert_equal 'Test 1', p.nombre
  end

  # Test para modificar un proovedor
  def test_bo_proovedor_update_error_no_exist
    datos = {:id => 0,
             :nombre => 'Test 2'
    }

    e = assert_raises CustomMsgException do
      @@proov_bo.update(datos,@@token)
    end
    assert_equal 'Error 404: No existe el proovedor con id 0', e.message
  end

  # Test para borrar un proovedor de la BD
  def test_bo_proovedor_delete
    msg = @@proov_bo.delete(1,@@token)
    assert_equal 'Se ha borrado correctamente el proovedor 1', msg
  end

  # Test para comprobar si el proovedor no existe al borrar
  def test_bo_proovedor_delete_no_exist
    e = assert_raises CustomMsgException do
      @@proov_bo.delete(0,@@token)
    end
    assert_equal 'Error 404: No existe el proovedor con id 0', e.message
  end
end