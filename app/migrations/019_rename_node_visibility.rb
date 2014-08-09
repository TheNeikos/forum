Sequel.migration do
  change do
    rename_table :node_visibility, :node_visibilities
  end
end
