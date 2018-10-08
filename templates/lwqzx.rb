def getfile(from,to)
  tempath = "https://raw.githubusercontent.com/lajunta/railsapp/master/newapp"
	run("curl -sS --create-dirs -o #{to} #{tempath}/#{from}")
end

run("rm Gemfile")
getfile("Gemfile","Gemfile")

route %q(root to: 'welcome#index')
route %q(get "download/:id" => "grid#download" , :as=>:download)
route %q(get "see/:id" => "grid#see" , :as=>:see)
route %q(match "media_upload"=>"grid#media_upload", as: "media_upload", via: [:post,:delete])

initializer 'mongo_grid.rb', <<-CODE
name = Rails.application.class.parent.to_s.downcase
MongoGrid.configure do |config|
  config.db_name = name+"_"+Rails.env
  config.db_url  = "127.0.0.1:27017"
end
CODE

initializer 'rucaptcha.rb', <<-CODE
RuCaptcha.configure do 
  self.cache_store = :mem_cache_store
end
CODE

environment "::Mongoid::QueryCache.enabled = true"
environment "::Slim::Engine.options[:pretty] = true"

run("rm app/assets/stylesheets/application.css")
getfile("application.scss","app/assets/stylesheets/application.scss")
getfile("trix.scss","app/assets/stylesheets/trix.scss")

run("rm app/assets/javascripts/application.js")
getfile("application.js","app/assets/javascripts/application.js")
getfile("trix.js","app/assets/javascripts/trix.js")
getfile("trix-ajax.js","app/assets/javascripts/trix-ajax.js")
getfile("z-trix.coffee","app/assets/javascripts/z-trix.coffee")

getfile("grid_controller.rb","app/controllers/grid_controller.rb")

run("rm app/views/layouts/application.html.erb")
getfile("_main_nav.slim","app/views/shared/_main_nav.slim")

getfile("application.slim","app/views/layouts/application.slim")

run("bundle install")
generate("mongoid:config")
generate("kaminari:config")
generate("kaminari:views bootstrap4")
generate("controller welcome home index")

after_bundle do 
  git :init
  git add:  "." 
end
