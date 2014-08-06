Sequel.migration do
  change do
    alter_table :user_sessions do |t|
      t.drop_column :valid
    end
    alter_table :user_logins do |t|
      t.add_column :valid, TrueClass, :default => true
    end
  end
end
