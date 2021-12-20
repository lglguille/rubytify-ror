require 'yaml'
require 'rest-client'
require 'json'

desc "Importa y almacena la informacion de artists, albums, y tracks"

namespace :Rubytify do

  task artist: :environment do
    
     #Se carga el achivo que contiene la lista de los artistas a cargar 
    artists_array = YAML.load_file('artist.yml')
    
    #Se genera token para el acceso a la API de Spotify
    token = { "Authorization": "Bearer BQAMnOZ0RS5m_w0muiDVIZj7wSXc-0q1pgx8zQn-2IWIc_LPvs-g9KSCsa77AC4wYN3vtHG0sx-zu44xpG89klQFELwP4p231SaOdXjVB6mj_dQEyv4Ywr3H1Yd_pfGUxt9dRsbarUts861CV6P8u49Oix7i2aSCFBpU13Kng7J9mgA" }
    
    #Se invoca metodo para almacenar los artistas
    save_artists(artists_array,token)
    
  end

end


def save_artists(artists,token)
  
  #Se recorre el listado de artistas
  for art in artists["artists"]
    
    #Se consulta el identificador del artista 
    art_id_data = RestClient.get("https://api.spotify.com/v1/search?q=#{ art }&type=artist",headers= token)
    art_id_info = JSON.parse(art_id_data)
    art_id = art_id_info["artists"]["items"][0]["id"]
    
    #Se conulta toda la informacion del artista
    art_data = RestClient.get("https://api.spotify.com/v1/artists/#{ art_id }",headers=token)
    art_info = JSON.parse(art_data)
    
    #Se almacena la informacion del artista
    @artist_new = Artist.create(
                  name: art_info["name"],
                  image: art_info["images"][0]["url"],
                  genres: art_info["genres"],
                  popularity: art_info["popularity"],
                  spotify_url: art_info["external_urls"]["spotify"],
                  spotify_id: art_id
                  )

    
    #Se invoca metodo para almacenar los albums asociado a un artista
    save_album_by_artis(@artist_new.id,art_id,token)
    
  end
  
end 


def save_album_by_artis(art_id, art_id_url, token)
  
  #Se conulta toda la informacion de los albums de un artista
  album_data = RestClient.get("https://api.spotify.com/v1/artists/#{ art_id_url }/albums",headers=token)
  album_info = JSON.parse(album_data)
  
  #Se recorre los albums
  album_info["items"].each do |album|
      
      #Se almacena la informacion del album
      @album_new = Album.create(
                  name: album["name"],
                  image: album["images"].present? ? album["images"][0]["url"]: "" ,
                  spotify_url: album["external_urls"]["spotify"],
                  total_tracks: album["total_tracks"],
                  spotify_id: album["id"],
                  artist_id: art_id
                   )
        
      #Se invoca metodo para almacenar tracks asociadas a un album
      save_song_by_album(@album_new.id,album["id"],token)
      
  end
  
end

def save_song_by_album(alb_id, alb_id_url, token)
  
  #Se conulta toda la informacion de tracks de un album
  song_data = RestClient.get("https://api.spotify.com/v1/albums/#{alb_id_url}/tracks",headers=token)
  song_info = JSON.parse(song_data)
  
  #Se recorre tracks
  song_info["items"].each do |song|
      
      #Se almacena la informacion del track
      @song_created = Song.create(
                                      name: song["name"],
                                      spotify_url: song["external_urls"]["spotify"],
                                      preview_url: song["preview_url"],
                                      duration_ms: song["duration_ms"],
                                      explicit: song["explicit"],
                                      spotify_id: song["id"],
                                      album_id: alb_id
                                       )
        
      
      
  end
  
end
