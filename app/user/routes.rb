
class Forum < Sinatra::Application

  post "/api/user/new" do
    new_user_data = json_data(:user)
    verify_user_data(new_user_data)
    new_user = User.new new_user_data
    if new_user.save then
      new_user.to_json
    else
      json_error new_user
    end
  end

  post "/api/user/request_login" do
    new_user_data = json_data(:user)
    verify_user_data(new_user_data)
    if new_user_data["email"].nil?
      json_error({errors: {email: "is not present"}})
    end
    user = User[email: new_user_data["email"]]
  end


  get "/api/users" do
    User.all.to_json
  end

  private

  def verify_user_data data
    data.delete_if do |k,d|
      !["displayname", "email"].include?(k)
    end
  end

end

