module PublishElf
  class LandingPage < ActiveRecord::Base
    self.table_name = 'publish_elf_landing_pages'

    validates :page_url, :title, :status, :content, :publish_date, presence: true
    validates :page_url, uniqueness: { case_sensitive: false }

    scope :published, -> { where("publish_date <= ?", Time.zone.today).where(:status => 'published') }

    def published?
      self.publish_date <= Time.zone.today && self.status == 'published'
    end

    def to_param
      page_url
    end

    def self.find(input)
      input.to_i == 0 ? find_by_page_url(input) : super
    end
  end
end
