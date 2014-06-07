class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
		t.column :photo_id, :integer
		t.column :tagged_user_id, :integer
		t.column :xCoord, :integer
		t.column :yCoord, :integer
		t.column :width, :integer
		t.column :height, :integer
    end
  end
end
