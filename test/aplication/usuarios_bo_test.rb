require 'minitest/autorun'
require 'json'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/aplicacion/usuario_bo'

class UsuariosBOTest < MiniTest::Test

  @@users_bo = UsuarioBO.new

  def setup
    ActiveRecord::Base.establish_connection(
        :adapter => "sqlite3",
        #cuidado, el path de la BD es relativo al fichero actual (__FILE__)
        #si cambiáis de sitio el test, habrá que cambiar el path
        :database  => File.join(File.dirname(__FILE__),'..', '..','db','cf_test.sqlite3')
    )
  end

  # Test de listado total de los usuarios
  def test_listar_todos
    lista = @@users_bo.all
    assert_equal 1, lista.length
  end

  # Test para buscar un usuario en la BD
  def test_find_user
    u = @@users_bo.ver_usuario 'root'
    assert_equal 'root', u.user
  end

  # Test para comprobar si no existe el usuario
  def test_find_user_no_exist
    e = assert_raises CustomMsgException do
      @@users_bo.ver_usuario 'noExiste'
    end
    assert_equal 'Error 404: No existe el usuario noExiste', e.message
  end
end