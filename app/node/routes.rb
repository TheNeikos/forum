class Forum < Sinatra::Application

  get "/api/node/:id" do
    if params[:id] == "root"
      node = RootNode.first
    else
      node = BaseNode[params[:id]]
    end
    if node and node.can_user_view current_user
      node.to_json
    else
      json_error({:user => "You are not authorized to view this."})
    end
  end

  post "/api/node/new" do
    verify_user_logged_in
    node_data = verify_node_data json_data :node
    parent = find_node node_data["parent"]
    unless parent.can_user_create_child user, node_data["type"]
      json_error(:parent => "doesn't allow this type of node.")
    end

    node = get_node_from_string(node_data["type"]).new(node_data["data"])
    node.parent = parent
    if node.save
      node.to_json
    else
      json_error node.errors
    end

  end

  private

  def verify_node_data data
    data.delete_if do |k,d|
      not ["parent", "type", "data"].includes k
    end
  end

  def find_node id
    node = BaseNode[id]
    if node and node.can_user_append_child
      node
    else
      json_error :user => "You are not authorized to view this."
  end

end

