$_api_root_path = File.dirname(__FILE__)

require "date"
require 'sinatra'
require 'fileutils'
require 'rack/ssl'
require 'rack/ssl-enforcer'
require 'sass'
require 'yaml'
require 'sinatra/log'
require_relative "./database/user_model.rb"
require_relative "./database/event_model.rb"

$user_params = YAML::load(File.open(File.join($_api_root_path,"./pass.yml")))
$user_encrypt = {}

class Mylog
    def self.log
        @logger ||= Sinatra::Log.new(:logger_name => 'clx',
                                    :log_filename => File.join($_api_root_path,'./log/development.log'),
                                    :loglevel => 'INFO',
                                    :enabled => true,
                                    :project_dir => '~/')
    end
end

class LoginScreen < Sinatra::Base
    enable :sessions
    set :public_folder, File.dirname(__FILE__) + '/static'
    # set :views, ['static']
    # set :views, ['views']
    # set :views, ['dist']

    # get('/login') do
    #     # erb :login_b,:layout => :base
    #     # erb :jqm_login,:layout => :jqm_main
    #     erb "",:layout => :ele_login,:locals => {id_name: "login"}
    # end

    post "/acklogin" do 
        # puts session
        # puts session['username']
        unless session['username']
            JSON.generate({status: false,login: false,info: 'dont has session'})
        else 
            obj = User.find_by(remember_token: session['username'])
            unless obj 
                JSON.generate({status: false,login: false,info: 'session wrong'})
            else
                curr_events = Event.getF40B20(obj.id,Date.today)
                JSON.generate({status: true,login: true,events: curr_events })
            end
        end
    end

    get "/login" do 
        JSON.generate({status: false,login: false})
    end
  
    post('/login') do
        hash = JSON.parse(request.body.read)
        obj = User.find_by(name: hash['username'])

        unless obj
            JSON.generate({status: true,login: false ,info: '没有此用户'})
        else 
            if Digest::SHA1.hexdigest(hash['password'].to_s) != obj.password_digest 
                JSON.generate({status: true,login: false ,info: '密码不正确'})
            else
                
                session['username'] = Digest::SHA1.hexdigest((hash['username'] + rand.to_s).to_s)
                obj.remember_token = session['username']
                curr_events = Event.getF40B20(obj.id,Date.today)

                JSON.generate({status: true,login: obj.save ,info: '登陆成功',events: curr_events })
            end
        end
    end

    post "/loginup" do 
        # puts params['password'] 
        # puts JSON.parse(request.body.read)

        # create user 

        hash = JSON.parse(request.body.read)
        new_token = Digest::SHA1.hexdigest((hash['username'] + rand.to_s).to_s)
        if User.find_by(name: hash['username'])
            JSON.generate({status: false,info:'创建用户失败,已有同名用户'})
        else
            rel = User.create!(name: hash['username'],password_digest: Digest::SHA1.hexdigest(hash['password'].to_s),remember_token: new_token )
            session['username'] = new_token
            if rel 
                JSON.generate({status: true})
            else
                JSON.generate({status: false,info:'创建用户失败'})
            end
        end
    end

end

