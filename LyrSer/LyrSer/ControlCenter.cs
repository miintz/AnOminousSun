﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Drawing.Imaging;

using Tesseract;
using Newtonsoft.Json;
using System.Text.RegularExpressions;

using BlueSimilarity;
using BlueSimilarity.Containers;
using BlueSimilarity.Types;

namespace LyrSer
{
    public partial class ControlCenter : Form
    {
        String MusixAPI = "a521cb8d087de3e7978da22b104fd880";
        Dictionary<string, double> GenreEvilness = new Dictionary<string, double>();
        public ControlCenter()
        {
            InitializeComponent();

            PopulateGenreEvilnessList();
        }

        private void btnReadText_Click(object sender, EventArgs e)
        {
            //1. Get screenshot from projected phone            
            lblMsg.Text = "Getting Screenshot";
            rtLyrics.Text = ""; //reset this
            rtMatched.Text = ""; //and this
            lblStatus.Text = ""; //and then also this
            lblGenre.Text = ""; //yeah this as well
            lblEvilness.Text = ""; //while you're at it

            this.Refresh();

            int topsize = 85;
            int widthsize = 445;
            int left = -1200;
            int top = 365;

            String MatchedText = String.Empty;
            Bitmap bmp = new Bitmap(widthsize, topsize, PixelFormat.Format32bppArgb);

            using (Graphics g = Graphics.FromImage(bmp))
            {
                String ProcName = "ProjectMyScreenApp";

                try
                {
                    var proc = Process.GetProcessesByName(ProcName)[0];
                    var rect = new User32.Rect();

                    User32.GetWindowRect(proc.MainWindowHandle, ref rect);

                    Graphics graphics = Graphics.FromImage(bmp);
                    g.CopyFromScreen(left, top, 0, 0, new Size(widthsize, topsize), CopyPixelOperation.SourceCopy);

                    //make it a big bigger first
                    Size si = new Size(bmp.Width * 2, bmp.Height * 2); //bump up the size to increase BlueSimilarity's change of not fudging the text, if it fails anyway we can use MusicBrainz
                    bmp = ResizeImage(bmp, si);

                    bmp.Save("lastsearch.png");
                }
                catch (Exception exc)
                {
                    bmp = new Bitmap(Bitmap.FromFile("lastsearch.png"));
                }
            }

            //2. Open saved image and fork it over to tesseract
            lblMsg.Text = "Using the OCR thing";
            this.Refresh();

            using (var engine = new TesseractEngine("tesseract-ocr", "eng", EngineMode.Default))
            {
                using (var pix = PixConverter.ToPix(bmp))
                {
                    using (var page = engine.Process(pix))
                    {
                        //3. Get matched text from tesseract
                        lblConfidence.Text = "Confidence: " + page.GetMeanConfidence(); //if this is > 0.85 then its probably OK

                        MatchedText = page.GetText();
                        rtMatched.Text = MatchedText;
                    }
                }
            }

            String[] Lines = MatchedText.Split(new char[] { '\n' });

            String SongName = Lines[0];

            //i also need to get rid of half words, else musixmatch wont match. but first i need to know if the last char is a dot
            if (SongName[SongName.Length - 1] == '.')
            {
                SongName = SongName.Trim(new char[] { '.' });
                //now remove until we hit a space
                Boolean SpaceHit = false;
                while (!SpaceHit)
                {
                    SongName = SongName.Remove(SongName.Length - 1);
                    if (SongName[SongName.Length - 1] == ' ')
                        SpaceHit = true;
                }
            }

            String BandName = Lines[1];

            //3.1 sometimes the artist name get fudged a little (because of Shazam's gray font), so query MusicBrainz to see if it is correct
            lblMsg.Text = "Querying MusicBrainz for meta data";
            this.Refresh();

            Uri BrainzUri = new Uri("https://musicbrainz.org/search?query=" + BandName + "&type=artist&method=indexed");

            String BrainzContentArtist;
            try
            {
                String BrainzContent = new WebClient().DownloadString(BrainzUri);

                String BrainzContent1 = Regex.Split(BrainzContent, "<table class=\"tbl\">")[1]; String BrainzContent2 = Regex.Split(BrainzContent1, "</table>")[0]; String BrainzContentPart = Regex.Split(BrainzContent2, "<tbody>")[1]; String BrainzContentPart1 = Regex.Split(BrainzContentPart, "<bdi>")[1]; BrainzContentArtist = Regex.Split(BrainzContentPart1, "</bdi>")[0];
            }
            catch (Exception E)
            {
                //sometimes this throws an 502, bad gateway error, so we need to compenstate for that in some way
                BrainzContentArtist = BandName;
            }

            if (BrainzContentArtist.ToLower() != BandName.ToLower())
            {
                //3.2 Ok, see if something resembling the name is in here, use BlueSimilarity

                //for instance, "Skehetonwxtch" needs to be "Skeletonwitch"
                var bagOfTokens = new BagOfWordsSimilarity();
                var resultingSim = bagOfTokens.GetSimilarity(new Tokenizer(new NormalizedString(BandName)), new Tokenizer(new NormalizedString(BrainzContentArtist)));

                if (resultingSim > 0.8) //if the similarity = 1.0 they are pretty much the same, or one is substring of the other, so this ought to work with very long names
                {
                    //OK, enough similarity for me, use the name from MusicBrainz
                    BandName = BrainzContentArtist;
                }
            }

            //3.3 now we have the correct artist name we can query MusicBrainz again to check the genre, i can use this to determine how "evil" this song is
            Uri ArtistUri = new Uri("https://musicbrainz.org/ws/2/artist/?query=artist:" + BandName + "&fmt=json");
            String ArtistJson = String.Empty;
            MusicBrainzArtist RetrievedArtistObject = new MusicBrainzArtist();

            //musicbrainz gives 502 and 503 errors, their servers are a bit overloaded sometimes
            try
            {
                WebClient client = new WebClient();

                //we need to add user-agent header else MusicBrainz will slam the door in our faces, and rightly so
                client.Headers.Add("user-agent", "NMNT.AnOminousSun/1.1");
                ArtistJson = client.DownloadString(ArtistUri);

                //3.4 if we have a Json we can deserialize this into the object, this may throw error if we get the Bad Gateway page (that's not Json)
                RetrievedArtistObject = (MusicBrainzArtist)JsonConvert.DeserializeObject(ArtistJson, typeof(MusicBrainzArtist));

            }
            catch (Exception E)
            {
                //again, catch 502 and 503 error
            }

            //4. Query musixmatch
            lblMsg.Text = "Querying Musixmatch for the lyrics";
            this.Refresh();

            Uri TrackSearch = new Uri("http://api.musixmatch.com/ws/1.1/track.search?apikey=" + MusixAPI + "&q_artist=" + BandName + "&q_track=" + SongName);
            var json_search = new WebClient().DownloadString(TrackSearch);

            TrackSearch RetrievedTrack = (TrackSearch)JsonConvert.DeserializeObject(json_search, typeof(TrackSearch));

            if (((String)json_search).Contains("401"))
            {
                lblStatus.Text = "401 MAINTENANCE!";
                lblMsg.Text = "401 MAINTENANCE!";
                return;
            }

            //pak de eerste in de lijst
            int TrackId = 0;
            if (RetrievedTrack.message.body.track_list.Count != 0)
            {
                TrackId = RetrievedTrack.message.body.track_list[0].track.track_id;
                lblStatus.Text = "Found the song you where looking for";
            }
            else
            {
                lblStatus.Text = "I don't know what this song is";
                rtLyrics.Text = "";

                return;
            }
            String Lyr = String.Empty;
            if (TrackId != 0)
            {
                //now we can get the lycs
                Uri TrackLyrics = new Uri("http://api.musixmatch.com/ws/1.1/track.lyrics.get?apikey=" + MusixAPI + "&track_id=" + TrackId);
                var json_lyrics = new WebClient().DownloadString(TrackLyrics);

                //this goes a little bit wrong if there are no lyrics, i cant figure out the nullable types thing so am just gonna try catch this bugger
                TrackLyrics RetrievedLyrics;

                String Copyright = String.Empty;

                try
                {
                    RetrievedLyrics = (TrackLyrics)JsonConvert.DeserializeObject(json_lyrics, typeof(TrackLyrics));
                    Lyr = RetrievedLyrics.message.body.lyrics.lyrics_body;


                    Copyright = RetrievedLyrics.message.body.lyrics.lyrics_copyright;
                }
                catch
                {
                    return;
                }


                if (Copyright != "Unfortunately we're not authorized to show these lyrics.")
                {
                    if (Lyr != null && Lyr != "")
                    {
                        //lyrics present
                        Lyr = Lyr.Replace("******* This Lyrics is NOT for Commercial use *******", ""); //yeah yeah ok, i get it. I dont want to see it tho
                        Lyr = Lyr.Replace("...", "");

                        rtLyrics.Text = Lyr;

                        //we need to sanitize the string
                        Lyr = Regex.Replace(Lyr, @"\s+", " ");
                    }
                    else
                    {
                        lblStatus.Text = "Can't find any lyrics for this, sorry";
                        rtLyrics.Text = "";

                        return;
                    }
                }
                else
                {
                    lblStatus.Text = "Copyright problem, i can't show the lyrics.";
                    rtLyrics.Text = "";

                    //so... i cant really show the lyrics, but i can figure out the evilness probably
                }
            }

            //5. cool, now we have the lyrics. Save these to a file so the visualizer can read it
            //before we do this however, we need to get the genres so we can calculate the level of "evilness"
            //we could analyse the lyrics... buuuuut we're just gonna look at the genres for now, its in the RetrievedTrack object somewhere

            double Evilness = 0.0;
            double Genre = 0.0;

            if (RetrievedArtistObject.artists != null && RetrievedArtistObject.artists[0] != null)
            {
                IList<Tag> a = RetrievedArtistObject.artists[0].tags;

                if (a != null)
                {
                    foreach (Tag tag in a)
                    {
                        String genre = tag.name.ToLower();

                        lblGenre.Text += genre + ", ";

                        if (GenreEvilness.ContainsKey(genre))
                        {
                            Evilness += GenreEvilness[genre];
                            Genre += 1.0;
                        }
                    }

                    Evilness = Evilness / Genre;
                    Evilness = Math.Round(Evilness, 2);
                }
            }

            if (Evilness.ToString() == "NaN" || Evilness == 0.0)
            {
                Evilness = 5.0;
                lblGenre.Text = "None found (maybe MusicBrainz threw a 502, may work again later)";
            }

            lblEvilness.Text = Evilness.ToString();
            lblMsg.Text = "Writing to file!";

            //6. Ok all done, now we need to write it to a text file somewhere. theres a max of 5 streams so we need to check which one is available
            //we do this by checking file creation data

            int ThreadNumber = 0;
            String Latest = String.Empty;

            if (!Directory.Exists("./LyrOut/"))
            {
                //ok, so this doesnt exist. ezpz then
                Directory.CreateDirectory("./LyrOut/");

                //also write 10 files for the lyrics so the next bit is a little easier
                for (int i = 0; i < 10; i++)
                {
                    FileStream outf = System.IO.File.Create("./LyrOut/lyrout-" + i.ToString() + ".txt");
                    outf.Close(); //we need to close this now
                }
            }
            else
            {
                //get oldest files
                FileInfo fileinf = new DirectoryInfo("./LyrOut/").EnumerateFiles().OrderByDescending(x => x.LastWriteTime).Reverse().ToList().First();

                //seems as if we took the second route
                String[] parts = fileinf.Name.Split(new char[] { '-' });

                //split again
                String[] parts1 = parts[1].Split(new char[] { '.' });

                //first part should be theadnumber
                ThreadNumber = Int32.Parse(parts1[0]);
            }

            //now we should have the theadnumber one way or another, we can write to file now

            //so... write to file, but first create it!
            String FileName = "./LyrOut/lyrout-" + ThreadNumber.ToString() + ".txt";
            FileStream f = System.IO.File.Create(FileName);
            f.Close(); //we need to close this

            lblOutFileN.Text = ThreadNumber.ToString();

            //now stream lycs to the new file
            using (StreamWriter Writer = new StreamWriter(FileName))
            {
                LyrOut lyr = new LyrOut();
                lyr.Evilness = lblEvilness.Text.ToString();
                lyr.Genres = lblGenre.Text.ToString();
                lyr.Lyrics = Lyr;

                //write this as JSON, so we can parse it later on in any language
                string output = JsonConvert.SerializeObject(lyr);
                Writer.Write(output);

                Writer.Close();
                Writer.Dispose();
            }

            //done writing lyrics

            lblMsg.Text = "OK!";
            this.Refresh();
        }

