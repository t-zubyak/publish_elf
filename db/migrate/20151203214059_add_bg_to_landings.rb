class AddBgToLandings < ActiveRecord::Migration
  def change
    add_column :publish_elf_landing_pages, :background, :string
    add_column :publish_elf_landing_pages, :description, :text
  end
end
