require 'data_mapper'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://root:root@localhost/flippd')

# Require all of the files under /app/models/
models_directory = File.dirname(__FILE__) + "/../models/"
model_files = Dir[models_directory + "*.rb"]
puts "Loading #{model_files} from #{models_directory}"
model_files.each { |f| require f }

DataMapper.finalize
DataMapper.auto_upgrade!
