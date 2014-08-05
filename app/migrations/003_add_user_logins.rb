Sequel.migration do
  change do
    create_table :user_logins do
      foreign_key :user_id; :users
      String :login_key
      DateTime :expiry_date, :default => DateTime.now
    end
  end
end
