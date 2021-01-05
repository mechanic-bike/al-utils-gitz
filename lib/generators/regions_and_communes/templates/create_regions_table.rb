class CreateRegionsTable < ActiveRecord::Migration
  def change
    create_table "<%= Al::Utils::Region.table_name %>", force: true do |t|
      t.string  :name
      t.integer :code, index: true
      t.decimal :latitude,  precision: 19, scale: 15
      t.decimal :longitude, precision: 19, scale: 15
      t.timestamps
    end
  end
end