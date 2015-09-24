module PublishElf
  class Landing < ActiveRecord::Base
#    attr_accessible :description, :features, :page_url, :status, :title, :background, :publish_date, :mailing_list_subscribing, :mailing_list_id, :with_coupon

    self.table_name = 'publish_elf_landing_pages'

    validates :page_url, :title, :status, :description, :features, :publish_date, presence: true
    validates :page_url, uniqueness: { case_sensitive: false }

    has_attached_file :background, styles: { xlarge: "1000x1000>", large: "500x500>", medium: "300x300>", thumb: "100x100>" }
    validates_attachment_content_type :background, :content_type => ['image/jpg', 'image/png', 'image/jpeg', 'image/gif']

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
