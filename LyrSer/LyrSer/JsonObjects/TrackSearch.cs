using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LyrSer
{
     public class SearchHeader
    {
        [JsonProperty("status_code")]
        public int status_code { get; set; }
        [JsonProperty("execute_time")]
        public double execute_time { get; set; }
        [JsonProperty("available")]
        public int available { get; set; }
        [JsonProperty("maintenance_id")]
        public int maintenance_id { get; set; }
    }

    public class MusicGenre
    {
        [JsonProperty("music_genre_id")]
        public int music_genre_id { get; set; }
        [JsonProperty("music_genre_parent_id")]
        public int music_genre_parent_id { get; set; }
        [JsonProperty("music_genre_name")]
        public string music_genre_name { get; set; }
        [JsonProperty("music_genre_name_extended")]
        public string music_genre_name_extended { get; set; }
        [JsonProperty("music_genre_vanity")]
        public string music_genre_vanity { get; set; }
    }

    public class MusicGenreList
    {
        [JsonProperty("music_genre")]
        public MusicGenre music_genre { get; set; }
    }

    public class PrimaryGenres
    {
        [JsonProperty("music_genre_list")]
        public IList<MusicGenreList> music_genre_list { get; set; }
    }

    public class MusicGenre2
    {
        [JsonProperty("music_genre_id")]
        public int music_genre_id { get; set; }
        [JsonProperty("music_genre_parent_id")]
        public int music_genre_parent_id { get; set; }
        [JsonProperty("music_genre_name")]
        public string music_genre_name { get; set; }
        [JsonProperty("music_genre_name_extended")]
        public string music_genre_name_extended { get; set; }
        [JsonProperty("music_genre_vanity")]
        public string music_genre_vanity { get; set; }
    }

    public class MusicGenreList2
    {
        [JsonProperty("music_genre")]
        public MusicGenre2 music_genre { get; set; }
    }

    public class SecondaryGenres
    {
        [JsonProperty("music_genre_list")]
        public IList<MusicGenreList2> music_genre_list { get; set; }
    }

    public class Track
    {
        [JsonProperty("track_id")]
        public int track_id { get; set; }
        [JsonProperty("track_mbid")]
        public string track_mbid { get; set; }
        [JsonProperty("track_isrc")]
        public string track_isrc { get; set; }
        [JsonProperty("track_spotify_id")]
        public string track_spotify_id { get; set; }
        [JsonProperty("track_soundcloud_id")]
        public int track_soundcloud_id { get; set; }
        [JsonProperty("track_xboxmusic_id")]
        public string track_xboxmusic_id { get; set; }
        [JsonProperty("track_name")]
        public string track_name { get; set; }
        [JsonProperty("track_name_translation_list")]
        public IList<object> track_name_translation_list { get; set; }
        [JsonProperty("track_rating")]
        public int track_rating { get; set; }
        [JsonProperty("track_length")]
        public int track_length { get; set; }
        [JsonProperty("commontrack_id")]
        public int commontrack_id { get; set; }
        [JsonProperty("instrumental")]
        public int instrumental { get; set; }
        [JsonProperty("explicit")]
        public int @explicit { get; set; }
        [JsonProperty("has_lyrics")]
        public int has_lyrics { get; set; }
        [JsonProperty("has_subtitles")]
        public int has_subtitles { get; set; }
        [JsonProperty("num_favourite")]
        public int num_favourite { get; set; }
        [JsonProperty("lyrics_id")]
        public int lyrics_id { get; set; }
        [JsonProperty("subtitle_id")]
        public int subtitle_id { get; set; }
        [JsonProperty("album_id")]
        public int album_id { get; set; }
        [JsonProperty("album_name")]
        public string album_name { get; set; }
        [JsonProperty("artist_id")]
        public int artist_id { get; set; }
        [JsonProperty("artist_mbid")]
        public string artist_mbid { get; set; }
        [JsonProperty("artist_name")]
        public string artist_name { get; set; }
        [JsonProperty("album_coverart_100x100")]
        public string album_coverart_100x100 { get; set; }
        [JsonProperty("album_coverart_350x350")]
        public string album_coverart_350x350 { get; set; }
        [JsonProperty("album_coverart_500x500")]
        public string album_coverart_500x500 { get; set; }
        [JsonProperty("album_coverart_800x800")]
        public string album_coverart_800x800 { get; set; }
        [JsonProperty("track_share_url")]
        public string track_share_url { get; set; }
        [JsonProperty("track_edit_url")]
        public string track_edit_url { get; set; }
        [JsonProperty("commontrack_vanity_id")]
        public string commontrack_vanity_id { get; set; }
        [JsonProperty("restricted")]
        public int restricted { get; set; }
        [JsonProperty("updated_time")]
        public DateTime updated_time { get; set; }
        [JsonProperty("primary_genres")]
        public PrimaryGenres primary_genres { get; set; }
        [JsonProperty("secondary_genres")]
        public SecondaryGenres secondary_genres { get; set; }
    }

    public class TrackList
    {
        [JsonProperty("track")]
        public Track track { get; set; }
    }

    public class Body
    {
        [JsonProperty("track_list")]
        public IList<TrackList> track_list { get; set; }
    }

    public class Message
    {
        [JsonProperty("header")]
        public SearchHeader header { get; set; }
        [JsonProperty("body")]
        public Body body { get; set; }
    }

    public class TrackSearch
    {
        [JsonProperty("message")]
        public Message message { get; set; }
    }
}
