class ApplicationController < ActionController::Base

	def attachit(model,attach = :attach)
		if params[model.to_sym][attach].blank?
			old_attach = {}
			if params[:action] == 'update'
				old_attach = eval("@#{model}.#{attach.to_s}")
			end
		else
			if params[:action] == 'update'
				old_attach = eval("@#{model}.#{attach.to_s}")
				unless old_attach.blank?
					id = BSON::ObjectId.from_string(old_attach['grid_id'])
					MongoGrid.grid.delete(id)
				end
			end
			attach=params[model.to_sym][attach]
			MongoGrid.uploadtogrid(attach,width: 300)
		end
	end


	def need_super_admin
		unless is_super_admin?
			flash[:alert] = "你不能进行这个操作"
			redirect_to root_path and return
		end
	end

	def is_super_admin?
		return session[:login] == "zxy"
	end

	def is_repo_member?(repo_name,user_name)
		repo = Repo.where(name: repo_name,members: user_name).first
		return repo ? true : false
	end

	def need_repo_member(repo_name,user_name)
		unless need_repo_member(repo_name,user_name)
			flash[:alert] = "你不是这个资源库的成员"
			redirect_to repos_path and return
		end
	end

	def is_repo_admin?(repo_name,user_name)
		repo = Repo.where(name: repo_name,admins: user_name).first
		return repo ? true : false
	end

	def need_repo_admin(repo_name,user_name)
		unless need_repo_admin(repo_name,user_name)
			flash[:alert] = "你不是这个资源库的管理员"
			redirect_to repos_path and return
		end
	end

	helper_method :is_super_admin?, :is_repo_member?, :is_repo_admin?

end
