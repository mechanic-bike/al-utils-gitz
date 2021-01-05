# encoding : utf-8
class Al::Utils::Region < Al::Utils::ApplicationRecord

  def self.table_name_prefix
    ENV['TABLE_NAME_PREFIX']
  end

  has_many :communes, class_name: 'Al::Utils::Commune', foreign_key: :region_code, primary_key: :code

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

end
