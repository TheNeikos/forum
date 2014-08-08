Sequel.migration do
  change do
    alter_table :base_nodes do

      [:created_at, :updated_at, :deleted_at].each do |t|
        set_column_default t, Sequel::CURRENT_TIMESTAMP
      end
    end
  end
end
