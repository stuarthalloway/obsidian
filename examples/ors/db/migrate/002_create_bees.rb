class CreateBees < ActiveRecord::Migration
  def self.up
    create_table :bees do |t|
      t.string :name
      t.integer :happy_moments
      t.timestamps
    end
  end

  def self.down
    drop_table :bees
  end
end
