Sequel.migration do
  change do
    create_table :roles do
      primary_key :id
      String :name, :null => false
    end

    alter_table :user_roles do
      drop_column :role
      add_foreign_key :role_id, :roles
    end
  end
end
