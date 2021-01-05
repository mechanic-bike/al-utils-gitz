# encoding: utf-8
# include this module in application controller of your app

module Al
  module Utils
    module Errors

      def render_errors(object, status = :unprocessable_entity)
        render json: object, adapter: :attributes, serializer: ErrorSerializer, status: status
      end

      def render_custom_errors(id, status, title = nil)
        if title
          render json: { errors: [{ id: id, title: title }] }, status: status
        else
          render json: { errors: [{ id: id, title: set_title(id, status) }] }, status: status
        end
      end

      def model_name(id)
        I18n.t("activerecord.models.#{id}", default: id.to_s.humanize)
      end

      def set_title(id, status)
        [model_name(id), error_desc(status)].join(' ').humanize
      end

      def error_desc(status)
        I18n.t("custom_errors.commons.#{status}", default: status.to_s.humanize)
      end

    end
  end
end

