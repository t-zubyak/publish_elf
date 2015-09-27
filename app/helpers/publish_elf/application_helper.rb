module PublishElf
  module ApplicationHelper
    def can_manage_blogposts?
      user_signed_in? && current_user.publisher?
    end

    def can_manage_landings?
      user_signed_in? && current_user.publisher?
    end

    def render_short_post_body body
      begin
        html_str = render(body.first_block_of_type(:text))
        html_str += render(body.first_block_of_type(:image))
        html_str.html_safe
      rescue
        truncate_html(simple_format(body, {}, :sanitize => false), length:500)
      end
    end

    def render_sir_trevor_block(object, image_type = 'large')
      view_name = "publish_elf/sir-trevor/blocks/#{object['type'].to_s.downcase}_block.html.erb"

      render(view_name,
             :block => object['data'],
             :image_type => image_type) if object.has_key?("data")
    end

    def wrap_images_with_links(html_str, src)
      html_str.gsub(/<img[^>]*>/) do |img|
        link_to(img.html_safe, src)
      end
    end

  end
end
