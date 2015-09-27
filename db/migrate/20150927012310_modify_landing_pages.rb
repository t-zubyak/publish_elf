class ModifyLandingPages < ActiveRecord::Migration
  def change
    remove_column :publish_elf_landing_pages, :description, :text
    remove_column :publish_elf_landing_pages, :features, :text
    remove_column :publish_elf_landing_pages, :background_file_name, :string
    remove_column :publish_elf_landing_pages, :background_content_type, :string
    remove_column :publish_elf_landing_pages, :background_file_size, :integer
    remove_column :publish_elf_landing_pages, :background_updated_at, :datetime
    remove_column :publish_elf_landing_pages, :mailing_list_subscribing, :boolean
    remove_column :publish_elf_landing_pages, :mailing_list_id, :string
    add_column :publish_elf_landing_pages, :content, :text
  end
end
