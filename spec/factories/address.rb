FactoryBot.define do

  factory :address, class: Al::Utils::Address do
    add_attribute(:alias) { Faker::Lorem.word }
    region_code Faker::Number.number(2)
    commune_code Faker::Number.number(4)
    line1 'Magnere 1540'
    line2 'Of. 901'
    zip_code Faker::Address.zip_code
  end

end
