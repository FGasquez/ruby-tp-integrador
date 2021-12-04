# Base class for application policies
class ApplicationPolicy < ActionPolicy::Base
    def not_authorized
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to root_path
    end
end
