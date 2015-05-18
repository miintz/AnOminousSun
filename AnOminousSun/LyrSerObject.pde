class LyrSerObject
{
  float Evilness;
  String Genres;
  String Lyrics;
  
  int Progress; //aantal woorden
  int MaxProgress; 
  int Index;
  
  PFont ActiveFont;
  
  Boolean Invalidated = false;
  
  LyrSerObject(float _Evilness, String _Genres, String _Lyrics)
  {
    Evilness = _Evilness;
    Genres = _Genres;
    Lyrics = _Lyrics;
    
    Progress = 0;
    
    String[] Lines = split(Lyrics, ' ');
    
    MaxProgress = Lines.length;
  } 
  
  public String returnCurrent()  
  {
    //return 3 woorden. op basis van progress - 3
    
    String[] Lines = split(Lyrics, ' ');
    String returner = "";
        
    for(int i = Progress; i < Progress + 1; i++)
    {           
      if(i == Lines.length)
      {
         Progress = 0;
         //invalidate this
         Invalidated = true;
         break;
      }
      
      returner += Lines[i] + " ";          
    }
    
    return returner;
  }  
    
  public String Info()
  {
    return "Genre: " + Genres + " Evilness: " + Evilness + " Lyrics: " + Lyrics;
  }  
}
