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
    unless parent.can_user_create_child current_user, node_data["type"]
      json_error(:parent => "doesn't allow this type of node.")
    end

    begin
      node = get_node_from_string(node_data["type"]).new(node_data["data"])
      node.parent = parent
      node.user = current_user
      if node.save
        node.to_json
      else
        json_error node.errors
      end
    rescue Exception => e
      puts e.inspect, e.backtrace
      json_error :type => "is not a valid node type"
    end

  end

  post "/api/node/:id" do
    verify_user_logged_in
    node_data = verify_node_data json_data :node
    node = find_node params[:id]
    unless node.can_user_edit current_user
      json_error :user => "You are not authorized to view this."
    end
    if node.update node_data
      node.to_json
    else
      json_error node.errors
    end
  end

  private

  def verify_node_data data
    data.delete_if do |k,d|
      not ["parent", "type", "data"].include? k
    end
  end

  def find_node id
    node = BaseNode[id]
    if node and node.can_user_view current_user
      node
    else
      json_error :user => "You are not authorized to view this."
    end
  end

  def get_node_from_string type
    return nil unless BaseNode.get_node_types.any?{|t| t == type}
    Object.const_get type
  end

end

