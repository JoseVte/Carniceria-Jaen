#añade al LOAD_PATH el directorio donde está este rakefile
#así no es necesario rake -I.
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra/activerecord/rake'
require 'sinatra/activerecord'
require 'rake/testtask'

#rake debe conocer la estructura de los objetos del dominio para poder cargar las 'fixtures'
Dir[File.dirname(__FILE__) + '/app/dominio/*.rb'].each {|file| require file }

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*/*_test.rb']
  t.libs << '.'
  t.verbose = true
end

