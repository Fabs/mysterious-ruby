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
      return :forbidden unless warden

      return :admin if warden.user(:admin)
      return :user if wardenuser(:user)
      return :guest if warden.user(:guest)
    end

    def warden
      request.env['warden']
    end
  end
end
