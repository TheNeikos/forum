Sequel.migration do
  change do
    create_table :root_nodes do
      foreign_key :id, :base_nodes, :null => false
    end
  end
end
