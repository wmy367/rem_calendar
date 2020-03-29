require 'active_record'

unless $_api_root_path
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: './production.sqlite3')
else
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: File.join($_api_root_path,'/database/production.sqlite3'))
end

class CreateEventTable < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |table|
      table.string :title
      table.text :contect
      table.boolean :deleteQ
      table.string :eventType
      table.integer :user_id, :null => false, :references => [:users, :id]
      table.datetime :eventDate
      table.timestamps
    end
  end
end

# Create the table
CreateEventTable.migrate(:up)

# Drop the table
# CreateEventTable.migrate(:down)