class ArtistsController < ApplicationController
 
  # GET /api/v1/artists
  def index
    #obtiene toda la lista de artistas ordenados por popularidad
    @artists = Artist.all.order(popularity: :desc)

    render json: @artists, root: 'data', each_serializer: ArtistSerializer
  end

end
