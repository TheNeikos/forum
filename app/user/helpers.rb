
class Forum < Sinatra::Application
  helpers do
    def logged_in?
      not not current_user
    end

    def current_user
      return @cur_user if @cur_user
      return false if params[:auth_key].nil?
      user_session = UserSession[:auth_key => params[:auth_key]]
      return false unless user_session
      @cur_user = user_session.user
    end

    def current_user_needs_privilege role
      if current_user and !current_user.has_role role
        json_error :user => "does not have enough privilege"
      end
    end

    def user_find criteria
      user = User[criteria]
      if !user
        json_error :user => "could not be found"
      end
      user
    end

    def verify_user_logged_in
      return if logged_in?
      status 403
      json_error(error: "You are not logged in")
    end
  end
end

