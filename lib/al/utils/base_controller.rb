module Al
  module Utils
    module BaseController

      HEADERS = ['Client', 'Access-Token', 'Uid', 'Expiry', 'Token-Type', 'Persistence-Token']

      require 'uri'
      require 'net/http'

      def self.included(base)
        base.extend(ClassMethods)

        base.class_eval do
          include Al::Utils::Errors

          before_action :set_raven_context
          before_action :load_account
        end
      end

      protected

      def set_raven_context
        Raven.user_context(uid: request.headers['Uid'])
        Raven.extra_context(params: params.to_unsafe_h, url: request.url)
      end

      def paginate_params
        { page: params[:page] || 1, per_page: params[:per_page] || 15 }
      end

      def load_account
        @account = Account.load_account(params[:account_id])

        render_custom_errors(:account, :not_found) unless @account
      end

      def load_pluginship(plugin_uid)
        @pluginship = Pluginship.load_pluginship(plugin_uid, @account.id)

        render_custom_errors("#{plugin_uid}_pluginship", :forbidden) unless @pluginship
      end

      def load_user
        headers = set_headers
        cache_key = [:validate_token, params[:account_id]] + headers.values
        user_data = Rails.cache.fetch(cache_key, expires_in: 30.seconds) { request_user }

        if user_data.present?
          @user = User.new(user_data.slice(*user_attributes))
        else
          Rails.cache.delete(cache_key)
          render_custom_errors(:user, :unauthorized)
        end
      end

      def request_user
        if Rails.env.test?
          return User.fake_user(1, 1).attributes.symbolize_keys.merge(account_id: 1)
        end

        uri = URI.parse("#{ENV['AL_CORE_API']}/accounts/#{params[:account_id]}/auth/validate_token")
        uri.query = URI.encode_www_form(token: params[:token]) if params[:token]

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'
        http.start

        req = Net::HTTP::Get.new(uri)

        HEADERS.each do |header|
          Rails.logger.debug "#{header}: #{request.headers[header]}"
          req[header] = request.headers[header]
        end

        begin
          res = http.request(req)
        rescue => error
          Rails.logger.error error
          return {}
        end

        Rails.logger.debug res.inspect
        Rails.logger.debug res.code
        Rails.logger.debug res.body

        res.code.to_i > 400 ? {} : JSON.parse(res.body, symbolize_names: true)[:data]
      end

      def user_attributes
        [:id, :account_id, :name, :first_name, :last_name, :email, :is_admin, :is_account_admin, :role_id,
         :provider, :locale, :category_id, :time_zone, :role_uid]
      end

      def set_headers
        headers = {}

        HEADERS.each do |header|
          headers[header] = request.headers[header]
        end
        Rails.logger.debug "[LoadUser] No headers" if headers.empty?
        headers
      end

      def check_permissions
        return true if @user.is_admin?
        return false unless @user.has_role?
        return true unless @pluginship

        uri = URI.parse("#{ENV['AL_CORE_API']}/accounts/#{@account.id}/admin/permissions")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'
        http.start

        uri.query = { plugin: @pluginship.plugin_uid, controller: controller_name, action: request.method_symbol }.to_query(:check)
        req = Net::HTTP::Get.new(uri)

        HEADERS.each do |header|
          req[header] = request.headers[header]
        end

        begin
          res = http.request(req)
        rescue => error
          return {}
        end

        res.code.to_i == 401 ? {} : JSON.parse(res.body, symbolize_names: true)[:data]
      end

      module ClassMethods
        def set_pagination_headers(name, options = {})
          after_action(options) do |controller|
            results = instance_variable_get("@#{name}")
            headers["X-Pagination"] = {
              total: results.total_entries,
              total_pages: results.total_pages,
              first_page: results.current_page == 1,
              last_page: results.next_page.blank?,
              previous_page: results.previous_page,
              next_page: results.next_page,
              out_of_bounds: results.out_of_bounds?,
              offset: results.offset
            }.to_json
          end
        end
      end

    end
  end
end
