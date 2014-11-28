require 'sinatra/base'
require 'sinatra/reloader'

class ServidorWeb < Sinatra::Base
  get '/' do
    redirect to('/index.html')
  end

  post '/upload' do
    datos = JSON.parse(request.body.read)
    # TODO preguntar porque no guarda la imagen
    imagen = File.new(datos['imagen']['path'], 'w')
    imagen.puts(datos['imagen']['tempfile'].read)
    imagen.close
  end

end