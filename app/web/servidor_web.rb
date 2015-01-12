require 'sinatra/base'
require 'sinatra/reloader'
require 'rmagick'

class ServidorWeb < Sinatra::Base
  get '/' do
    redirect to('/index.html')
  end

  post '/upload' do
    # TODO preguntar porque no guarda la imagen
    url = params['url']
    uri = params['src']

    image = Magick::Image.from_blob(Base64.decode64(uri))
    image[0].write(url) {
      self.format = "png"
    }
  end

end