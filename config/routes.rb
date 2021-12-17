Rails.application.routes.draw do
  root 'static_pages#home'
  get '/signup', to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  get 'users/:id/works/:date', to:'users#works'

  resources :works, only:[:new, :edit,
                          :create,:update,:destroy]
  post '/working',  to: 'working_buttons#start'
  patch '/working',  to: 'working_buttons#finish'
  patch '/rights/user_update', to:'rights#user_update'

end