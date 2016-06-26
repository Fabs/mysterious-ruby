module Api
  class ApiController < ActionController::API
    prepend_before_filter :authenticate!

    def skip_authentication
      @skip = true
    end

    def authenticate!
      warden.authenticate!
    end

    def role
      current_role
    end

    def warden
      request.env['warden']
    end
  end
end
