$_api_root_path = File.dirname(__FILE__)

require 'sinatra'
require 'fileutils'
require 'rack/ssl'
require 'rack/ssl-enforcer'
require 'sass'
require 'yaml'
require 'sinatra/log'

$user_params = YAML::load(File.open(File.join($_api_root_path,"./pass.yml")))
$user_encrypt = {}

class Mylog
    def self.log
        @logger ||= Sinatra::Log.new(:logger_name => 'ele-note',
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
        unless session['user_name']
            JSON.generate({status: false,noLogin: true})
        else 
            unless $user_encrypt.values.include?(session['user_name'])
                JSON.generate({status: false,noLogin: true})
            else 
                JSON.generate({status: true,noLogin: false})
            end
        end
    end

    get "/login" do 
        JSON.generate({status: false,noLogin: true})
    end
  
    post('/login') do
        if trueYamlUserDirect params['name'],params['nick']
            $user_encrypt[params['name']] = SecureRandom.urlsafe_base64
            session['user_name'] = $user_encrypt[params['name']]

            Mylog::log.info params
            Mylog::log.info session['user_name']
            # redirect "/"
            JSON.generate({status: true})
        else
            Mylog::log.info "=====ERROR====="
            Mylog::log.info params
            # redirect '/login'
            JSON.generate({status: false})
        end
        
        # redirect "/"
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

    # use LoginScreen
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
    #     unless session['user_name']
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
