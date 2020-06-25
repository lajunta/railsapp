require 'grpc'
require 'proto/grpcd_services_pb'

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

  def stub 
    Grpcd::Grpcd::Stub.new(ENV['GRPCD_ADDRESS'], :this_channel_is_insecure)
  end  

  def current_week
    request = Grpcd::CurrentWeekRequest.new()
    response = stub.current_week(request)
    return response.WeekNum
  end

  def semesters
    request = Grpcd::SemestersRequest.new()
    semesters = stub.semesters(request).Semes
    return semesters.map{|s| s.Name}
  end

  def current_semester
    request = Grpcd::CurrentSemesterRequest.new()
    semester = stub.current_semester(request)
    return semester.Name
  end

	helper_method :is_super_admin?,:current_semester

end
