using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class NewBehaviourScript : MonoBehaviour {

	LyrInMonitor Monitor;
	LyrIn Active;

	// Use this for initialization
	void Start () {
		Monitor = new LyrInMonitor();       

	}
	
	void Update () {
		
	}
}

class LyrInMonitor
{
	List<LyrIn> LyrInObjects;

	public LyrInMonitor()
	{
		LyrInObjects = new List<LyrIn>();
        string Path = "LyrInRaw/lyrout-1.txt";

		
	}


	public void Refresh()
	{
		//check of er nieuwe files zijn
	}

	public bool ReplaceActive()
	{
		return false;
	}
}