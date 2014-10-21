require 'rubygems'
require 'bundler'

#para que cuando se ejecute encuentre las rutas relativas a la raíz del proyecto
$LOAD_PATH << File.expand_path(__dir__)

#puts $LOAD_PATH

require 'app/api/productos_api'
require 'app/api/usuarios_api'
#require 'app/api/autentificacion_api'


map '/api/producto' do
  use Rack::Session::Pool
  run ProductosAPI
end

map '/api/usuario' do
  use Rack::Session::Pool
  run UsuariosAPI
end

=begin
map '/api/autentificacion' do
  use Rack::Session::Pool
  run AutentificacionAPI
end
=end