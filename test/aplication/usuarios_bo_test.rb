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



end