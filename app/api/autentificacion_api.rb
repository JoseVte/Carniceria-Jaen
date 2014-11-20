require 'sinatra/base'
require 'sinatra/reloader'
require 'json'
require 'app/aplicacion/usuario_bo'

# API para el login de los Usuario
class AutentificacionAPI < Sinatra::Base
  
  # Configuracion inicial
  configure do
    register Sinatra::ActiveRecordExtension
    puts 'activando autentificacion...'
    @@usuario_bo = UsuarioBO.new
  end

  # Configuracion mientras se esta desarrollando
  configure :development do
    puts 'activando reloader de autentificacion...'
    register Sinatra::Reloader
  end

  # Metodo para loguearte
  post '/login' do
    begin
      datos = JSON.parse(request.body.read)
      if datos['login'] && datos['password']
        begin
          token = @@usuario_bo.login(datos['login'], datos['password'])
          status 200
          content_type :json
          {
              :user => @@usuario_bo.find_by_user(datos['login'],token),
              :token => token
          }.to_json
        rescue CustomMsgException => e
          status e.status
          e.message
        end
      else
        status 400
        'Falta el login y/o password'
      end
    rescue JSON::ParserError
      status 400
      'JSON incorrecto'
    end
  end

  # Metodo para desloguearse
  get '/logout' do
    status 200
  end
end