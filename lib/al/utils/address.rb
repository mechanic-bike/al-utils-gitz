# encoding: utf-8
class Al::Utils::Address < Al::Utils::ApplicationRecord

  # geocoded_by :full_address
  # after_validation :geocode

  def self.table_name_prefix
    ENV['TABLE_NAME_PREFIX']
  end

  belongs_to :region, class_name: 'Al::Utils::Region', primary_key: :code, foreign_key: :region_code
  belongs_to :commune, class_name: 'Al::Utils::Commune', primary_key: :code, foreign_key: :commune_code
  belongs_to :addressable, polymorphic: true

  validates :line1, presence: true

  delegate :name, to: :commune, prefix: true, allow_nil: true
  delegate :name, to: :region, prefix: true, allow_nil: true

  def full_address
    [line1, line2, commune_name, region_name, 'Chile'].compact.join(', ')
  end

  def address
    [line1, commune_name, region_name, 'Chile'].compact.join(', ')
  end

  def short_address
    [line1, line2].compact.join(', ')
  end

  def label
    self.alias || self.short_address
  end

end