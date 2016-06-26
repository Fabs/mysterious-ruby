module AuthenticationConcern
  extend ActiveSupport::Concern

  included do
    prepend_before_action :authenticate!

    helper_method :current_user, :current_role
  end

  def authenticate!
    warden.authenticate!
  end

  def current_user
    roles_but_guest = roles_in_priority[0...-1]
    roles_but_guest.each do |role|
      return warden.user(role) if warden.user(role)
    end

    nil
  end

  def current_role
    roles_in_priority.each do |role|
      return role if warden.user(role)
    end

    nil
  end

  private

  def warden
    request.env['warden']
  end

  def roles_in_priority
    [:admin, :user, :guest]
  end
end
