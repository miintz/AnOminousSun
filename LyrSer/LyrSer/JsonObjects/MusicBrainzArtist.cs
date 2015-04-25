using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LyrSer
{
    public class Area
    {
        [JsonProperty("id")]
        public string id { get; set; }
        [JsonProperty("name")]
        public string name { get; set; }
        [JsonProperty("sort-name")]
        public string sortname { get; set; }
    }

    public class LifeSpan
    {
        [JsonProperty("begin")]
        public string begin { get; set; }
        [JsonProperty("ended")]
        public object ended { get; set; }
    }

    public class Alias
    {
        [JsonProperty("sort-name")]
        public string sortname { get; set; }
        [JsonProperty("name")]
        public string name { get; set; }
        [JsonProperty("locale")]
        public object locale { get; set; }
        [JsonProperty("type")]
        public object type { get; set; }
        [JsonProperty("primary")]
        public object primary { get; set; }
        [JsonProperty("begin-date")]
        public object begindate { get; set; }
        [JsonProperty("end-date")]
        public object enddate { get; set; }
    }

    public class Tag
    {
        [JsonProperty("count")]
        public int count { get; set; }
        [JsonProperty("name")]
        public string name { get; set; }
    }

    public class Artist
    {
        [JsonProperty("id")]
        public string id { get; set; }
        [JsonProperty("type")]
        public string type { get; set; }
        [JsonProperty("score")]
        public string score { get; set; }
        [JsonProperty("name")]
        public string name { get; set; }
        [JsonProperty("sort-name")]
        public string sortname { get; set; }
        [JsonProperty("country")]
        public string country { get; set; }
        [JsonProperty("area")]
        public Area area { get; set; }
        [JsonProperty("life-span")]
        public LifeSpan lifespan { get; set; }
        [JsonProperty("aliases")]
        public IList<Alias> aliases { get; set; }
        [JsonProperty("tags")]
        public IList<Tag> tags { get; set; }
    }

    public class MusicBrainzArtist
    {
        [JsonProperty("created")]
        public DateTime created { get; set; }
        [JsonProperty("count")]
        public int count { get; set; }
        [JsonProperty("offset")]
        public int offset { get; set; }
        [JsonProperty("artists")]
        public IList<Artist> artists { get; set; }
    }    
}
