class Photo < ActiveRecord::Base
    attr_accessible :user_id, :date_time, :file_name
	belongs_to :user
	has_many :comments
    has_many :tags
end
