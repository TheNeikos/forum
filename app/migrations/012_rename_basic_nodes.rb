Sequel.migration do
  change do
    rename_table :basic_nodes, :base_nodes
  end
end
