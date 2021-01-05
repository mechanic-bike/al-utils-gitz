class CreateCommunesTable < ActiveRecord::Migration
  def change
    create_table "<%= Al::Utils::Commune.table_name %>", force: true do |t|
      t.string  :name
      t.integer :region_code, index: true, unique: false
      t.integer :code
      t.decimal :latitude,  precision: 19, scale: 15
      t.decimal :longitude, precision: 19, scale: 15
      t.timestamps
    end
  end
end
