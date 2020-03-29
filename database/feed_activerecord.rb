require 'active_record'
unless $_api_root_path
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: './production.sqlite3')
else
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: File.join($_api_root_path,'/database/production.sqlite3'))
end

# Expects a table named `users`  by convention
# Example SQLite3 statement to create table:
# CREATE TABLE IF NOT EXISTS users (name TEXT, age INT);
# class Comment < ActiveRecord::Base
#     self.table_name = 'comments'
# end

# # puts Comment.create(context: "90",feed_id: 90)
# Comment.columns.each do |column|
#     puts column.name
# end

class Feed < ActiveRecord::Base
    has_many :comments
    has_many :fimages
end

class Comment < ActiveRecord::Base 
    belongs_to :feed
end

class Fimage < ActiveRecord::Base 
    self.table_name = 'feed_images'
    belongs_to :feed
end

module WmyFeedDB

    # 获取最新的feed,d倒序
    def self.last(num,offset=0)
        return Feed.order(:updated_at => :desc).offset(offset).first(num)
    end

    def self.find_comments_of_feed_by_id(id)
        fd = Feed.find(id)
        unless fd 
            return nil 
        end 

        return fd.comments
    end

    def self.commments_and_images_of_feed(id)
        relhash = {}
        finst = ::Feed.find(id)
        if finst 

            cms = finst.comments
            if cms 
                relhash['comments'] = cms.map{ |e| JSON.parse(e.to_json) }
            else 
                relhash['comments'] = []
            end

            images = finst.fimages

            if images
                relhash['images'] = images.map{ |e| JSON.parse(e.to_json) }
            else 
                relhash['images'] = []
            end
            
            return relhash
        else 
            return nil
        end
    end

end


