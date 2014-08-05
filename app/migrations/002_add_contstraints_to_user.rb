Sequel.migration do
  change do
    alter_table :users do |t|
      t.add_index :displayname, :unique => true
    end
  end
end
