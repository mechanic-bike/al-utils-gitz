module Al
  module Utils
    require 'al/utils/application_record'
    require 'al/utils/address'
    require 'al/utils/commune'
    require 'al/utils/errors'
    require 'al/utils/filter_by_date'
    require 'al/utils/region'
    require 'al/utils/rutable'
    require 'al/utils/short_identifiable'
    require 'al/utils/rut'
    require 'al/utils/slugable'
    require 'al/utils/base_controller'

    require 'al/serializers/error_serializer'

    if Rails.env.test?
      require 'al/utils/factories'
      require 'al/utils/shared_examples'
    end
  end
end