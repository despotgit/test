/**
 * Dynamic Animated Explosion
 * ---------------------
 * VERSION: 1.0
 * DATE: 8/22/2011
 * AS3
 * UPDATES AND DOCUMENTATION AT: http://www.FreeActionScript.com
 **/
package  
{
	import com.freeactionscript.effects.explosion.LargeExplosion;
	import com.freeactionscript.effects.explosion.MediumExplosion;
	import com.freeactionscript.effects.explosion.SmallExplosion;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	//import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Main extends MovieClip
	{
		// vars
		private var _timer:Timer;		
		private var _mediumExplosion:MediumExplosion;	
		
		/**
		 * Document Class
		 */
		public function Main() 
		{
			// add basic listeners; enter frame, mouse down, mouse up
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);					
			
			_mediumExplosion = new MediumExplosion(this);			
		}
		
		//////////////////////////////////////
		// Event Handlers
		//////////////////////////////////////
		
		/**
		 * Enter Frame handler
		 * @param	event	Uses Event
		 */
		private function enterFrameHandler(event:Event):void
		{
			// update the explosion instance every frame			
			_mediumExplosion.update();		
		}
		
		/**
		 * Mouse Down handler
		 * @param	e	Uses MouseEvent
		 */
		private function onMouseDownHandler(event:MouseEvent):void 
		{
			// create an explosion at mouse X & Y
			//_smallExplosion.create(stage.mouseX, stage.mouseY)
			_mediumExplosion.create(stage.mouseX, stage.mouseY)
			//_largeExplosion.create(stage.mouseX, stage.mouseY)
		}
		
		
	}
}