class MyApp < Sinatra::Application
    # use Rack::SSL
    # use Rack::SslEnforcer
    # set :session_secret, 'asdfa2342923422f1adc05c837fa234230e3594b93824b00e930ab0fb94b'

    # #Enable sinatra sessions
    # use Rack::Session::Cookie, :key => '_rack_session',
    #                         :path => '/',
    #                         :expire_after => 2592000, # In seconds
    #                         :secret => settings.session_secret

    use LoginScreen
    # use WmyFeedApp::Feed

    # set :bind,"127.0.0.1"
    set :bind,"0.0.0.0"
    set :public_folder, File.join(File.dirname(__FILE__),'/dist')
    set :port,8090
    # set :views, ['static','views']
    # set :views, ['views',"scss"]
    # set :views, ['dist']
    set :default_encoding,"utf-8"

    # helpers do
    #     def find_template(views, name, engine, &block)
    #         Array(views).each { |v| super(v, name, engine, &block) }
    #     end
    # end

    set :views, :scss => 'scss', :default => 'views'

    helpers do
        def find_template(views, name, engine, &block)
            _, folder = views.detect { |k,v| engine == Tilt[k] }
            folder ||= views[:default]
            super(folder, name, engine, &block)
        end
    end

    # before do
    #     unless session['username']
    #         # halt "Access denied, please <a href='/login'>login</a>."
    #         # redirect '/login'
    #         # halt 402, {'Content-Type' => 'application/json'},JSON.generate({status: false,noLogin: true})
    #         halt erb "",layout: :ele_main,locals:{id_name:"app"}
    #     else 
    #         unless $user_encrypt.values.include?(session['user_name'])
    #             # redirect '/login'
    #             # halt 402, {'Content-Type' => 'application/json'},JSON.generate({status: false,noLogin: true})
    #             halt erb "",layout: :ele_main,locals:{id_name:"app"}
    #         end
    #     end
    # end

    get '/' do
        # "Hello! #{session['user_name']}"
        # erb :feed_main,:layout => :jqm_main
        # erb :vue_main,:layout => nil
        # erb "",layout: :ele_main,locals:{login_scr: ""}
        # erb :ele_feeds,layout: :ele_main,locals:{
        #     id_name:"c-feeds"}
        # erb :index,:layout => nil
        # haml :index, :format => :html5
        # redirect "/index.html"

        erb "",layout: :ele_main,locals:{id_name:"app"}
    end

    post "/new_event" do 
        hash = JSON.parse(request.body.read)
        user = User.find_by(remember_token: session['username'])
        unless user 
            JSON.generate({status: false,login: false,info: "请重新登陆"})
        else
            if hash['eventDate'] && hash['eventDate'] =~ /\d{4,4}\/\d{1,2}\/\d{1,2}/
                event = Event.new(title: hash['title'],contect: hash['contect'],eventDate: Date.parse(hash['eventDate']))
                event.user = user
                event.eventType = hash['eventType'] || 'curve'
                puts hash
                JSON.generate({status: event.save,event: event.to_vue_data})
            else 
                Mylog::log.error params 
                JSON.generate({status: false,info: '日期错误'})
            end
        end
    end

    post "/edit_event" do 
        hash = JSON.parse(request.body.read)
        event = Event.find_by(id: hash['id'])
        if event 
            if event.user.remember_token != session['username']
                JSON.generate({status: false,login: false,info: "请重新登陆"})
            else
                # puts hash
                if hash['eventDate'] && hash['eventDate'] =~ /\d{4,4}\/\d{1,2}\/\d{1,2}/
                    event.title = hash['title'] || event.title
                    event.contect = hash['contect'] || event.contect
                    event.eventDate = Date.parse(hash['eventDate'])
                    
                    event.eventType ||= 'curve'
                    if event.doneList
                        event_done_list = JSON.parse(event.doneList)
                    else  
                        event_done_list = {} 
                    end

                    if hash['doneList'].is_a? Hash
                        event_done_list.merge!(hash['doneList'])
                    elsif hash['doneList'].is_a? String
                        event_done_list.merge!( JSON.parse(hash['doneList']) )
                    end

                    event.doneList = JSON.generate(event_done_list)

                    if hash['eventType']
                        event.eventType = hash['eventType'] || event.eventType
                    end

                    JSON.generate({status: event.save,event: event.to_vue_data})
                else 
                    Mylog::log.error params 
                    JSON.generate({status: false,info: '日期错误'})
                end
            end
        else
            JSON.generate({status: false,login: false,info: "不存在此事件"})
        end
    end

    post "/del_event" do 
        hash = JSON.parse(request.body.read)
        event = Event.find_by(id: hash['id'].to_i)
        if event 
            if event.user.remember_token != session['username']
                JSON.generate({status: false,login: false,info: "请重新登陆"})
            else
                JSON.generate({status: event.destroy})
            end
        else
            JSON.generate({status: false,login: false,info: "不存在此事件"})
        end
    end

    # get "/css/feeds.css" do 
    #     scss :feeds
    # end

    ## 上传  文件
    # post '/feed_images' do 

    #     filepath = params['file']['tempfile']

    #     bn =  File.basename(filepath)

    #     str = File.open(filepath,'rb').read

    #     origin_image = File.join($_api_root_path,"/feed_images/#{bn}")

    #     File.open(origin_image,"wb") do |f|
    #         f.print(str)
    #     end

    #     mini_show_trans(origin_image)

    #     JSON.generate({status: true,image_file: File.basename(filepath)})
    # end

    # ## 获取图片
    # get "/feedimages/:name" do 
    #     fn = File.join($_api_root_path,"/feed_images/#{params['name']}")
    #     if(File.exist? fn)
    #         send_file fn
    #     else
    #         # send_file File.join($_api_root_path,"/static/images/idle.png")
    #         ''
    #     end
    # end

    # get "/shavefeedimages/:name" do 
    #     fn = File.join($_api_root_path,"/shave_images/shave_#{params['name']}")
    #     if(File.exist? fn)
    #         send_file fn
    #     else
    #         # send_file File.join($_api_root_path,"/shave_images/shave_idle.png")
    #         ''
    #     end
    # end

    # ## 获取vue模板
    # get "/component/:name" do 
    #     Mylog::log.info params
    #     send_file File.join($_api_root_path,"/static/vue-components/#{params['name']}"),:type => :text
    # end

    # run!
  end

#   exit
