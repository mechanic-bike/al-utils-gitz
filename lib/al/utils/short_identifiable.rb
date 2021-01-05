# encoding: utf-8
#
# Requires a text field named "uuid"
# Validation of length must be put in model

module Al
  module Utils
    module ShortIdentifiable

      extend ActiveSupport::Concern

      UUID_EXPRESSION = /\A[A-Z0-9]*\z/

      included do
        validates :uuid, presence: true, uniqueness: true, format: { with: UUID_EXPRESSION }

        before_validation :generate_uuid, if: ->(obj) { obj.new_record? && obj.uuid.nil? }
      end

      # UUID can be changed only if the object is a new record
      def uuid=(value)
        write_attribute(:uuid, self.new_record? ? value : uuid&.upcase)
      end

      private

      def generate_uuid
        self.uuid = loop do
          random_uuidn = Digest::SHA1.hexdigest("#{self.class.name}-id-#{Time.zone.now.to_f}")[0..(self.class.const_get(:UUID_SIZE)-1)].upcase
          break random_uuidn unless self.class.exists?(uuid: random_uuidn)
        end
      end

    end
  end
end

