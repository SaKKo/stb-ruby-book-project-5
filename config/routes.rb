Rails.application.routes.draw do
  post   'users/sign_up',  to: 'sessions#sign_up'
  post   'users/sign_in',  to: 'sessions#sign_in'
  delete 'users/sign_out', to: 'sessions#sign_out'
  get    'users/me',       to: 'sessions#me'
  devise_for :users
end

