class User < ActiveRecord::Base
	attr_accessible :first_name, :last_name, :login, :password_digest, :salt
	has_many :photos
	has_many :comments
    
    def password_valid?(password)
        salted_password = password + salt.to_s
        passed_digest = Digest::SHA1.hexdigest(salted_password)
        if password_digest == self.password_digest then
            return true
        else
            return false
        end
    end
end
