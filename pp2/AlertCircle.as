package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;	
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	//import flash.events.MouseEvent;
	import flash.events.Event;
	//import flash.geom.Point;
	
	public class AlertCircle extends MovieClip 
	{	
	    var timeline:TimelineLite; 
		public function AlertCircle() 
		{
			timeline = new TimelineLite();
			// constructor code					
			AnimateCircle();
		}
		
		public function AnimateCircle()
		{						
			for(var i:Number=0;i<1000;i++)
			{
			  timeline.append(new TweenLite(this,0.5,{scaleX:1.5, 
										              scaleY:1.5, 												   
												      ease:Linear.easeNone} ));	
												  
			  timeline.append(new TweenLite(this,0.5,{scaleX:1, 
										              scaleY:1, 												   
												      ease:Linear.easeNone} ));
			} 
			
			timeline.play();
		}		
	}	
}
