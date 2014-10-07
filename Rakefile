#añade al LOAD_PATH el directorio donde está este rakefile
#así no es necesario rake -I.
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rake/testtask'


Rake::TestTask.new do |t|
  t.test_files = FileList['test/*/*_test.rb']
  t.libs << '.'
  t.verbose = true
end

