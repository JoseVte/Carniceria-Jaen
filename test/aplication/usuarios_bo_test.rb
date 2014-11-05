require 'minitest/autorun'
require 'database_cleaner'
require 'json'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/aplicacion/usuario_bo'

# Testea todos los metodos de la clase UsuariosBO
class UsuariosBOTest < MiniTest::Test

  @@users_bo = UsuarioBO.new

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

  # Test de listado total de los usuarios
  def test_bo_listar_todos
    lista = @@users_bo.all
    assert_equal 1, lista.length
  end

  # Test para buscar un usuario en la BD
  def test_bo_find_user
    u = @@users_bo.ver_usuario 'root'
    assert_equal 'root', u.user
  end

  # Test para comprobar si no existe el usuario
  def test_bo_find_user_no_exist
    e = assert_raises CustomMsgException do
      @@users_bo.ver_usuario 'noExiste'
    end
    assert_equal 'Error 404: No existe el usuario noExiste', e.message
  end

  # Test para crear un usuario en la BD
  def test_bo_new_user
    datos = {:user => 'Test',
             :pass => 'Test',
             :nombre => 'Test',
             :apellidos => 'de prueba',
             :email => 'a@a.a',
             :direccion => 'Test',
             :telefono => '123456789'
    }

    u = @@users_bo.crear_usuario(datos,'login')
    assert_equal 'Test', u.user
  end

  # Test para comprobar si ya existe el usuario
  def test_bo_new_user_exist
    datos = {:user => 'root',
             :pass => 'Test',
             :nombre => 'Test',
             :apellidos => 'de prueba',
             :email => 'a@a.a',
             :direccion => 'Test',
             :telefono => '123456789'
    }
    e = assert_raises CustomMsgException do
      @@users_bo.crear_usuario(datos,'login')
    end
    assert_equal 'Error 400: El usuario root ya existe', e.message
  end

  # Test para comprobar que los datos esta bien introducidos
  def test_bo_new_user_data_error
    datos = {:user => 'Test',
             :email => 'root@root.su'
    }
    e = assert_raises CustomMsgException do
      @@users_bo.crear_usuario(datos,'login')
    end
    assert_equal 'Error 400: Los datos son incorrectos', e.message
  end

  # Test para modificar los datos de un usuario
  def test_bo_update_user
    datos = {:user => 'root',
             :email => 'a@a.a'
    }

    u = @@users_bo.modificar_usuario(datos,'login')
    assert_equal 'a@a.a', u.email
  end

  # Test para comprobar si el usuario no existe
  def test_bo_update_user_no_exist
    datos = {:user => 'noExiste',
             :email => 'a@a.asdf'
    }

    e = assert_raises CustomMsgException do
      @@users_bo.modificar_usuario(datos,'login')
    end
    assert_equal 'Error 404: No existe el usuario noExiste', e.message
  end

  # Test para borrar un usuario de la BD
  def test_bo_delete_user
    msg = @@users_bo.borrar_usuario('root','login')
    assert_equal 'Se ha borrado correctamente el usuario root', msg
  end

  # Test para comprobar si el usuario no existe al borrar
  def test_bo_delete_user_no_exist
    e = assert_raises CustomMsgException do
      @@users_bo.borrar_usuario('noExiste','login')
    end
    assert_equal 'Error 404: No existe el usuario noExiste', e.message
  end
end