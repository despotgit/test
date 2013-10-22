package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Dock extends MovieClip
	{
		const RED:Number=0;
		const YELLOW:Number=1;
		
		var docking_point:Point;
		var docked_point:Point;
		var docked_boat:BoatController; //in case there is one
		var dock_color:Number; //0-red , 1-yellow
		
		var unloading_boat_rotation:Number;   //rotation for the boat when it is unloading
		var unloaded_boat_rotation:Number;    //rotation for the boat when it is unloaded
		

		public function Dock() 
		{
			// constructor code
		}		
		
		public function set_docking_point(parx:Number,pary:Number):void
		{
			docking_point = new Point(parx,pary);			
			
		}
		
		public function get_docking_point():Point
		{
			return docking_point;
			
		}
		
		public function set_docked_point(parx:Number,pary:Number):void
		{
			docked_point = new Point(parx,pary);
			
			
		}
		
		public function get_docked_point():Point
		{
			return docked_point;
			
		}
		
		public function set_docked_boat(b:BoatController):void
		{
			docked_boat=b;			
			
		}
		
		public function get_docked_boat():BoatController
		{
			return docked_boat;		
			
			
		}
		
		public function get_unloading_boat_rotation():Number
		{
			return unloading_boat_rotation;
			
		}
		
		public function set_unloading_boat_rotation(par:Number):void
		{
			unloading_boat_rotation=par;
			
		}	
		
		public function get_unloaded_boat_rotation():Number
		{
			return unloaded_boat_rotation;
			
		}
		
		public function set_unloaded_boat_rotation(par:Number):void
		{
			unloaded_boat_rotation=par;
			
			
		}	

	}	
}