Sequel.migration do
  change do
    rename_table :status_node, :status_nodes
    rename_table :comment_node, :comment_nodes
  end
end
