PublishElf::Engine.routes.draw do
  match "/blog/by/:author", to: "blogposts#index", via: :get
  match "/blog/tags/:tag_name", to: "blogposts#index", via: :get, as: "blog_tag"
  resources :blogposts, :path => 'blog' do
    collection do
      get :sign_s3
    end
  end
  resources :landing_pages, :path => 'welcome'
end
