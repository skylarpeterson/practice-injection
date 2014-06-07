class PhotosController < ApplicationController
	def index
		if(params[:id] != nil) then
			@user = User.find(params[:id])
			@photos = Photo.find(:all, :conditions => "user_id = " + @user.id.to_s);
			@title = @user.first_name + " " + @user.last_name + ": Photos"
		else
			@title = "Error"
		end
	end
	
	def new
		if session[:user_id] then
			@user = User.find(session[:user_id])
			@title = "Upload New Photo"
		else
			redirect_to "/users/login", :notice => "Must be logged in to upload photos"
		end
	end
	
	def create
		if session[:user_id] then
			file = params[:photo][:file_val];
			name = file.original_filename
			directory = "public/images"
			path = File.join(directory, name)
			File.open(path, "wb") { |f| f.write(file.read) }
			user = User.find(session[:user_id])
			photo = Photo.new
			photo.user_id = user.id
			photo.date_time = DateTime.now
			photo.file_name = name
			photo.save()
			url = "/photos/index/" + user.id.to_s
			redirect_to url
		else 
			redirect_to "/users/login", :notice => "Must be logged in to upload photos"
		end
	end
    
    def new_tag
        if session[:user_id] then
            @photo = Photo.find(params[:id])
            @user = User.find(session[:user_id])
            @users = User.find(:all, :order => "last_name ASC")
            @title = "New Photo Tag"
        else
            redirect_to "/users/login", :notice => "Must be logged in to tag photos"
        end
    end
    
    def create_tag
        if session[:user_id] then
            if params[:hidden_x] != -1 then
                tag = Tag.new
                tag.photo_id = params[:id]
                tag.tagged_user_id = params[:tagged_user]
                tag.xCoord = params[:hidden_x]
                tag.yCoord = params[:hidden_y]
                tag.width = params[:hidden_width]
                tag.height = params[:hidden_height]
                tag.save()
                
                photo = Photo.find(params[:id])
                user_id = photo.user_id
                url = "/photos/index/" + user_id.to_s
                redirect_to url
            else
                redirect_to :action => new_tag
            end
        else
            redirect_to "/users/login", :notice => "Must be logged in to tag photos"
        end
    end
    
    def view_tags
        @title = "Photo Tags"
        @photo = Photo.find(params[:id])
        @tags = @photo.tags
    end
end
