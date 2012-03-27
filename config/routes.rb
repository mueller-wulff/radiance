Stitched::Application.routes.draw do
    
  scope :module => 'static' do
    resources :faqs
    resources :unsupported_browsers
    resource :dashboard
  end

  scope :module => 'session' do
    resources :password_resets
    resources :profile_sessions
  end
  match 'logout', :to => 'Session::ProfileSessions#destroy'
  match 'login', :to => 'Session::ProfileSessions#new'

  namespace :student do
    resources :students 
    resources :courses
    
    resources :stitch_modules do 
      resources :stitch_units  do
        member do
          get 'ajax_show'
        end
      end
    end
    
    resources :stitch_units do
      resources :pages do
        member do
          get 'ajax_show'
          post 'send_answers'
        end
      end
    end
    
    resources :pages do
      resources :contents    
    end
    
    resources :contents do
      resources :element do
        resources :answers
      end
    end
        
  end
  
  namespace :tutor do
    resources :students do
      resources :profiles
    end
    
    resources :groups do
      resources :students do
        member do
          get 'shuffle'
          put 'update_shuffle'
        end
        resources :pages do
          member do
            get 'show_answers'
          end
        end
      end
    end

    resources :notes
    resources :responses
    resources :courses
    resources :stitch_modules do 
      resources :stitch_units  do
        member do
          get 'ajax_show'
        end
      end
    end
    
    resources :stitch_units do
      resources :pages do
        member do
          get 'ajax_show'
        end
      end
    end
    
    resources :pages do
      resources :contents
    end
    
  end

  #special route for open units in module show
  match 'developer/stitch_modules/:id(/open_unit/:stitch_unit_id)' => 'developer/stitch_modules#show', :as => "developer_stitch_module_open_unit"

  namespace :developer do
    resources :courses do
      resource :stitch_unit_copy
    end

    resources :stitch_modules do
      resource :stitch_units_order
      resource :page_copy
      resource :page_move
      resources :stitch_units  do
        member do
          get 'ajax_show'
        end
      end
    end

    resources :stitch_units do
      resource :pages_order
      resources :pages do
        member do
          get 'ajax_show'
          get 'ajax_edit'
          post 'make_assignment'
        end
      end
    end
    resources :pages do
      resources :contents
      resource :contents_order
    end
  end


  namespace :admin do
    resources :courses do
      member do
        post 'deprecate'
        post 'publish'
      end
      resources :stitch_modules
      resource :stitch_modules_order
    end
    resources :tutors do
      resources :profiles
    end
    resources :developers do
      resources :profiles
    end
  end

  root :to => "Static::Dashboard#index"

end
