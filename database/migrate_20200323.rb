require 'active_record'

unless $_api_root_path
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: './production.sqlite3')
else
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: File.join($_api_root_path,'/database/production.sqlite3'))
end

class CreateUserTable < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |table|
      table.string :name,index: {unique: true}
      table.string :email
      table.string :phone
      table.string :password_digest
      table.string :remember_token,index: {unique: true}
      table.timestamps
    end
  end
end

# Create the table
CreateUserTable.migrate(:up)

# Drop the table
# CreateUserTable.migrate(:down)