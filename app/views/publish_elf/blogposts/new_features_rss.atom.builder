atom_feed :language => 'en-US' do |feed|
  feed.title @title
  feed.updated @updated
  @posts.each do |post|
    next if post.posted_on.blank?
    feed.entry(post) do |entry|
      entry.url post_url(post)
      entry.title post.title
      entry.content render_post_body(post.body), :type => 'html'
      entry.updated(post.posted_on.strftime("%Y-%m-%dT%H:%M:%SZ"))
    end
  end
end