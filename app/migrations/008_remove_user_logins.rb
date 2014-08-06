Sequel.migration do
  change do
    drop_table :user_logins
  end
end
