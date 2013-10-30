package  {
	import flash.events.MouseEvent;	
	import flash.events.Event;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	public class Main extends MovieClip
	{
		var game_on:Boolean;
		 
		var boat_controller:BoatController;
		var navigated_boat:BoatController;
		var boat_tween_length:Number=20;  //this is the length of each boat tween
		//var timeline:TimelineLite;
		var boat1:BoatController;
		var boat2:BoatController;
		var tween_time:Number=0.3;		
		
		//Points textbox and points var
		var points:TextField;
		var points_number:Number;
		
		//boats' trajectory movieclips
		var t1:MovieClip;
		var t2:MovieClip;
		var t3:MovieClip;
		var t4:MovieClip;
		var t5:MovieClip;
		
		//docks
		var dock1:Dock1;
		var dock2:Dock2;
		var dock3:Dock3;
		var dock4:Dock4;
		var dock5:Dock5;
		var dock6:Dock6;
		
		//have designated graphics here for each boat to draw trajectories
		var boats_trajs:Array;	
		
		//coasts
		var left_coast:LeftCoast;
		var upper_coast:UpperCoast;
		var lower_coast:LowerCoast;
		var island_coast:IslandCoast;
		
		//boats......TODO
		
		public function Main()
		{												
		    //Variable for stopping the action when the collision occurs
		    game_on=true;
			
			t1 = new MovieClip();
			t2 = new MovieClip();
			t3 = new MovieClip();
			t4 = new MovieClip();
			t5 = new MovieClip();
			
			boats_trajs=new Array();
			boats_trajs["boat1"] = t1;
			boats_trajs["boat2"] = t2;
			boats_trajs["boat3"] = t3;
			boats_trajs["boat4"] = t4;
			boats_trajs["boat5"] = t5;
			
			dock1 = (Dock1)(getChildByName("dock1_mc")); //162.35 , 70 mu je docking point
			dock2 = (Dock2)(getChildByName("dock2_mc"));
			dock3 = (Dock3)(getChildByName("dock3_mc"));
			dock4 = (Dock4)(getChildByName("dock4_mc"));
			dock5 = (Dock5)(getChildByName("dock5_mc"));
			dock6 = (Dock6)(getChildByName("dock6_mc"));			
			
			init_background();     //initialize the background
			init_left_coast();     //initialize left coast	
			init_upper_coast();    //initialize upper coast
			init_lower_coast();    //initialize lower coast	
			init_island_coast();      //initialize island in the middle
			init_docks();          //initialize docks
			init_boats();          //initialize boats
			init_points();         //initialize points	
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp); 		
			
			//timeline=new TimelineLite();	
			
			addEventListener(Event.ENTER_FRAME, checkCollisionsAndProximites);
		}		
		
		function init_background():void
		{
			//adding the background:
			var bck:Background=new Background();
			bck.x=0;
			bck.y=0;
			addChildAt(bck,0);	
			
		}
		
		//Initialize points and points text field
		function init_points():void
		{
			points=(TextField)(getChildByName("txt_points"));			
			var format1:TextFormat = new TextFormat();						
			format1.bold=true;
			format1.size=4;
			format1.color=0xFFFFFF;
			
			points_number=0;

            points.defaultTextFormat=format1;
			points.htmlText=(String)("<b>"+points_number+"</b>");			
			trace("BOLD OR NOT "+format1.bold);			
		}
		
		//Initialize left coast on screen
		private function init_left_coast():void
		{
			 left_coast = new LeftCoast();
			 left_coast.x = 67;
			 left_coast.y = 102.65;
			 addChild(left_coast);		
			 setChildIndex(left_coast,1);
		}
		
		//Initialize upper coast on screen
		private function init_upper_coast():void
		{
			 upper_coast = new UpperCoast();
			 upper_coast.x = 262;
			 upper_coast.y = 23;
			 addChild(upper_coast);		
			 setChildIndex(upper_coast,1);
		}
		
		//Initialize lower coast on screen
		private function init_lower_coast():void
		{
			 lower_coast = new LowerCoast();
			 lower_coast.x = 585;
			 lower_coast.y = 452;
			 addChild(lower_coast);		
			 setChildIndex(lower_coast,1);
		}
		
		//Initialize island
		private function init_island_coast():void
		{
			island_coast = (IslandCoast)(getChildByName("island_mc"));
			
			
		}
		
		//Initialize docks on screen
		private function init_docks():void
		{
			//Setting docking/docked points and unloading/unloaded rotations for
			//ships that dock onto each dock
			
			//setting for dock1
			dock1.set_docking_point(162.35,90);
			dock1.set_docked_point(162.35,70);
			dock1.set_unloading_boat_rotation(-90);
			dock1.set_unloaded_boat_rotation(90);
			
			//setting for dock2
			dock2.set_docking_point(227.85,90);
			dock2.set_docked_point(227.85,70);
			dock2.set_unloading_boat_rotation(-90);
			dock2.set_unloaded_boat_rotation(90);
			
			//setting for dock3
			dock3.set_docking_point(219,258);
			dock3.set_docked_point(243,283);
			dock3.set_unloading_boat_rotation(45);
			dock3.set_unloaded_boat_rotation(225);
			
			//setting for dock4
			dock4.set_docking_point(388,255);
			dock4.set_docked_point(370,274);
			dock4.set_unloading_boat_rotation(135);
			dock4.set_unloaded_boat_rotation(-45);
			
			//setting for dock5
			dock5.set_docking_point(564,476);
			dock5.set_docked_point(572,484);
			dock5.set_unloading_boat_rotation(45);
			dock5.set_unloaded_boat_rotation(225);
			
			//setting for dock6
			dock6.set_docking_point(605,432);
			dock6.set_docked_point(615,442);	
			dock6.set_unloading_boat_rotation(45);
			dock6.set_unloaded_boat_rotation(225);
			
			
		}				
		
		//Initialize boats on screen
		function init_boats():void
		{
			//trace("test distance fje ,treba 5 da bude, ne 25: " + pp_maths.distance(new Point(0,0),new Point(3,4)));
			
			//setting up the trajectory graphics
			addChildAt(t1,1);
			addChildAt(t2,1);	
			
			//Setting up two test boats
			boat1 = generate_random_boat();					
			addChildAt(boat1,  numChildren );         // bio na nivou 2			
			boat1.x=150;			
			boat1.y=150;				
			boat1.set_last_trajectory_point(150,150);					
			
			boat2 = generate_random_boat();
			addChildAt(boat2, numChildren  );        // nije bio ni na kom nivou
			boat2.x=250;
			boat2.y=250;	
			boat2.set_last_trajectory_point(250,250);						
		}							
		
		//Checking collisions and proximities between all boats on screen
		private function checkCollisionsAndProximites(ev:Event):void
		{
			//var newColorTransform:ColorTransform;
			//check boats' proximities
			if(boat1.hitTestObject(boat2))
			{
				//trace("they are near colison");
				boat1.alertCircle.visible=true;
				boat2.alertCircle.visible=true;				
			}						
			else
			{
				boat1.alertCircle.visible = false;
				boat2.alertCircle.visible = false;				
			}
	   		
			//check boats' collisions
			if(boat1.boat_gra.hitTestObject(boat2.boat_gra))
			if(game_on)
	  		{				
				boat1.activateExplosion();
				boat2.activateExplosion();
				
				game_on=false;
	   		}							
			
		}	
		
		//Erasing trajectory and setting initial (which is actually last in the array of
		//potential tweens) trajectory point and rotation for use in add_tween function
		//later
		function handleMouseDown(event:MouseEvent):void 
		{   
			var lineThickness:uint = 2; 
            var lineColor:uint = 0.5*0xffffff; 			
			
			navigated_boat.erase_all_trajectory_line_graphics();
			
			navigated_boat.set_last_trajectory_point(mouseX,mouseY);
			navigated_boat.set_one_before_last_trajectory_point(null,null);
			navigated_boat.set_last_trajectory_rotation(navigated_boat.rotation);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,startDrawing);
		}
		
		public function erase_trajectory_for_navigated_boat():void 
		{   		
		    navigated_boat.erase_all_trajectory_line_graphics();
		    return;		    
			
		}
		

        //From here we propagate event to the boat and have it add appropriate tween(s)
		function startDrawing(event:MouseEvent):void 
		{   			
		    //Don't allow navigation if boats already colided and game is already over
			if(!game_on) return;
			
			var cur:Point = navigated_boat.get_last_trajectory_point();  //last traj. point mc-a
			var newp:Point = new Point(stage.mouseX,stage.mouseY);  //
			var pot:Point = new Point();
			
			var d:Number = pp_maths.distance(cur,newp)
			var dx:Number = Math.abs(newp.x-cur.x)*(boat_tween_length)/d;
			var dy:Number = Math.abs(newp.y-cur.y)*(boat_tween_length)/d;
						
			//the additional condition (2*boat_tween_length...) is because of stopping the
			//boat from tweening too long (it is a bug, happens sometimes ;))
			if ((pp_maths.distance(cur, newp) > boat_tween_length ) &&
				(pp_maths.distance(cur, newp) < (2*boat_tween_length)))
			{
				// odrediti tacku kao krajnju za tween koja ce biti na epsilon distanci
				// od trenutne krajnje tacke a u smeru ka potential_end tachki.
				if (newp.x>cur.x) pot.x = cur.x+dx;
				if (newp.x<cur.x) pot.x = cur.x-dx;
				if (newp.y>cur.y) pot.y = cur.y+dy;
				if (newp.y<cur.y) pot.y = cur.y-dy;				    
				
			    //trace("sad ce da se doda tween");
				if(navigated_boat.ready_for_navigation)
				{
				  navigated_boat.add_tween(tween_time,pot.x,pot.y);				
				}
				else
				{
				  trace("Navigacija nije dozvoljena vise.");
				}
			    
				//last trajectory rotation will be set in the add_tween method
			}		   
		   
		   
		}
		
		function handleMouseUp(event:MouseEvent):void 
		{ 
  		   stage.removeEventListener(MouseEvent.MOUSE_MOVE,startDrawing); 
		   if(game_on)
		   navigated_boat.appendProlongedTween();
		   else trace("Navigacija nije dozvoljena vise.");
		   navigated_boat=null;
		   //trace("mouse is upped");
		} 
		
		function test_coasts_hit(p:Point):Boolean
		{
			//so far testing only for one of the coasts
			if(left_coast.hitTestPoint(p.x, p.y, true)||
			   upper_coast.hitTestPoint(p.x, p.y, true)||
			   lower_coast.hitTestPoint(p.x, p.y, true)||
			   island_coast.hitTestPoint(p.x, p.y, true))
			return true;
			else return false;		
			
		}		
		
		//function test collision with any dock and returns dock instance
		//which the boat colided with
		function test_docks_hit(bc:BoatController,p:Point):Dock
		{
			if(dock1.hitTestPoint(p.x,p.y))
			{
				bc.docked_dock=dock1;
				bc.set_unloading_cargos();		
				return dock1;
				   
			}
			else if(dock2.hitTestPoint(p.x,p.y))
			{
				bc.docked_dock=dock2;
				bc.set_unloading_cargos();		
				return dock1;
				   
			}
			else if(dock3.hitTestPoint(p.x,p.y))
			{
				bc.docked_dock=dock3;
				bc.set_unloading_cargos();		
				return dock3;
				
			}
			else if(dock4.hitTestPoint(p.x,p.y))
			{
				bc.docked_dock=dock4;
				bc.set_unloading_cargos();		
				return dock4;
				
			}
			else if(dock5.hitTestPoint(p.x,p.y))
			{
				bc.docked_dock=dock5;
				bc.set_unloading_cargos();		
				return dock5;
				
			}
			else if(dock6.hitTestPoint(p.x,p.y))
			{
				bc.docked_dock=dock6;
				bc.set_unloading_cargos();		
				return dock6;
				
			}
			else return null;
		}
		
		//Draw a trajectory segment using the given line
		function draw_trajectory_line(t:MovieClip, x1, y1, x2, y2:Number):void
		{
			
			addChildAt(t,1);
			var lineThickness:uint = 2; 
            var lineColor:uint = 0.5*0xffffff; 			
			
		    t.graphics.clear();
		    t.graphics.lineStyle(lineThickness,lineColor); 
  			t.graphics.moveTo(x1,y1); 	
		    t.graphics.lineTo(x2,y2);   //trace("t1 drawn");					
			
			
		}		
		
		//Delete one trajectory line segment
		function delete_trajectory_segment_line(t:MovieClip):void
		{
			trace("delete_trajectory_segment_line");
			trace(t);
		    t.graphics.clear();
		    
		}		

		function deleteStage(event:MouseEvent):void 
		{ 
  		   graphics.clear(); 
		}   

        //this function returns a boat with random length and cargo on it
        function generate_random_boat():BoatController
		{
			var len:Number = randomNumber(2,4);
			var boatie:BoatController;
			
			//let's generate new boat's cargos colors array
			var colors:Array=new Array();
			
			for(var i:Number=0 ; i<len ; i++)
			{
				//color is either 0 or 1, let's return a random value here
				var ccolor:Number = randomNumber(0,1);				
				colors[i]=ccolor;				
			}
			
			if(len==2)
			{
			  boatie = new Yacht(this, colors);		
			}
			else if(len==3)
			{
			  boatie = new Ferry(this, colors);		
			}
			else if(len==4)
			{
			  boatie = new Cruiser(this, colors);		
			}			
			
			return boatie;					
		}
		
		function randomNumber(low:Number=0, high:Number=1):Number
        {
           return Math.floor(Math.random() * (1+high-low)) + low;
        }
		
		//Refresh points on screen
		function refresh_points():void
		{
			points.htmlText=(String)("<b>"+points_number+"</b>");			
		}
		
		//Increment points variable
		function increment_points():void
		{
			points_number++;
		}
		
		//Do both above
		function increment_and_refresh_points():void
		{
			increment_points();
			refresh_points();
			
		}

	}
	
}