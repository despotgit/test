package  {
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;	
	import flash.events.Event;
	import flash.display.MovieClip;
	
	
	public class PauseBtn extends MovieClip {
		
		var pauseButtonTextVar:PauseButtonText;
		var pausedButtonTextVar:PausedButtonText;
		
		public function PauseBtn() 
		{
		    //pauseButtonTextVar=(PauseButtonText)(getChildByName("pauseButtonText"));
			//pausedButtonTextVar=(PausedButtonText)(getChildByName("pausedButtonText"));
		    gotoAndPlay(2);    	
		   
		}
		
		public function switchToPausedText()
		{
		    gotoAndPlay(1);
		}
		
		public function switchToPauseText()
		{
		    gotoAndPlay(2);    	
		}
		
		
	}
	
}
