# encoding: utf-8
# Requires a text field named +rut+
module Al
  module Utils
    module Rutable

      extend ActiveSupport::Concern

      included do
        validate :dv_valid?, if: lambda { |obj| obj.rut.present? }
        validates :rut, allow_nil: true, allow_blank:true,
                  format: { with: Al::Utils::Rut::UNFORMATTED_RUT_EXPRESSION },
                  length: 8..9

        before_validation :unformat_rut!
      end

      def formatted_rut
      end

      def simple_formatted_rut
        Al::Utils::Rut.simple_formatted_rut(rut)
      end

      def unformatted_rut
        Al::Utils::Rut.unformatted_rut(rut)
      end

      def rut=(value)
        write_attribute(:rut, Al::Utils::Rut.unformatted_rut(value))
      end

      private

      def unformat_rut!
        self.rut = unformatted_rut
      end

      def dv_valid?
        if rut.present?
          if Al::Utils::Rut.dv_invalid?(rut)
            errors.add(:rut, 'Invalid check digit')
          end
        end
      end

      module ClassMethods
        def rut(rut)
          where(rut: Al::Utils::Rut.unformatted_rut(rut)) if rut.present?
        end
      end

    end
  end
end

