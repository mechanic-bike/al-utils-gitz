class CreateAddressesTable < ActiveRecord::Migration
  def change
    create_table "<%= Al::Utils::Address.table_name %>", force: true do |t|
      t.references :addressable, polymorphic: true
      t.string :type, index: true, unique: false
      t.string :alias
      t.integer :region_code, index: true, unique: false
      t.integer :commune_code, index: true, unique: false
      t.string :line1
      t.string :line2
      t.decimal :latitude, precision: 19, scale: 15
      t.decimal :longitude, precision: 19, scale: 15
      t.integer :zip_code
      t.timestamps
    end

    add_index "<%= Al::Utils::Address.table_name %>", [:addressable_type, :addressable_id], unique: false, name: 'index_<%= Al::Utils::Address.table_name %>_on_assetable_type_and_id'
  end
end
