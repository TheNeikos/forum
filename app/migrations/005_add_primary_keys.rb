Sequel.migration do
  change do
    [:user_logins, :user_sessions, :user_roles].each do |n|
      alter_table n do |t|
        t.add_primary_key :id
      end
    end
  end
end
