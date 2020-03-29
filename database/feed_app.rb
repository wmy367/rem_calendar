require 'sinatra'
require_relative 'feed_activerecord'

module WmyFeedApp 
    
    class Feed < Sinatra::Base
        enable :sessions

        post "/feed_last" do 
            num = params['num'].to_i
            offset = params['offset'].to_i
            relhash = {}
            relhash['num'] = num 
            relhash['offset'] = offset
            puts relhash
            relhash['data'] = WmyFeedDB::last(num,offset).map{ |e| JSON.parse(e.to_json) }
            relhash['status'] = true
            # puts relhash
            JSON.generate(relhash)
       end

       post "/feed_last_full" do 
            num = params['num'].to_i
            offset = params['offset'].to_i
            relhash = {}
            relhash['num'] = num 
            relhash['offset'] = offset
            puts relhash
            relhash['data'] = WmyFeedDB::last(num,offset).map do |e| 
                sub_hash = JSON.parse(e.to_json) 
                # sub_hash['comments'] = []
                sub_hash['comments'] = e.comments.map do |ec|
                    JSON.parse(ec.to_json)
                end

                sub_hash['images'] = e.fimages.map do |ei|
                    JSON.parse(ei.to_json)
                end

                sub_hash
            end

            relhash['status'] = true
            # puts relhash
            JSON.generate(relhash)
        end

        post "/comments" do 
            relhash = {}
            relhash['status'] = false
            if(params['feed_id']) 
                id = params['feed_id'].to_i
                cms = WmyFeedDB::find_comments_of_feed_by_id(id)
                if cms 
                    relhash['data'] = cms.map{ |e| JSON.parse(e.to_json) }
                    relhash['status'] = true
                end 
            end
            JSON.generate(relhash)
        end

        post "/new_feed" do 
            puts params
            context = params['context']
            notetype = params['notetype']
            images = JSON.parse(params['images'])
            # images = params['images']
            puts params
            # puts images
            # str = File.open(filepath,'rb').read

            fd = ::Feed.new(context: context, notetype: notetype,user_id: 1)

            # puts fd.public_methods
            # puts fd.public_methods.select{|e| e =~ /image/i }
            images.each do |fn|
                fd.fimages << ::Fimage.new(name: fn)
            end

            sv = fd.save()
            ## 返回记录
            datahash = WmyFeedDB::commments_and_images_of_feed(fd.id)
            selfhash = JSON.parse(fd.to_json)
            relhash = {}
            relhash['comments_and_images'] = datahash
            relhash['self'] = selfhash

            JSON.generate({status: sv}.merge(relhash))

        end

       
        post "/comments_and_images" do 
            relhash = {}
            relhash['status'] = false
            if(params['feed_id']) 
                id = params['feed_id'].to_i

                # finst = ::Feed.find(id)
                datahash = WmyFeedDB::commments_and_images_of_feed(id)
            
                if datahash
                    relhash = relhash.merge datahash
                    relhash['status'] = true
                else 
                    relhash['status'] = false
                end
                # if finst 
                #     cms = finst.comments
                #     if cms 
                #         relhash['data'] = cms.map{ |e| JSON.parse(e.to_json) }
                #         relhash['status'] = true
                #     end 

                #     images = finst.fimages

                #     if relhash['status'] == true && images
                #         relhash['images'] = images.map{ |e| JSON.parse(e.to_json) }
                #     end
                # end
                # cms = WmyFeedDB::find_comments_of_feed_by_id(id)
                # if cms 
                #     relhash['data'] = cms.map{ |e| JSON.parse(e.to_json) }
                #     relhash['status'] = true
                # end 
            end
            JSON.generate(relhash)
        end

        post "/new_comment" do 

            # puts params
            context = params['context'].to_s

            relhash = {}
            relhash['status'] = false

            unless context.length >0
                relhash['error'] = 0
            else 
                id = params['feed_id'].to_i
                fd = ::Feed.find(id)
                unless fd 
                    relhash['error'] = 1
                else 
                    nc = ::Comment.new(context: context)
                    fd.comments << nc

                    nc.save()
                    fd.commented_at = nc.updated_at
                    fd.save()
                    relhash['comment'] = JSON.parse(nc.to_json)
                    relhash['status'] = true
                end
            end
            # puts relhash
            JSON.generate(relhash)
        end

    end

end
