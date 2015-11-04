require 'data_mapper'

if ENV['MODE'] == 'test'
  DataMapper.setup(:default, 'mysql://root:root@localhost/flippd_test')
else
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, 'mysql://root:root@localhost/flippd')
end

# Require all of the files under /app/models/
models_directory = File.dirname(__FILE__) + "/../models/"
model_files = Dir[models_directory + "*.rb"]
model_files.each { |f| require f }

DataMapper.finalize
DataMapper.auto_upgrade!
