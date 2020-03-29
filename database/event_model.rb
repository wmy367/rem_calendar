require 'active_record'
require 'date'
unless $_api_root_path
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: './production.sqlite3')
else
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: File.join($_api_root_path,'/database/production.sqlite3'))
end

class Event < ActiveRecord::Base
    belongs_to :user

    def self.getF40B20(user_id,dtime) ## 获取当前时间往前40天记录的事件
        unless dtime.is_a? Date
            md = Date.parse(dtime)
        else
            md = dtime 
        end

        return self.where(eventDate: ((md-40).to_time)..((md+20).to_time),user_id: user_id).map{|e| e.to_vue_data }
    end

    def to_vue_data
        return {title: self.title,date: self.eventDate.strftime("%Y/%m/%d"),desc: self.contect,id: self.id}
    end
end

def test_evenF40
    puts Event.getF40B20(1,"2020/03/29").to_json
end

test_evenF40
