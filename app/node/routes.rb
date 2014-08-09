class Forum < Sinatra::Application

  get "/api/node/:id" do
    node = BaseNode[params[:id]]
    if node and node.can_user_view current_user
      node.to_json
    else
      json_error({:user => "You are not authorized to view this."})
    end
  end

end

