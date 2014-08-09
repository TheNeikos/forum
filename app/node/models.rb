
class BaseNode < Sequel::Model
    plugin :class_table_inheritance, :key => :kind
    plugin :timestamps, :update_on_create => true
    plugin :validation_helpers

    many_to_one :user
    many_to_one :parent, :class => self, :key => :parent_id
    one_to_many :children, :class => self, :key => :parent_id

    def new
      throw "Can't do this"
    end

    def can_user_view user
      true
    end

    def can_user_edit user
      return false unless user
      return false unless can_user_view user
      return true if self.user == user
      return true if user.has_role [:moderator, :administrator]
    end

end


class CategoryNode < BaseNode

  def validate
    super
    validates_min_length 1, :name
    validates_max_length 20, :name
    validates_presence :parent
  end
end


class DiscussionNode < BaseNode

  def validate
    super
    validates_min_length 1, :name
    validates_max_length 20, :name
    validates_presence :parent
  end
end


class PostNode < BaseNode

  def validate
    super
    validates_presence :parent
    validates_presence :user
  end
end


class ProfileNode < BaseNode

  def validate
    super
    validates_presence :user
  end
end


class StatusNode < BaseNode

  def validate
    super
    validates_presence :parent
    validates_presence :user
  end
end

class CommentNode <  BaseNode

  def validate
    super
    validates_presence :parent
    validates_presence :user
  end
end

