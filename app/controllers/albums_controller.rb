class AlbumsController < ApplicationController

  # GET /api/v1/artists/:id/albums
  def show_albums_artist
    
    #Obtiene los albums de un artista seleccionado
    @artist = Artist.find(params[:id])
    @albums = @artist.albums
    
    render json: @albums, root: 'data', each_serializer: AlbumSerializer
    
  end

  
end