        /// <summary>
        /// Resize a bitmap to a certain size, cutting it down a size or supersizing it, you have to size these options up before you can size up the competition. 
        /// </summary>
        /// <param name="imgToResize"></param>
        /// <param name="size"></param>
        /// <returns></returns>
        public static Bitmap ResizeImage(Bitmap imgToResize, Size size)
        {
            Bitmap b = new Bitmap(size.Width, size.Height);

            using (Graphics g = Graphics.FromImage((Image)b))
            {
                g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                g.DrawImage(imgToResize, 0, 0, size.Width, size.Height);
            }

            return b;
        }

        private void PopulateGenreEvilnessList()
        {
            //populate the evilness list, 0.00 = fluffy bunny / 10.00 = antichrist

            //metal genres
            GenreEvilness.Add("death metal", 8.5);
            GenreEvilness.Add("melodic death metal", 7.5);
            GenreEvilness.Add("progressive death metal", 7.5);
            GenreEvilness.Add("black metal", 9.5);
            GenreEvilness.Add("trash metal", 7.5);
            GenreEvilness.Add("heavy metal", 7.5);
            GenreEvilness.Add("sludge metal", 8.5);
            GenreEvilness.Add("doom metal", 8.0);
            GenreEvilness.Add("metal", 7.5);
            GenreEvilness.Add("viking metal", 7.0);

            //rock genres
            GenreEvilness.Add("rock & roll", 5.0);
            GenreEvilness.Add("rock", 5.0);
            GenreEvilness.Add("classic rock", 4.0);
            GenreEvilness.Add("soft rock", 4.0);
            GenreEvilness.Add("blues rock", 4.5);

            //jazz blues etc
            GenreEvilness.Add("jazz", 4.0);
            GenreEvilness.Add("modern jazz", 5.0);
            GenreEvilness.Add("bebop", 5.0);
            GenreEvilness.Add("ska", 4.0);
            GenreEvilness.Add("blues", 3.0);

            //some electronic stuff, i dont know anything about this
            GenreEvilness.Add("electronic", 4.0);
            GenreEvilness.Add("eurohouse", 10.0); //lol
            GenreEvilness.Add("hardcore", 7.0);
            GenreEvilness.Add("dubstep", 6.0);
            GenreEvilness.Add("dnb", 6.0);
            GenreEvilness.Add("ambient", 2.0);
            GenreEvilness.Add("idm", 6.0);

            //hip hop
            GenreEvilness.Add("East Coast", 8.0);
            GenreEvilness.Add("Hip Hop", 8.0);
            GenreEvilness.Add("Gangsta Rap", 9.0);
        }
    }
    public static class MyStringExtensions
    {
        public static bool Like(this string toSearch, string toFind)
        {
            return new Regex(@"\A" + new Regex(@"\.|\$|\^|\{|\[|\(|\||\)|\*|\+|\?|\\").Replace(toFind, ch => @"\" + ch).Replace('_', '.').Replace("%", ".*") + @"\z", RegexOptions.Singleline).IsMatch(toSearch);
        }
    }

    //PInvoke meuk
    class User32
    {
        [StructLayout(LayoutKind.Sequential)]
        public struct Rect
        {
            public int left;
            public int top;
            public int right;
            public int bottom;
        }

        [DllImport("user32.dll")]
        public static extern IntPtr GetWindowRect(IntPtr hWnd, ref Rect rect);
    }
}
