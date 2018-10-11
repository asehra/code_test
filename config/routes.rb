Rails.application.routes.draw do
  resource :callback, only: [:new, :create]
  scope :callback do
    get 'success', to: 'callbacks#success'
  end
end
