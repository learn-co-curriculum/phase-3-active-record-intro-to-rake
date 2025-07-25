require_relative '../config/environment'

RSpec.configure do |config|
  config.color = true
  config.order = 'defined'
end

def clear_database
  sql = 'DROP TABLE IF EXISTS students'
  DB[:conn].execute(sql)
end

def recreate_table
  sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
  SQL
  DB[:conn].execute(sql)
end
