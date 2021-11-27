class ApplicationController < ActionController::Base
    before_action :require_login

    def not_authenticated
        redirect_to log_in_path, alert: "Please login first"
    end
end
