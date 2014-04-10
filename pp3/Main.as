package  {
	import flash.events.MouseEvent;	
	import flash.events.Event;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Stage;
	import flash.display.StageScaleMode; 
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import flash.display.SimpleButton;
	
	import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;   
	import com.aem.utils.HitTest;
	
	
	
	public class Main extends MovieClip
	{
		var game_on:Boolean;
		 
		var boat_controller:BoatController;
		var navigated_boat:BoatController;
		var boat_tween_length:Number=20;  //this is the length of each boat tween
		
		var bck:Background;
		
		var all_boats:Array;
		var tween_time:Number=0.3;		
		
		//Array will contain random boats' positions and  data for their first prolonged
		//tween, with which they will enter the screen
		var boats_positions:Array; 
		
		//Timer for pushing new boats
		var boatPushTimer:Timer;	
        var boatPushTimerDelay:Number;
		
		//Points textbox and points var
		var points:TextField;
		var points_number:Number;		
		
		//docks
		var dock1:Dock1;
		var dock2:Dock2;
		var dock3:Dock3;
		var dock4:Dock4;
		var dock5:Dock5;
		var dock6:Dock6;
		
		//pause button
		var pause_btn:PauseBtn;
		var pauseOverlay:PauseOverlay;
		
		//pause variable
		var paused:Boolean=false;
		
		//have designated graphics here for each boat to draw trajectories
		var boats_trajs:Array;	
		
		//coasts
		var left_coast:LeftCoast;
		var upper_coast:UpperCoast;
		var lower_coast:LowerCoast;
		var island_coast:IslandCoast;
		
		//game over animation
		var gameOver:GameOver;
		
		public function Main()
		{   
		    var swfStage:Stage = this.stage; 
            swfStage.scaleMode = StageScaleMode.NO_SCALE; 			
			
		    //Variable for stopping the action when the collision occurs
		    game_on=true;			
			
			dock1 = (Dock1)(getChildByName("dock1_mc")); //162.35 , 70 mu je docking point
			dock2 = (Dock2)(getChildByName("dock2_mc"));
			dock3 = (Dock3)(getChildByName("dock3_mc"));
			dock4 = (Dock4)(getChildByName("dock4_mc"));
			dock5 = (Dock5)(getChildByName("dock5_mc"));
			dock6 = (Dock6)(getChildByName("dock6_mc"));			
			
			init_background();            //initialize the background
			init_left_coast();            //initialize left coast	
			init_upper_coast();           //initialize upper coast
			init_lower_coast();           //initialize lower coast	
			init_island_coast();          //initialize island in the middle
			init_docks();                 //initialize docks
			init_boats();                 //initialize boats			
			init_score();                 //initialize points	
			init_pause_system();          //initialize pause
			
			add_new_boat(null);           //Add the first boat to the scene
			boatPushTimerDelay=10;
			start_boat_push_timer(10);    //initialize timer for introducing new boats to the map 
			trace("After inits");
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp); 			
						
			addEventListener(Event.ENTER_FRAME, check_boats_collisions_and_proximites);		
						
			
		}			
		
		
		function init_background():void
		{
			//adding the background:
			//var bck:Background=new Background();
			bck=new Background();
			
			bck.x=0;
			bck.y=0;
			addChildAt(bck,0);	
			
		}
		
		//Initialize points and points text field
		function init_score():void
		{
			points=(TextField)(getChildByName("txt_points"));			
			var format1:TextFormat = new TextFormat();						
			format1.bold=true;
			format1.size=4;
			format1.color=0xFFFFFF;
			
			points_number=0;

            points.defaultTextFormat=format1;
			points.htmlText=(String)("<b>"+points_number+"</b>");								
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
			dock5.set_docking_point(562,474);
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
						
            all_boats=new Array();						
						
			
									
		}							
		
		//Checking collisions and proximities between all boats on screen
		private function check_boats_collisions_and_proximites(ev:Event):void
		{			
			//Examine boats against each other
			for each(var b1:BoatController in all_boats)
			{
			    for each(var b2:BoatController in all_boats)
			    {
			        if(b1===b2) 
					{//trace("they're the same boat");
				    }
			        else
			    	{				    
			        	//check boats' proximities
			        	if(b1.hitTestObject(b2))
			        	{
					        //Before checking, the display_alert for all boats is false
							b1.display_alert=true;
							b2.display_alert=true;						    
					    }						
				    	else
				    	{
					    	
				    	}
	   		
				    	//check boats' collisions
				    	if(HitTest.intersects(b1.boat_gra,b2.boat_gra, this))
				    	if(game_on)
	  			    	{ 				
	    			        b1.activateExplosion();
						    b2.activateExplosion();
						    game_over();
							
			   		    }							
			        }
			    }
			}
			
			//In this loop we will turn on the alert circles for all boats, if needed
			//and reset the display_alert to false, so next time, we can check again
			//and set it to true if needed
			for each(var b:BoatController in all_boats)
			{				
				if(b.display_alert) 
				{
				    b.alertCircle.visible=true;
					b.alertCircle.ContinueAnimating();
				}
				else
			    {
				    b.alertCircle.visible=false;		
					b.alertCircle.StopAnimating();					
				}				
				b.display_alert=false;
			}			
		}        	
		
		//Calculate the point of prolonged trajectory tween based on two last trajectory points
		//Coasts and docks must be avoided.
		//x1,y1 are the one before last trajectory point
		//x2,y2 are the last trajectory point
		public function calculate_prolonged_point(x1,y1,x2,y2:Number, initial:Boolean=false):Array
		{
			var p1:Point=new Point(x1,y1);
			var p2:Point=new Point(x2,y2);
			var p:Point=new Point(x2,y2);
			 
			//Make a loop here, add another tween length to the p2, check if the new point
			//overlaps any of the docks or coasts, if not, add another tween and check again.
			//If it overlaps a dock or a coast, return the existing point.
			//Make 50 checks max.
			var dx:Number=x2-x1;
			var dy:Number=y2-y1;		
			
			//This variable will adjust the dx and dy proportionally so that their hipothenusis (length
			//is equal to boat_tween_length
			var adjustment_factor:Number=boat_tween_length/Math.sqrt(Math.pow(dx,2)+Math.pow(dy,2));
			//Adjust the dx and dy
			dx=dx*adjustment_factor;
			dy=dy*adjustment_factor;
			
			
			//This var is how many times is the prolonged bigger than regular trajectory tween
			//so that we know how many times longer than regular tween should the prolonged 
			//tween last for
			var multiple:Number=0;
			
			//first two little tweens are free for an initial tween, don't count them as off screen
			var free:Number=7;
			
			for(var i:Number=0; i<50; i++)
			{  			  
			  if
			  (
			  (left_coast.hitTestPoint(p.x+dx, p.y+dy, true))||
			  (upper_coast.hitTestPoint(p.x+dx, p.y+dy, true))||
			  (island_coast.hitTestPoint(p.x+dx, p.y+dy, true))||
			  (lower_coast.hitTestPoint(p.x+dx, p.y+dy, true))||
			  (dock1.hitTestPoint(p.x+dx, p.y+dy, true))||
			  (dock2.hitTestPoint(p.x+dx, p.y+dy, true))||
			  (dock3.hitTestPoint(p.x+dx, p.y+dy, true))||
			  (dock4.hitTestPoint(p.x+dx, p.y+dy, true))||
			  (dock5.hitTestPoint(p.x+dx, p.y+dy, true))||
			  (dock6.hitTestPoint(p.x+dx, p.y+dy, true))||
			  (!initial&&((p.x-dx<0)||(p.y-dy<0)||(p.x-dx>665)||(p.y-dy>550))) //conditions for out of screen			  
			  )
			  {
				  //Dock or island is hit, or the point is out of screen
				  var went_off_screen:Boolean=false;
				  if(!initial&&((p.x-dx<0)||(p.y-dy<0)||(p.x-dx>665)||(p.y-dy>550)))				
				  went_off_screen=true;
				  trace("Multiple is: "+multiple);  
				  return [p.x,p.y,multiple, went_off_screen];
		      }
			  else
			  {
				//for a initial, decrement the free little tweens counter
				free--;
				//if free little tweens are wasted, don't count this as initial any more
				if(free==0)
				initial=false;
				
			    p.x = p.x+dx;
			    p.y = p.y+dy;  
				multiple++;
			  }
			} 
			trace("Multiple is: "+multiple);
			return [p.x, p.y, multiple, false];
			
		}
		
		public function check_point_overlaps_docks_or_coasts(p:Point)
		{
			var overlaps:Boolean=false;
		}
		
		//Erasing trajectory and setting initial (which is actually last in the array of
		//potential tweens) trajectory point and rotation for use in add_tween function
		//later
		function handleMouseDown(event:MouseEvent):void 
		{   
			var lineThickness:uint = 2; 
            var lineColor:uint = 0.5*0xffffff; 			
			
			if(navigated_boat!=null)
			{
			  navigated_boat.erase_all_trajectory_line_graphics();
			
			  navigated_boat.set_last_trajectory_point(mouseX,mouseY);
			  navigated_boat.set_one_before_last_trajectory_point(null,null);
			  navigated_boat.set_last_trajectory_rotation(navigated_boat.rotation);
			
			  stage.addEventListener(MouseEvent.MOUSE_MOVE,startDrawing);
			}
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
			if(navigated_boat==null) return;
			
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
				  //trace("Navigacija nije dozvoljena vise.");
				}
			    
				//last trajectory rotation will be set in the add_tween method
			}			
		}
		
		function handleMouseUp(event:MouseEvent):void 
		{ 
		   //trace("In handle mouseup");
  		   stage.removeEventListener(MouseEvent.MOUSE_MOVE,startDrawing); 
		   if(game_on)
		   if(navigated_boat!=null)
		   if(navigated_boat.docked_dock==null) //Check that boat is not docked
		   {
		       if(!(point_hits_docks(new Point(event.stageX,event.stageY)))&&
			      !(test_coasts_hit(new Point(event.stageX,event.stageY))))   
		       navigated_boat.append_prolonged_tween();
		     
		       navigated_boat=null;
		   }
		   else;// trace("There is a docked_dock");
		   else;// trace("navigated_boat is null");
		   else;// trace("Navigacija nije dozvoljena vise(game_on is false)");
		} 
		
		//Return true if point hits any of the shores
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
		
		//Return true if point hits any of the shores
		function test_coasts_edges_hit(p:Point):Boolean
		{
			//so far testing only for one of the coasts
			if(left_coast.hitTestPoint(p.x, p.y, true)||
			   upper_coast.hitTestPoint(p.x, p.y, true)||
			   lower_coast.hitTestPoint(p.x, p.y, true)||
			   island_coast.hitTestPoint(p.x, p.y, true)||
			   p.x<0||
			   p.y<0||
			   (p.x>665)||
			   (p.y>550)
			  )
			return true;
			else return false;		
		}
		
		//Return true if point hits any of the docks
		function point_hits_docks(p:Point):Boolean
		{
			if(dock1.hitTestPoint(p.x,p.y)||
			   dock2.hitTestPoint(p.x,p.y)||
			   dock3.hitTestPoint(p.x,p.y)||
			   dock4.hitTestPoint(p.x,p.y)||
			   dock5.hitTestPoint(p.x,p.y)||
			   dock6.hitTestPoint(p.x,p.y))
			return true;
			else return false;
		}
		
		
		//function tests collision with any dock and returns dock instance
		//which the boat colided with
		function test_docks_hit(bc:BoatController,p:Point):Dock
		{
			if(dock1.hitTestPoint(p.x,p.y))
			{
			    trace("dock1 hit");								
				bc.docked_dock=dock1;
				bc.set_unloading_cargos();	                  
				bc.docked_dock=null;
				return dock1;
			}
			else if(dock2.hitTestPoint(p.x,p.y))
			{
			    trace("dock2 hit");				
				bc.docked_dock=dock2;
				bc.set_unloading_cargos();		
				bc.docked_dock=null;
				return dock2;
			}
			else if(dock3.hitTestPoint(p.x,p.y))
			{
			    trace("dock3 hit");				
				bc.docked_dock=dock3;
				bc.set_unloading_cargos();		
				bc.docked_dock=null;
				return dock3;
			}
			else if(dock4.hitTestPoint(p.x,p.y))
			{
			    trace("dock4 hit");				
				bc.docked_dock=dock4;
				bc.set_unloading_cargos();		
				bc.docked_dock=null;
				return dock4;
			}
			else if(dock5.hitTestPoint(p.x,p.y))
			{
			    trace("dock5 hit");				
				bc.docked_dock=dock5;
				bc.set_unloading_cargos();		
				bc.docked_dock=null;
				return dock5;
			}
			else if(dock6.hitTestPoint(p.x,p.y))
			{
			    trace("dock6 hit");				
				bc.docked_dock=dock6;
				bc.set_unloading_cargos();		
				bc.docked_dock=null;
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
		
		function deleteStage(event:MouseEvent):void 
		{ 
  		   graphics.clear(); 
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
		function increment_score():void
		{
			points_number++;
			adjustBoatPushTimer();
			
		}
		
		//Adjusts the speed of boat push timer, if needed
		function adjustBoatPushTimer():void
		{
			//if(points_number%20==0)  PUT THIS AS A PRECONDITION FOR BELOW CHECK, FOR SPEEDUP OF CODE 
			//EXECUTION
			switch(points_number)
			{
			    case 20: stop_boat_push_timer(); start_boat_push_timer(9); boatPushTimerDelay=9; break;
			    case 40: stop_boat_push_timer(); start_boat_push_timer(8); boatPushTimerDelay=8; break;
			    case 60: stop_boat_push_timer(); start_boat_push_timer(7); boatPushTimerDelay=7; break;				
			    case 80: stop_boat_push_timer(); start_boat_push_timer(6); boatPushTimerDelay=6; break;
			    case 100: stop_boat_push_timer(); start_boat_push_timer(5); boatPushTimerDelay=5; break;
			    case 120: stop_boat_push_timer(); start_boat_push_timer(4); boatPushTimerDelay=4; break;
			    case 140: stop_boat_push_timer(); start_boat_push_timer(3); boatPushTimerDelay=3; break;
			    case 160: stop_boat_push_timer(); start_boat_push_timer(2); boatPushTimerDelay=2; break;
			    case 180: stop_boat_push_timer(); start_boat_push_timer(1); boatPushTimerDelay=1; break;
			    case 200: stop_boat_push_timer(); start_boat_push_timer(0.8); boatPushTimerDelay=0.8; break;
			    case 220: stop_boat_push_timer(); start_boat_push_timer(0.7); boatPushTimerDelay=0.7; break;
			    case 240: stop_boat_push_timer(); start_boat_push_timer(0.6); boatPushTimerDelay=0.6; break;
			    case 260: stop_boat_push_timer(); start_boat_push_timer(0.5); boatPushTimerDelay=0.5; break;
			}		
			
		}
		
		//Do both above
		function increment_and_refresh_points():void
		{
			increment_score();
		    refresh_points();
  			
		}
		
		//This function starts the timer for adding of new boats
		function start_boat_push_timer(t:Number):void
		{
			boatPushTimer = new Timer(t*1000);
			boatPushTimer.addEventListener(TimerEvent.TIMER, add_new_boat);			
			boatPushTimer.start();
		}
		
		//This function will stop the timer for adding new boats
		function stop_boat_push_timer():void
		{
			boatPushTimer.stop();
			boatPushTimer.removeEventListener(TimerEvent.TIMER, add_new_boat);
		}
		
		//This will generate and push new boat to the stage every so seconds
		function add_new_boat(e:TimerEvent):void
		{
			//trace("CHECKPOINT 1");						
			var new_boat:BoatController = generate_random_boat();			
			
			addChild(new_boat);        // nije bio ni na kom nivou				
			
			this.all_boats.push(new_boat);
			new_boat.append_prolonged_tween(true);		
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
			
			var pos:Number = randomNumber(1,10);
			trace("Position "+pos);
			
			var x_pos, y_pos, rotation_pos, ltr_pos:Number;
			var ltp_pos, obltp_pos:Point;
			//pos=6;
			switch(pos)
			{
				//left side positions:		
			    case 1: x_pos=-30; y_pos=550; rotation_pos=-26.6;
				        ltp_pos = new Point(-30,550);
				        obltp_pos=new Point(-50,560);break;
						
				case 2: x_pos=-30; y_pos=370; rotation_pos=12.25;
				        ltp_pos=new Point(-30,370);
				        obltp_pos=new Point(-250,310);break;
						
				case 3: x_pos=-30; y_pos=300; rotation_pos=-26.6; 
				        ltp_pos=new Point(-30,300);
				        obltp_pos=new Point(-50,310);break;
						
				case 4: x_pos=-30; y_pos=250; rotation_pos=-26.6; 
				        ltp_pos=new Point(-30,250);
				        obltp_pos=new Point(-50,260);break;							
				
				case 5: x_pos=-30; y_pos=250; rotation_pos=20;
				        ltp_pos=new Point(-30,250);
				        obltp_pos=new Point(-50,243);break;
						
				//right side positions:				
				case 6: x_pos=688; y_pos=18; rotation_pos=104.036; 
				        ltp_pos=new Point(688,18);
				        obltp_pos=new Point(690,10);break;
						
				case 7: x_pos=685; y_pos=-25; rotation_pos=101.31; 
				        ltp_pos=new Point(685,-25);
				        obltp_pos=new Point(774,-470);break;
						
				case 8: x_pos=500; y_pos=-40; rotation_pos=90;  
				        ltp_pos=new Point(500,-40);
				        obltp_pos=new Point(500,-50);break;
						
				case 9: x_pos=490; y_pos=-40; rotation_pos=116.56;  
				        ltp_pos=new Point(490,-40);
				        obltp_pos=new Point(500,-60);break;
				
				case 10:x_pos=700; y_pos=185; rotation_pos=153.4; 
				        ltp_pos=new Point(700,185);
				        obltp_pos=new Point(710,180);break;		
				
			    	 
			}		
			
			trace("x_pos: "+x_pos);
			trace("y_pos: "+y_pos);
			
			boatie.x=x_pos;
			boatie.y=y_pos;				
			boatie.rotation=rotation_pos;
			//boatie.set_last_trajectory_rotation(ltr_pos);
			boatie.set_last_trajectory_point(ltp_pos.x, ltp_pos.y);		
			boatie.set_one_before_last_trajectory_point(obltp_pos.x,obltp_pos.y);
			
			
			return boatie;
		}
		
		
		
		//Deleting the boat from stage and from the boats array
		function delete_boat(b:BoatController):void
		{
			removeChild(b);
			var new_all_boats:Array=new Array();
			for(var i:Number=0; i<all_boats.length; i++)
			{
				var b2:BoatController=all_boats[i];
				if(b2==b){}
				else new_all_boats.push(b2);
				
			}
			all_boats=new_all_boats;
			
		}
		
		function game_over()
		{
			game_on=false;
		    boatPushTimer.stop();
		    for(var i:Number=0; i<all_boats.length; i++)
		    {
			    var bo:BoatController=all_boats[i];
				bo.stop_animating();			    					
		    }
			
			gameOver=new GameOver();
			gameOver.x=310;
			gameOver.y=270;
			addChild(gameOver);			
			
			
			
			
			
		}
		
		//Register action for pause button
		function init_pause_system()
		{
			pause_btn = (PauseBtn)(bck.getChildByName("pause_btn"));
		    pause_btn.addEventListener(MouseEvent.MOUSE_DOWN, pauseUnpauseGame);
			pauseOverlay=(PauseOverlay)(getChildByName("pauseCover"));
			setChildIndex(this.pauseOverlay, numChildren-1);
			pauseOverlay.visible=false;
			
		}
		
		//Stop all boats
		function pauseUnpauseGame(event:MouseEvent)
		{			
			if (!paused)
		    {
			  stop_boat_push_timer();	
			  for(var i:Number=0; i<all_boats.length; i++)
			  {				
				var b:BoatController=all_boats[i];
			    b.stopTimeline();		
				paused=true;
			  }
			  
			  setChildIndex(this.pauseOverlay, numChildren-1);
			  pauseOverlay.visible=1;
			  pause_btn.switchToPausedText();
			}			
			else 
			{
			  start_boat_push_timer(boatPushTimerDelay);	
			  for(var i:Number=0; i<all_boats.length; i++)
			  {			    
			    var b:BoatController=all_boats[i];
			    b.startTimeline();		
			    paused=false;
			  }
			  pauseOverlay.visible=0;
			  pause_btn.switchToPauseText();
			}
			
			
			
		}

	}
	
}