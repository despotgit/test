package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;	
	
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
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
			
		}
		
		public function AnimateCircle()
		{						
			
			timeline.append(new TweenLite(this,0.5,{scaleX:1.5, 
										            scaleY:1.5, 												   
												    ease:Linear.easeNone,
													onComplete:AddShrinkTween} ));	
			timeline.play();
		}		
		
		public function StopAnimating()
		{
			timeline.stop();
		}
		
		public function ContinueAnimating()
		{
			timeline.play();
		}
		
		public function AddEnlargeTween()
		{
		    timeline.append(new TweenLite(this,0.5,{scaleX:1.5, 
										              scaleY:1.5, 												   
												      ease:Linear.easeNone,
													  onComplete:AddShrinkTween} ));	
		}
		
		public function AddShrinkTween()
		{
		    timeline.append(new TweenLite(this,0.5,{scaleX:1, 
										              scaleY:1, 												   
												      ease:Linear.easeNone,
													  onComplete:AddEnlargeTween} ));
		}
	}	
}
