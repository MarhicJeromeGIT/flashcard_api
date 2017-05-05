Rails.application.routes.draw do
  root to: "apidoc/apidoc#index", defaults: { format: 'json' }
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'authenticate', to: 'application#authenticate_user'
      get 'study_schedule', to: 'cards#study_schedule'
      get 'cards', to: 'cards#index'
      post 'assessments/:card_id', to: 'assessments#assess'

      scope :statistics do
        get 'forecast', to: 'statistics#forecast'
        get 'answer_buttons', to: 'statistics#answer_buttons'
        get 'cumulative_time', to: 'statistics#cumulative_time'
      end
    end
  end

  # For the swagger json api documentation definition generation
  get 'apidoc', to: 'apidoc/apidoc#index', defaults: { format: 'json' }
end
