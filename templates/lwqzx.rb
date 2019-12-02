def cpfile(from,to)
  src = "/home/zxy/railsapp/newapp"
	run("cp #{src}/#{from} #{to}")
end
def getfile(from,to)
  tempath = "https://raw.githubusercontent.com/lajunta/railsapp/master/newapp"
	run("curl -sS --create-dirs -o #{to} #{tempath}/#{from}")
end

run("rm Gemfile")
cpfile("Gemfile","Gemfile")

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
cpfile("trix.css","app/assets/stylesheets/trix.css")
cpfile("application.scss","app/assets/stylesheets/application.scss")

run("rm app/javascript/packs/application.js")
cpfile("application.js","app/javascript/packs/application.js")
cpfile("trix.js","app/javascript/packs/trix.js")
cpfile("trix-ajax.js","app/javascript/packs/trix-ajax.js")
cpfile("z-trix.coffee","app/javascript/packs/z-trix.coffee")

cpfile("application_controller.rb","app/controllers/application_controller.rb")
cpfile("grid_controller.rb","app/controllers/grid_controller.rb")

run("rm app/views/layouts/application.html.erb")
run("mkdir app/views/shared")
cpfile("_main_nav.slim","app/views/shared/_main_nav.slim")

cpfile("dockerfile","dockerfile")
cpfile("docker-compose.yml","docker-compose.yml")
cpfile("application.slim","app/views/layouts/application.slim")

run("bundle install")
generate("mongoid:config")
generate("kaminari:config")
generate("kaminari:views bootstrap4")
generate("controller welcome home index")

after_bundle do 
  git :init
  git add:  "." 
end
