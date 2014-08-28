require 'sinatra';
require 'groonga'
require 'pathname'

database_file = Pathname('groonga/database')
database_directory = database_file.dirname
database_directory.mkpath unless database_directory.exist?

if database_file.exist?
  Groonga::Database.open(database_file.to_s)
else
  Groonga::Database.create(:path => database_file.to_s)
end

if not Groonga["Items"]
  Groonga::Schema.create_table("Items", :type => :hash)
  items = Groonga["Items"]
  items.add("hello")

  Groonga::Schema.change_table("Items") do |table|
    table.text("title")
  end
  items["hello"].title = "Hello, World!"
end
  
get '/' do
  Groonga["Items"]["hello"].title
  #'Hello, World!'
end
