Rails.application.routes.draw do
  root to: redirect('activities')

  devise_for :employees, controllers: {
    sessions: 'employees/sessions'
  }

  resources :customers
  resources :customer_groups
  resources :activity_categories do
    resources :text_templates
  end
  resources :activities do
    collection do
      scope module: :activities, as: :activities do
        resources :suggestions, only: [:index]
        resources :reports, only: [:new, :create]
      end
    end
  end
  resources :op_lists, only: [:new, :create]

  resources :expenses
  resources :absences
  resources :employees do
    resources :hourly_rates
  end

  resources :target_hours, only: [:index]
  resource :target_hours, only: [:update]

  resources :hours, only: [:index] do
    collection do
      scope module: :hours, as: :hours do
        resources :subjects, only: [:index]
        resources :calendar_events, only: [:index]
      end
    end
  end

  resources :invoices, except: :edit do
    member do
      patch :deliver
      patch :charge
      patch :reopen
    end

    scope module: :invoices do
      resources :activities, except: [:new, :index] do
        get :templates
        patch :reorder
        patch :toggle_pagebreak
        patch :ungroup
        patch :group, on: :collection
        post :generate, on: :collection
      end

      collection do
        namespace :activities do
          resources :suggestions, only: [:index]
        end
      end

      resources :expenses, except: [:new, :index] do
        patch :reorder
        patch :ungroup
        patch :group, on: :collection
        post :generate, on: :collection
      end

      resources :payments
      resource :delivery, only: [:new, :update]
      resource :mail, only: [:new, :create, :show]
      resource :pdf, only: [:new, :show] do
        get :qr_bill
      end

      controller '/invoices/wizard' do
        patch :wizard, action: :update

        namespace :wizard do
          get :customer
          get :activities
          get :expenses
          get :complete
          get :summary

          patch :finish
        end
      end
    end
  end

  resources :debtors_reports, only: [:new, :create]
  resources :versions, only: [:index]
  resources :settings, only: [:index, :update]
end
