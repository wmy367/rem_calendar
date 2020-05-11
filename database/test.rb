require 'active_record'
unless $_api_root_path
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: './production.sqlite3')
else
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: File.join($_api_root_path,'/database/production.sqlite3'))
end

class User < ActiveRecord::Base

end

def test_create 
    User.create(name: "First",email: "wmy367@gmail.com",remember_token:"090hsdhaguygeyfey")
end

def test_degist
    user = User.find_by(name: "wmy")
    # puts User.encrypt("90909090")
    user.password_digest  = Digest::SHA1.hexdigest('123456'.to_s)
    puts user.to_json
    puts user.save

end

def test_date

end

# test_create
test_degist
