class UsersController < ApplicationController
	def index
		@title = "All Users"
		@users = User.find(:all, :order => "last_name ASC")
	end
	
	def login
		@title = "Login"
	end
	
	def post_login
		user = User.find_by_login(params[:username])
		if user != nil then
			if(user.password_valid?(params[:password])) then
            	session[:user_id] = user.id
            	url = "/photos/index/" + user.id.to_s
            	redirect_to url
            else
            	redirect_to :action => :login, :notice => "Incorrect password. Try again."
            end
		else
            redirect_to :action => :login, :notice => "Username invalid. Try again."
		end
	end
	
	def logout
		reset_session
		redirect_to :action => :login, :notice => "You have been logged out"
	end
    
    def new
        @title = "Create New User"
    end
    
    def create
        user = User.new
        user.first_name = params[:first_name]
        user.last_name = params[:last_name]
        user.login = params[:username]
        salt = Random.rand(1000)
        password = params[:password]
        salted_password = password + salt.to_s
        pw_digest = Digest::SHA1.hexdigest(salted_password)
        user.password_digest = pw_digest
        user.salt = salt
        user.save()
        session[:user_id] = user.id;
        url = "/photos/index/" + user.id.to_s
        redirect_to url
    end
    
    def photo_search
    	if(params[:id] != nil)
    	search_val = params[:id]
    	photos = Array.new
    	comments = Comment.find(:all, :conditions => ["comment LIKE ?", '%' + search_val + '%'])
    	puts(comments)
    	if(!comments.empty?)
    		comments.each do |comment|
    			photos.push(comment.photo)
    		end
    	end 
    	users = User.find(:all, :conditions => ["first_name LIKE ? or last_name LIKE ?", '%' + search_val + '%', '%' + search_val + '%'])
    	if(!users.empty?)
    		users.each do |user|
    			tags = Tag.find_all_by_tagged_user_id(user.id)
    			if(!tags.empty?)
    				tags.each do |tag|
    					photos.push(Photo.find(tag.photo_id))
    				end
    			end
    		end
    	end
    	userIDs = Array.new
    	photoNames = Array.new
    	if(!photos.empty?)
    		photos.each do |photo|
    			if(!photoNames.include?(photo.file_name))
    				photoNames.push(photo.file_name)
    				userIDs.push(photo.user_id)
    			end
    		end
    	end
    	respond_to do |format|
    		format.json {
    			render :json => {"userIDs" => userIDs, "photoNames" => photoNames}	
    		}
    	end	
    	end
    end
end
