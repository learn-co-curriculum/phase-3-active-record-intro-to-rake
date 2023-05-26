desc 'Output hello to the terminal'
task :hello do
  puts "hello from Rake!"
end

desc 'output Niaje to the terminal'
task :niaje do
  puts "Niaje de Rake!"
end

#namespace both hello and niaje under the greeting heading:

namespace :greeting do
  desc 'outputs hello to the terminal'
  task :hello do
    puts "hello from rake!"
  end

  desc 'outputs Niaje to the terminal'
  task :niaje do
    puts "Niaje de Rake!"
  end

end

# rake db:migrate
namespace :db do
  desc 'migrate changes to your database'
  task migrate: :environment do#this line creates 
    Student.create_table
  end
end

#Task Dependancy

task :environment do
  require_relative './config/environment'
end

#rake db:seed
namespace :db do
  desc 'seed the database with some dummy data'
  task seed: :environment do
      require_relative './db/seeds'
  end
end