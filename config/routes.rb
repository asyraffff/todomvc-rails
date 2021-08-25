Rails.application.routes.draw do
  root 'todos#index'
  get 'active', to: 'todos#index', as: 'active_todos', scope: 'active'
  get 'completed', to: 'todos#index', as: 'completed_todos', scope: 'completed'
  resources :todos, except: [:index, :new, :edit] do
    collection do
      patch 'toggle_all'
      delete 'clear_completed'
    end
  end
end
