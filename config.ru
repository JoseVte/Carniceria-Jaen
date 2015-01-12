require 'rubygems'
require 'bundler'

#para que cuando se ejecute encuentre las rutas relativas a la raíz del proyecto
$LOAD_PATH << File.expand_path(__dir__)

#puts $LOAD_PATH

require 'app/api/productos_api'
require 'app/api/usuarios_api'
require 'app/api/proovedor_api'
require 'app/api/autentificacion_api'
require 'app/web/servidor_web'

use Rack::Session::Pool

map '/api' do
  # URI de la API de productos
  map '/producto' do
    run ProductosAPI
  end

  # URI de la API de usuarios y carritos
  map '/usuario' do
    run UsuariosAPI
  end

  # URI de la API de proovedores
  map '/proovedor' do
    run ProovedorAPI
  end

  # URI de la API de autentificacion
  map '/autentificacion' do
    run AutentificacionAPI
  end
end

map '/web' do
  run ServidorWeb
end