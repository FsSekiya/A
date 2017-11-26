Rails.application.routes.draw do
  devise_for :customer, controllers: {
    sessions: 'customer/sessions'
  }, skip: %i[registration passwords], class_name: 'Customer'
  devise_scope :customer do
    root to: 'customer/sessions#new'
  end

  namespace :customer do
    resources :dashboard
    resources :branch, only: %i[show]
    resources :setting, only: %i[index]
    resources :worker, only: %i[new create]
    resources :working_record, only: %i[update]
    resources :record, only: %i[show]
  end

  namespace :api, defaults: { format: :json } do
    namespace :worker do
      mount_devise_token_auth_for 'Worker', at: 'auth',
                                            only: %i[sign_in sign_out session],
                                            controllers: {
                                              sessions: 'api/worker/sessions'
                                            }, skip: %i[registration passwords]
      resources :working_record, only: [] do
        collection do
          get :amount
          post :start
          post :finish
        end
      end
    end

    namespace :qr do
      resources :key, only: [:index]
    end

    namespace :customer do
      resources :worker_record, only: [:show, :update]
    end
  end
end
