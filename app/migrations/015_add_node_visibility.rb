Sequel.migration do
  change do
    create_table :node_visibility do
      primary_key :id
      foreign_key :user_id, :users
      foreign_key :role_id, :roles
      foreign_key :node_id, :base_nodes
    end
  end
end
