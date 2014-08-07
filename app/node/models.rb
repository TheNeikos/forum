
class BaseNode < Sequel::Model
    plugin :class_table_inheritance

    many_to_one :user
    many_to_one :root
    one_to_many :children

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
  end
end


class ProfileNode < BaseNode

  def validate
    super
  end
end


class StatusNode < BaseNode

  def validate
    super
    validate_presence_of :root
  end
end

