require 'pony'

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
    login = user.add_user_login(UserLogin.new( :user => user ))
    Pony.mail(:to => user.email,
              :subject => "Your Login Key for Forums",
              :html_body => haml(:'user/login_email', locals: {
                user: user,
                login_key: login.login_key}))
    {success: true}.to_json
  end

  get '/api/user/me' do
    verify_user_logged_in


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

  def verify_user_logged_in
    return if logged_in?
    status 403
    json_error(errors: ["You are not logged in"])
  end

end

