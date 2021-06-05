Rails.application.routes.draw do
  get 'chats/show'
  devise_for :users
  root to: "homes#top"
  get "/home/about" => "homes#about"
  get 'search' => 'searchs#seach'
  # チャット機能
  get 'chat/:id' => 'chats#show', as: 'chat'
  resources :chats, only: [:create]
  
  # フォロー機能
  post 'follow/:id' => 'relationships#follow', as: 'follow' # フォローする
  post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow' # フォロー外す
  resources :users do
    get :follow, on: :member
    get :follower, on: :member
  end
  
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

end
