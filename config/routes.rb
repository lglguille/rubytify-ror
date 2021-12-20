Rails.application.routes.draw do
  #resources :songs
  #resources :albums
  #resources :artists
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  get '/api/v1/artists', to: 'artists#index'
  get '/api/v1/artists/:id/albums', to: 'albums#show_albums_artist'
  get '/api/v1/albums/:id/songs', to: 'songs#show_songs_album'
  get '/api/v1/genres/:genre_name/random_song', to: 'songs#show_random_song'
  
end
