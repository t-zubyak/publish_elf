PublishElf::Engine.routes.draw do
  match "/blog/by/:author", to: "blogposts#index", via: :get
  match "/blog/tags/:tag_name", to: "blogposts#index", via: :get
  resources :blogposts, :path => 'blog' do
    collection do
      get :sign_s3
    end
  end
  resources :landings, :path => 'for'
end
