require 'pony'

class Forum < Sinatra::Application

  post "/api/user/new" do
    new_user_data = verify_user_data json_data(:user)
    new_user = User.new new_user_data
    if new_user.save then
      new_user.to_json
    else
      json_error new_user.errors
    end
  end

  post "/api/user/login" do
    return if logged_in? # No need to be logged in twice

    user_data = verify_user_data json_data(:user)
    user = User.login_with_password user_data
    if user
      UserSession.create(user: user).to_json
    else
      json_error ["Could not log in with E-Mail/Password combination"]
    end
  end

  post "/api/user/me" do
    verify_user_logged_in
    user_data = verify_user_data json_data(:user)
    @cur_user.displayname = user_data["displayname"]
    if @cur_user.save then
      @cur_user.to_json
    else
      json_error @cur_user.errors
    end
  end


  get "/api/user/me" do
    verify_user_logged_in
    @cur_user.to_json :all
  end


  get "/api/user/:id" do
    user = user_find params[:id]
    if current_user == user
      user.to_json :all
    else
      user.to_json
    end
  end

  post "/api/user/:id" do
    verify_user_logged_in
    current_user_needs_privilege [:moderator, :administrator]
    user_data = verify_user_data json_data(:user)

    user = user_find params[:id]
    if user.update user_data
      user.to_json :all
    else
      json_error user.errors
    end
  end


  get "/api/users" do
    User.all.to_json
  end

  private

  def verify_user_data data
    data.delete_if do |k,d|
      !["displayname", "email", "password"].include?(k)
    end
  end

end

