class PopulateRegionsTable < ActiveRecord::Migration
  def up
    REGIONS.each do |r|
      Al::Utils::Region.find_or_create_by(code: r[:code]) do |region|
        region.name = r[:name]
        region.latitude = r[:latitude]
        region.longitude = r[:longitude]
        region.save
      end
    end
  end

  def down
    Al::Utils::Region.delete_all
  end
end

REGIONS = [
  { code: 1,  name: 'Tarapacá',           latitude: -20.3033848555, longitude: -70.0150948488 },
  { code: 2,  name: 'Antofagasta',        latitude: -23.3762676627, longitude: -69.9351796874 },
  { code: 3,  name: 'Atacama',            latitude: -27.4426651432, longitude: -70.4908330446 },
  { code: 4,  name: 'Coquimbo',           latitude: -30.578177026,  longitude: -71.2643544301 },
  { code: 5,  name: 'Valparaíso',         latitude: -32.487631593,  longitude: -70.2813336712 },
  { code: 6,  name: 'O higgins',          latitude: -34.327628079,  longitude: -71.03432975   },
  { code: 7,  name: 'Maule',              latitude: -35.4409563433, longitude: -71.6344503711 },
  { code: 8,  name: 'Biobio',             latitude: -36.9723561753, longitude: -72.6965062809 },
  { code: 9,  name: 'La araucanía',       latitude: -38.6549222532, longitude: -72.484231648  },
  { code: 10, name: 'Los lagos',          latitude: -41.4750150243, longitude: -73.1377622194 },
  { code: 11, name: 'Aysén',              latitude: -45.4007750487, longitude: -72.3742325464 },
  { code: 12, name: 'Magallanes',         latitude: -53.2138110047, longitude: -70.622860898  },
  { code: 13, name: 'Metropolitana',      latitude: -33.4818470105, longitude: -70.6790978919 },
  { code: 14, name: 'Los rios',           latitude: -39.8975166343, longitude: -72.9190608225 },
  { code: 15, name: 'Arica y parinacota', latitude: -18.479513832,  longitude: -70.2993323241 }
]