# define policies
class ProfessionalPolicy < ApplicationPolicy

    def index?
        true
    end
   
    def create?
        user.admin?
    end

    def new?
        create?
    end

    def edit?
        update?
    end
    
    def update?
        user.admin?
    end
    
    def destroy?
        user.admin?
    end

    def cancel_all?
        user.admin?
    end
end