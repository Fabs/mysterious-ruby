module AuthorizationConcern
  extend ActiveSupport::Concern

  included do
    helper_method :owner?
  end

  def owner?(user, object)
    return false if invalid_input(user, object)

    # If the object does not specify owner, than everybody owns it.
    return true unless specifies_owner?(object)
    return true if user.admin?
    return true if owns?(user, object)

    false
  end

  private

  def invalid_input(user, object)
    !user || !user.respond_to?(:id) || !object
  end

  def specifies_owner?(object)
    object.respond_to?(:user_id)
  end

  def owns?(user, object)
    user.id == object.user_id
  end
end
