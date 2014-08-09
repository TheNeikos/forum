Sequel.migration do
  change do
    rename_table :user_roles, :users_roles
  end
end
