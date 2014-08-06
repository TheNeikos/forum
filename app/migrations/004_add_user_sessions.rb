
Sequel.migration do
  change do
    create_table :user_sessions do
      foreign_key :user_id; :users
      String :auth_key
      DateTime :expiry_date, :default => DateTime.now
    end
  end
end

