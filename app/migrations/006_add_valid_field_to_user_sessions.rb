Sequel.migration do
  change do
    alter_table :user_sessions do |t|
      t.add_column :valid, TrueClass, :default => true
    end
  end
end
