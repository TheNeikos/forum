Sequel.migration do
  change do
    create_table :basic_nodes do
      primary_key :id
      foreign_key :parent_id, :basic_nodes
      foreign_key :user_id, :users

      DateTime :created_at, :default => "CURRENT_TIMESTAMP"
      DateTime :updated_at, :default => "CURRENT_TIMESTAMP"

      FalseClass :deleted, :default => false
      DateTime :deleted_at, :default => "CURRENT_TIMESTAMP"
    end

    create_table :category_nodes do
      foreign_key :id, :basic_nodes, :null => false
      String :name, :null => false, :length => 50
      String :description, :length => 2048
    end

    create_table :discussion_nodes do
      foreign_key :id, :basic_nodes, :null => false
      foreign_key :original_post, :null => false
      String :name, :null => false, :length => 50
    end

    create_table :post_nodes do
      foreign_key :id, :basic_nodes, :null => false
      String :body, :null => false, :length => 50
    end

    create_table :profile_nodes do
      foreign_key :id, :basic_nodes, :null => false
      longtext :bio, :default => "", :null => false
    end

    create_table :status_node do
      foreign_key :id, :basic_nodes, :null => false
      String :body, :null => false, :length => 800
    end

    create_table :comment_node do
      foreign_key :id, :basic_nodes, :null => false
      String :body, :null => false, :length => 800
    end

  end
end
