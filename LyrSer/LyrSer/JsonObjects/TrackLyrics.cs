using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LyrSer
{

    public class LyricsHeader
    {
        [JsonProperty("status_code")]
        public int status_code { get; set; }
        [JsonProperty("execute_time")]
        public double execute_time { get; set; }
        [JsonProperty("maintenance_id")]
        public int maintenance_id { get; set; }
    }

    public class Lyrics
    {
        [JsonProperty("lyrics_id")]
        public int lyrics_id { get; set; }
        [JsonProperty("restricted")]
        public int restricted { get; set; }
        [JsonProperty("instrumental")]
        public int instrumental { get; set; }
        [JsonProperty("explicit")]
        public int @explicit { get; set; }
        [JsonProperty("lyrics_body")]
        public string lyrics_body { get; set; }
        [JsonProperty("lyrics_language")]
        public string lyrics_language { get; set; }
        [JsonProperty("lyrics_language_description")]
        public string lyrics_language_description { get; set; }
        [JsonProperty("script_tracking_url")]
        public string script_tracking_url { get; set; }
        [JsonProperty("pixel_tracking_url")]
        public string pixel_tracking_url { get; set; }
        [JsonProperty("html_tracking_url")]
        public string html_tracking_url { get; set; }
        [JsonProperty("lyrics_copyright")]
        public string lyrics_copyright { get; set; }
        [JsonProperty("writer_list")]
        public IList<object> writer_list { get; set; }
        [JsonProperty("publisher_list")]
        public IList<object> publisher_list { get; set; }
        [JsonProperty("updated_time")]
        public DateTime updated_time { get; set; }
    }

    public class LyricsBody
    {        
        [JsonProperty("lyrics")]
        public Lyrics lyrics { get; set; }
    }

    public class LyricsMessage
    {
        [JsonProperty("header")]
        public LyricsHeader header { get; set; }
        
        [JsonProperty("body")]        
        public LyricsBody body { get; set; }
    }

    public class TrackLyrics
    {
        [JsonProperty("message")]
        public LyricsMessage message { get; set; }
    }

}
