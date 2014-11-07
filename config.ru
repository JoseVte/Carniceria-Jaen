require 'rubygems'
require 'bundler'

#para que cuando se ejecute encuentre las rutas relativas a la raíz del proyecto
$LOAD_PATH << File.expand_path(__dir__)

#puts $LOAD_PATH

require 'app/api/productos_api'
require 'app/api/usuarios_api'
require 'app/api/proovedor_api'
require 'app/api/autentificacion_api'


# URI de la API de productos
map '/api/producto' do
  use Rack::Session::Pool
  run ProductosAPI
end

# URI de la API de usuarios y carritos
map '/api/usuario' do
  use Rack::Session::Pool
  run UsuariosAPI
end

# URI de la API de proovedores
map '/api/proovedor' do
  use Rack::Session::Pool
  run ProovedorAPI
end

# URI de la API de autentificacion
map '/api/autentificacion' do
  use Rack::Session::Pool
  run AutentificacionAPI
end