class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.integer :id
      t.string  :title
      t.string  :director
      t.string  :star
      t.integer :release_year
      t.string  :genre
      t.string  :rating
    end
  end

  def self.down
    drop_table :movies
  end
end
