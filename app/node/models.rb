
class BaseNode < Sequel::Model
    plugin :class_table_inheritance
    plugin :timestamps, :update_on_create => true

    many_to_one :user
    many_to_one :root, :class => :BaseNode
    one_to_many :children, :class => :BaseNode

    def new
      throw "Can't do this"
    end

end


class CategoryNode < BaseNode

  def validate
    super
    validate_min_length 1, :name
    validate_max_length 20, :name
    validate_presence_of :root
  end
end


class DiscussionNode < BaseNode

  def validate
    super
    validate_min_length 1, :name
    validate_max_length 20, :name
    validate_presence_of :root
  end
end


class PostNode < BaseNode

  def validate
    super
    validate_presence_of :root
    validate_presence_of :user
  end
end


class ProfileNode < BaseNode

  def validate
    super
    validate_presence_of :user
  end
end


class StatusNode < BaseNode

  def validate
    super
    validate_presence_of :root
    validate_presence_of :user
  end
end

class CommentNode <  BaseNode

  def validate
    super
    validate_presence_of :root
    validate_presence_of :user
  end
end

