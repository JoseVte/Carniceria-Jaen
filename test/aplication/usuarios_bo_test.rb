require 'minitest/autorun'
require 'json'
require_relative '../test_helper' #para poder ejecutar los test desde RubyMine
require 'app/aplicacion/usuario_bo'

class UsuariosBOTest < MiniTest::Test

  def setup
    ActiveRecord::Base.establish_connection(
        :adapter => "sqlite3",
        #cuidado, el path de la BD es relativo al fichero actual (__FILE__)
        #si cambiáis de sitio el test, habrá que cambiar el path
        :database  => File.join(File.dirname(__FILE__),'..', '..','db','cf_test.sqlite3')
    )
  end

  # Test de listado total de los usuarios
  def test_listar_todo
    us_bo = UsuarioBO.new
    lista = us_bo.usuarios
    assert_equal 1, lista.length
  end

end