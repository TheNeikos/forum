Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      String :displayname, :null => false
      String :email, :null => false
    end

    create_table :user_roles do
      foreign_key :user_id; :users
      String :role
    end
  end
end
