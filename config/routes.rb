Rails.application.routes.draw do

  #ログイン
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  #トップページ
  root to: 'toppages#index'
  
  #アカウント作成・編集・削除
  get 'signup', to: 'users#new'
  resources :users do
    collection do
      get :search
    end
  end
  
  #Book作成
  resources :books

  
  #WholeAnswer作成
  resources :whole_answers
  
  #base_periods作成
  resources :base_periods, :except => [:new] do
    collection do
      get :new_names
      get :new_contents
      post :create_names
      post :create_contents
    end
    member do
      get :new_content
    end
  end
end