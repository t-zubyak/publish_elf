module PublishElf
  class Blogpost < ActiveRecord::Base
    # attr_accessible :body, :posted_on, :title, :status, :tag_list, :user_id
    acts_as_taggable

    sir_trevor_content :body

    self.table_name = 'publish_elf_blogposts'

    belongs_to :user

    validates :body, :posted_on, :title, :status, presence: true

    scope :published, -> { where("posted_on <= ?", Time.zone.today).where(:status => 'published') }

    def published?
      self.posted_on <= Time.zone.today && self.status == 'published'
    end

    def to_param
      "#{id}-#{title.parameterize}"
    end

    def json_body?
      begin
        JSON.parse read_attribute_before_type_cast('body')
        return true
      rescue
        return false
      end
    end
  end
end
