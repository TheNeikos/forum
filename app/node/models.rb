
class BaseNode < Sequel::Model
    plugin :class_table_inheritance

    many_to_one :user
    one_to_many :childs
    def new
      throw "Can't do this"
    end
end


class CategoryNode < BaseNode

end


class DiscussionNode < BaseNode

end


class PostNode < BaseNode

end


class ProfileNode < BaseNode

end


class StatusNode < BaseNode

end

