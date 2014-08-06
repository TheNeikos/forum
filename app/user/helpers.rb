
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
  end
end

