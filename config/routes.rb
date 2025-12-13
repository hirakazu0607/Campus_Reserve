Rails.application.routes.draw do

  # ヘルスチェック用（本番環境で使用）
  get "up" => "rails/health#show", as: :rails_health_check

  # 🏠 ルートページ
  root "static_pages#index"

  # 📄 静的ページ
  get "home",  to: "static_pages#index"
  get "about", to: "static_pages#about"
  get "help",  to: "static_pages#help"

  # 👤 ユーザー登録
  resources :users, only: [ :new, :create ]
end
