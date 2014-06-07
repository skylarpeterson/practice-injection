class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.integer :id
      t.string  :name
      t.string  :card_number
      t.string  :security_code
      t.integer :exp_month
      t.integer :exp_year
      t.string  :billing_street
      t.string  :billing_city
      t.string  :billing_state
      t.string  :billing_zip
    end
  end

  def self.down
    drop_table :customers
  end
end
