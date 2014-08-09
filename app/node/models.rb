
class BaseNode < Sequel::Model
  plugin :class_table_inheritance, :key => :kind
  plugin :timestamps, :update_on_create => true
  plugin :validation_helpers

  many_to_one :user
  many_to_one :parent, :class => self, :key => :parent_id
  one_to_many :children, :class => self, :key => :parent_id
  one_to_many :visible_to, :class => :NodeVisibility, :key => :node_id

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
    false
  end

  def can_user_create_child user, type=nil
    true
  end

  def validate
    super
    if parent
      unless (self.visible_to & parent.visible_to) == parent.visible_to #Checks if our own visibility set is a superset of the parent's
        errors.add(:visible_to, "cannot have more visibility than parent")
      end
    end
  end

  def before_validate
    super
    self.visible_to |= parent.visible_to if parent
  end

  def self.inherited type
    super
    (@@node_types ||= []) << type.to_s
  end

  def self.get_node_types
    @@node_types
  end
end

class NodeVisibility < Sequel::Model
  many_to_one :node, :class => BaseNode, :key => :node_id
  many_to_one :user
  many_to_one :role

  def validate
    super
    unless user or role
      errors.add(:user, "needs to be specified, or a Role")
    end
  end
end

class RootNode < BaseNode

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

