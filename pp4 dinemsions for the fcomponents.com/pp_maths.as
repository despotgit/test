package  {
	import flash.geom.*
	
	public class pp_maths {

		public function pp_maths() {
			// constructor code
		}
		
		public static function distance(point1:Point, point2:Point ):Number
        {
            var tempNr:Number = Math.sqrt(Math.pow((point2.x - point1.x), 2) + Math.pow((point2.y - point1.y),2));
            return Math.abs(tempNr)
        }  
		
		//following function is returning the rotation by which entity has to be rotated BY
		//in order to get from position a to position b in the quicker direction
		public static function find_transitional_rotation(a:Number,b:Number):Number
		{
			var sv:Number;
			
			//normalize a and b values
			while(a>360) a-=360;
			while(a<0) a+=360;
			
			while(b>360) b-=360;
			while(b<0) b+=360;
			
			
		   if(a>b)
		   {
			   if((a-b)<180)
			   {
				   sv=b-a;				   
			   }
			   else
			   {
				   sv=360+b-a;
			   }	   
		   }
		   
		   if(a<=b)
		   {
			   if((b-a)<180)
			   {
				   sv=b-a;
				   
			   }
			   else
			   {				   
				   sv=b-a-360;
			   }	   
		   }
		   return sv;
			
			
		}
		
		
		
		
	}
}