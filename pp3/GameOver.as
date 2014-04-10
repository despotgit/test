package  {
	
	import flash.display.MovieClip;
	
	
	public class GameOver extends MovieClip 
	{		
	    var main:MovieClip;
		
		public function GameOver(main_par:MovieClip) 
		{
			main=main_par;
			// constructor code		
		}
		
		public function pushMainTo3()
		{
			main.gotoAndPlay(3);
		}
		
		
		
		
	}
	
}
