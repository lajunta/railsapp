run("rm Gemfile")
run("touch Gemfile")
add_source "https://gems.ruby-china.org/"
gem 'rails', "~> 5.1.4"
gem 'puma'
gem 'sass-rails'
gem 'bootsnap'
gem 'uglifier'
gem 'coffee-rails'
gem 'turbolinks'
gem 'jbuilder'

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'slim-rails'
gem 'dalli'
gem 'bson'
gem 'rucaptcha'
gem 'mongoid', github: "mongodb/mongoid"
gem 'kaminari'
gem 'kaminari-mongoid'

gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'zbox'
gem 'mongo_grid'
gem 'oxen'
gem 'jquery-rails'
gem 'bcrypt'

gem_group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

gem_group :development do
  gem 'pry'
  gem 'stackprof'
  gem 'rack-mini-profiler'
  gem 'flamegraph'
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
end

route %q(root to: 'welcome#index')
route %q(get "download/:id" => "grid#download" , :as=>:download)
route %q(get "see/:id" => "grid#see" , :as=>:see)

puts "初始化 mongo_grid "
initializer 'mongo_grid.rb', <<-CODE
#name = Rails.application.class.parent.to_s.downcase
MongoGrid.configure do |config|
  config.db_name = "#{@app_name}_"+Rails.env
  config.db_url  = "localhost:27017"
end
CODE

puts "初始化 rucaptcha "
initializer 'rucaptcha.rb', <<-CODE
RuCaptcha.configure do 
  self.cache_store = :mem_cache_store
end
CODE

puts "add account when Rails::Server or Rails::Console"
initializer 'oxen.rb', <<-CODE
if defined? Rails::Server 
  root = Oxen::Account.where(login: "root").first
  unless root
    psd = ENV["PASSWORD"]
    Oxen::Account.create(login: "root",password: psd, password_confirmation: psd)
  end
end
CODE

puts "设置环境"
puts "--------------------------------------------------------"
environment "::Mongoid::QueryCache.enabled = true"
environment "::Slim::Engine.options[:pretty] = true"

puts "更改 application.css "
puts "--------------------------------------------------------"
run("rm app/assets/stylesheets/application.css")
file "app/assets/stylesheets/application.scss", <<-CODE
/*
 *= require_tree .
 *= require_self
*/
@import "bootstrap-sprockets";
@import "bootstrap";
@import "font-awesome-sprockets";
@import "font-awesome";
CODE

puts "更改 application.js "
puts "--------------------------------------------------------"
run("rm app/assets/javascripts/application.js")
file "app/assets/javascripts/application.js", <<-CODE
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require_tree .
$(document).ready(function(){

});
//= require turbolinks
CODE

puts "设置 mongoid , kaminari"
puts "--------------------------------------------------------"

#app_name=ask("应用名称是什么?")
file "config/mongoid.yml", <<-CODE
development:
  clients:
    default:
      database: #{@app_name}_development
      hosts:
        - localhost:27017

production:
  clients:
    default:
      database: #{@app_name}_production
      hosts:
        - localhost:27017
CODE

puts "生成 grid controller"
puts "--------------------------------------------------------"
file "app/controllers/grid_controller.rb", <<-CODE
class GridController < ApplicationController
  layout nil

  def download(gid=params[:id])
    id = BSON::ObjectId.from_string(gid)
    file=MongoGrid.grid.find_one(_id: id)
    type = file.info.metadata[:content_type]
    send_data file.data, :filename => file.filename, :type=>type,:disposition => "attach"
  end

  def see(gid=params[:id])
    id = BSON::ObjectId.from_string(gid)
    file=MongoGrid.grid.find_one(_id: id)
    type = file.info.metadata[:content_type]
    response.header["Accept-Ranges"]=  "bytes"
    response.header["Content-Transfer-Encoding"] = "binary"
    send_data file.data, :filename => file.filename,\
      :type=>type,:disposition => "inline", stream: true,buffer_size: 4096
  end
end
CODE

run("rm config/locales/en.yml")
puts "make kaminari chinese"
file "config/locales/en.yml", <<-CODE
en:
  views:
    pagination:
      first: "&laquo; 第一页"
      last: "最后页 &raquo;"
      previous: "&lsaquo; 前一页"
      next: "下一页 &rsaquo;"
      truncate: "&hellip;"
CODE

run("rm app/views/layouts/application.html.erb")
puts "生成 application layout with slim template"
puts "--------------------------------------------------------"
file "app/views/shared/_main_nav.slim" , <<-CODE
nav.navbar.navbar-default 
  .container
    .navbar-header 
      = link_to icon('home'), main_app.root_path, class: 'navbar-brand'
    .collapse.navbar-collapse 
      ul.nav.navbar-nav
        - if is_root?
      ul.nav.navbar-nav.navbar-right
        - if is_login?
          li = link_to icon("users","帐号管理"), oxen.accounts_path
          li = link_to session[:login],oxen.changepsd_path
          li = link_to icon('sign-out',' 登出'),oxen.logout_path
        - else
          li = link_to icon('sign-in',' 登录'),oxen.login_path
CODE

file "app/views/layouts/application.slim", <<-CODE
doctype html
html
  head
    title 
    = csrf_meta_tags 
    = stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' 
    = javascript_include_tag 'application', 'data-turbolinks-track': 'reload' 

  body
    == render "shared/main_nav"
    .container
      - if flash[:notice]
        .alert.alert-success = flash[:notice]
      - if flash[:alert]
        .alert.alert-danger  = flash[:alert]
    .container
      = yield 
CODE

puts "post setup"
puts "--------------------------------------------------------"
after_bundle do 
  #run("rails g mongoid:config")
  run("rails g kaminari:config")
  run("rails g kaminari:views bootstrap4")
  run("rails g controller welcome home index")
  git :init
  git add:  "." 
end
