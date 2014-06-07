  class Tag < ActiveRecord::Base
  	attr_accessible :photo_id, :tagged_user_id, :xCoord, :yCoord, :width, :height
  	belongs_to :photo
end
