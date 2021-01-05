# encoding: utf-8
# Requires text field named +slug+ and text field named +title+ or +name+
module Al
  module Utils
    module Slugable

      extend ActiveSupport::Concern

      included do
        before_create :set_slug
      end

      def slug=(value)
        write_attribute(:slug, value.to_s.parameterize) if value
      end

      private

      def set_slug
        self.slug = auto_generated_slug unless slug.present?

        return unless slug.present?

        unless self.valid? || self.errors[:slug].blank?
          append_number
        end
      end

      def auto_generated_slug
        slug =
          if self.respond_to?(:title)
            title
          elsif self.respond_to?(:name)
            name
          end
        self.slug = slug.try(:parameterize)
      end

      def append_number
        self.slug << '-1'

        loop do
          self.slug.succ!
          break if self.valid? || self.errors[:slug].blank?
        end
      end

    end
  end
end

