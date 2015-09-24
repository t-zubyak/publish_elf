class CreateBlogpostsAndLandings < ActiveRecord::Migration
  def change
    create_table "publish_elf_landing_pages" do |t|
      t.string   "page_url"
      t.string   "title"
      t.string   "status"
      t.text     "description"
      t.text     "features"
      t.date     "publish_date"
      t.string   "background_file_name"
      t.string   "background_content_type"
      t.integer  "background_file_size"
      t.datetime "background_updated_at"
      t.boolean  "mailing_list_subscribing"
      t.string   "mailing_list_id"
      t.timestamps
    end

    add_index "publish_elf_landing_pages", ["page_url"], name: "index_landings_on_page_url"
    add_index "publish_elf_landing_pages", ["status"], name: "index_landings_on_status"

    create_table "publish_elf_blogposts" do |t|
      t.string   "title"
      t.text     "body"
      t.date     "posted_on"
      t.string   "status",     default: "draft"
      t.integer  "user_id"
      t.timestamps
    end

    add_index "publish_elf_blogposts", ["status"], name: "index_posts_on_status"
  end
end
