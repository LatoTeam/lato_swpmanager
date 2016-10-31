LatoSwpmanager::Engine.routes.draw do

  # Profile
  get 'profile', to: 'back/back#profile', as: 'profile'

  # Resources
  resources :projects, module: 'back'
  resources :clients, module: 'back'
  resources :collaborators, module: 'back'
  resources :tasks, except: [:new, :index], module: 'back'
  resources :task_messages, only: [:create, :destroy], module: 'back'

  # Project extra
  get 'project_extra/tasks/:id', to: 'back/projects#tasks', as: 'project_tasks'

end