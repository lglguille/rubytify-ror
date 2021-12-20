class SongsController < ApplicationController

  # GET /api/v1/albums/:id/songs
  def show_songs_album
    
    #Obtiene tracks de un album seleccionado
    @album = Album.find(params[:id])
    @songs = @album.songs
    
    render json: @songs, root: 'data', each_serializer: SongSerializer
    
  end
  
  # GET /api/v1/genres/:genre_name/random_song
  def show_random_song
    
    #Consulta el genero seleccionado y selecciona una cancion aleatoria
    @song = Song.joins(album: :artist).where(" CAST(genres AS VARCHAR) LIKE? ", "%\"#{params[:genre_name]}\"%").sample
      
    if @song.nil?
      render json:{ error:"El genero no existe: #{params[:genre_name]}" }, status:400
    else
      render json: @song, root: 'data', each_serializer: SongSerializer    
    end  
      
  end
  
end
