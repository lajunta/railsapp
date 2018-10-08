class GridController < ApplicationController
  layout nil
  before_action :need_login, only: [:media_upload]
  skip_before_action :verify_authenticity_token, :only => [:media_upload]


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

  def media_upload
    if request.post?
      hsh = MongoGrid.uploadtogrid(params[:media],width: 960)
      json_hsh={url: see_path(hsh[:grid_id])}
      render json: json_hsh, status: :created, location: root_path
    elsif request.delete?
      hsh = MongoGrid.remove(params[:grid_id])
      json_hsh={status: 202}
      render json: json_hsh, status: 202, location: root_path
    else
      render json: json_hsh, status: 500, location: root_path
    end
  end
end
