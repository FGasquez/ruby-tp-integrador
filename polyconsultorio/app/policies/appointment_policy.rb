class AppointmentPolicy < ApplicationPolicy
  # See https://actionpolicy.evilmartians.io/#/writing_policies
  #
  def index?
    true
  end
  #
  def update?
    user.admin? || user.assistant?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? || user.assistant?
  end

  def create?
    user.admin? || user.assistant?
  end

  def new?
    create?
  end

end
