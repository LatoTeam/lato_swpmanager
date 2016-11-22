LatoSwpmanager::Engine.routes.draw do

  root 'back/back#home'

  # Resources
  resources :projects, module: 'back'
  resources :clients, module: 'back'
  resources :collaborators, module: 'back'
  resources :tasks, except: [:index], module: 'back'
  resources :task_messages, only: [:create, :destroy], module: 'back'
  resources :task_categories, only: [:index, :create, :destroy], module: 'back'

  # Project extra
  get 'project_extra/tasks/:id', to: 'back/projects#tasks', as: 'project_tasks'
  get 'project_extra/tasks/:id/update_late_tasks', to: 'back/projects#update_late_tasks', as: 'project_update_late_tasks'
  get 'project_extra/tasks/:id/settings_print_tasks', to: 'back/projects#settings_print_tasks', as: 'project_settings_print_tasks'
  post 'project_extra/tasks/:id/print_tasks', to: 'back/projects#print_tasks', as: 'project_print_tasks'
  get 'project_extra/stats/:id', to: 'back/projects#stats', as: 'project_stats'

end
