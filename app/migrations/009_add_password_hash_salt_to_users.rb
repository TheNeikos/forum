
Sequel.migration do
  change do
    alter_table :users do |t|
      t.add_column :password_hash, String, :length => 132
      t.add_column :password_salt, String, :length => 32
    end
  end
end
