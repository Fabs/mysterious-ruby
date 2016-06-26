module AuthorizationConcern
  extend ActiveSupport::Concern

  included do
    helper_method :is_owner?
  end

  def is_owner(user, object)
    return false unless user
    return false unless user.respond_to?(:id)

    return false unless object
    # Objects that do not belong to anyone, can be edit by everyone
    return true unless object.respond_to?(:user_id)

    return true if user.admin?
    return true if user.id == object.user_id

    false
  end
end
