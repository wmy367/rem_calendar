require 'active_record'

unless $_api_root_path
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: './production.sqlite3')
else
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: File.join($_api_root_path,'/database/production.sqlite3'))
end

class CreateEventTable < ActiveRecord::Migration[5.2]
  def change
    change_table :events do |table|
      table.string :doneList
    end
  end
end

# Create the table
CreateEventTable.migrate(:up)

# Drop the table
# CreateEventTable.migrate(:down)