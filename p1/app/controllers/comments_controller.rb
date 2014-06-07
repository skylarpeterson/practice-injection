class CommentsController < ApplicationController
    
    def new
        @photo = Photo.find(params[:id])
        if session[:user_id]
            @user = User.find(session[:user_id])
            @title = "New Comment"
        else
            url = "/photos/index/" + @photo.user.id.to_s
            redirect_to url
        end
    end
    
    def create
        photo = Photo.find(params[:photo_id])
        if session[:user_id]
            user = User.find(session[:user_id])
            comment = Comment.new
            comment.user_id = user.id
            comment.photo_id = photo.id
            comment.date_time = DateTime.now
            comment.comment = params[:comment_val]
            comment.save()
        end
        url = "/photos/index/" + photo.user_id.to_s
        redirect_to url
    end
end
