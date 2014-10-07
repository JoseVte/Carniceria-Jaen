require 'rubygems'
require 'bundler'

#para que cuando se ejecute encuentre las rutas relativas a la raíz del proyecto
$LOAD_PATH << File.expand_path(__dir__)

#puts $LOAD_PATH

=begin Descomentar en un futuro

require 'app/api/carniceria_api'
require 'app/api/autentificacion_api'


map '/api/carniceria' do
  use Rack::Session::Pool
  run ProyectosAPI
end

map '/api/autentificacion' do
  use Rack::Session::Pool
  run AutentificacionAPI
end
=end