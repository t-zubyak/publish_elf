module PublishElf
  module ApplicationHelper
    def can_manage_blogposts?
      user_signed_in? && current_user.publisher?
    end
  end
end
