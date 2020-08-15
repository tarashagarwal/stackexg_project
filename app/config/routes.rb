Rails.application.routes.draw do
	# This line mounts Solidus's routes at the root of your application.
	# This means, any requests to URLs such as /products, will go to Spree::ProductsController.
	# If you would like to change where this engine is mounted, simply change the :at option to something different.
	#
	# We ask that you don't use the :as option here, as Solidus relies on it being the default of "spree"
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
	# scope module: 'odrnow' do
	# 	#resources :menu
	# 	namespace :api do
	# 		get 'get_menu' => 'menu#load_menu_for_resturant'
	# 	end
	# 	get 'get_menu' => 'menu#index' 
	# end
	scope module: 'stackexg' do
		#resources :menu
		namespace :api do
			get 'get_questions' => 'questions#load_questions'
		end
		get 'get_questions' => 'questions#index'
		get '/' => 'questions#redirects'
	end
	
	#mount Spree::Core::Engine, at: '/'
end
