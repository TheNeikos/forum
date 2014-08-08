Sequel.migration do
  change do
    alter_table :basic_nodes do |t|
      t.add_column :kind, String
    end
  end
end
