Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "products#index"

  # Define a route for viewing the cart
  get 'cart', to: 'carts#show', as: 'cart'

  # Define a route for adding a product to the cart
  post 'cart/add/:id', to: 'carts#add_to_cart', as: 'add_to_cart'

  # Define a route for clearing the cart
  delete 'cart/clear', to: 'carts#clear_cart', as: 'clear_cart'
end
