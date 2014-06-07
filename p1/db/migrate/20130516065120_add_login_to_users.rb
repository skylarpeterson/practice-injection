class AddLoginToUsers < ActiveRecord::Migration
  def up
      add_column :users, :login, :string
      add_column :users, :password_digest, :string
      add_column :users, :salt, :integer
      User.reset_column_information
      User.all.each do |user|
  	  	  user.update_attribute :login, user.last_name.downcase
  	  end
  end
end
