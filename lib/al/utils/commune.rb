# encoding : utf-8
class Al::Utils::Commune < ActiveRecord::Base

  def self.table_name_prefix
    ENV['TABLE_NAME_PREFIX']
  end

  belongs_to :region, class_name: 'Al::Utils::Region', foreign_key: :region_code, primary_key: :code

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  scope :communes_of, ->(region) { where(region_code: region.is_a?(Al::Utils::Region) ? region.code : region) }

end
