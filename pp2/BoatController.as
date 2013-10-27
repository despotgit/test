package  {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;	
	
	//Classes for explosion
	import com.freeactionscript.effects.explosion.LargeExplosion;
	import com.freeactionscript.effects.explosion.MediumExplosion;
	import com.freeactionscript.effects.explosion.SmallExplosion;
	
	import flash.utils.Timer;
	
	
	public class BoatController extends MovieClip   
	{ 
	    
		var boat_gra:MovieClip;
		
	    const RED:Number=0;
		const YELLOW:Number=1;
		
	    var red_cargo:Number;
		var yellow_cargo:Number;
		
		var red_cargos:Array;     //actual objects
		var yellow_cargos:Array;   //actual objects
		
		var boat_length:Number;
		
		var cargo1_color:Number;  //0 is red, 1 is yellow
		var cargo2_color:Number;
		var cargo3_color:Number;
		var cargo4_color:Number;
		
		var cargo1:Cargo; //specific movieclips for each cargo
		var cargo2:Cargo;
		var cargo3:Cargo;
		var cargo4:Cargo;
		
		var all_cargos:Array;   //all cargos colors as numbers
		
        var motion_route:Array=new Array(); 
		var timeline:TimelineLite;      
		var last_trajectory_point:Point;
		var last_trajectory_rotation:Number;
		
		var docked_dock:Dock;
		
		var tween_time:Number=2;
		var game:Main;
        var ready_for_new_path:Boolean;   //indicator if the mouse is up and the boat still has a 
		                                  //motion tween path attached, so it is to be deleted 
										  //upon next mouse drag, and last_motion_point set to new point.
		
		var unloading_cargos:Array;
		var alertCircle:AlertCircle = new AlertCircle();
		
		public var ready_for_navigation:Boolean;
		
		//vars for explosion
		private var explosion_timer:Timer;		
		private var medium_explosion:MediumExplosion;	
		
		public function BoatController():void
		{
			init_boat();
		}
		
		function handleMouseDown(event:MouseEvent):void 
		{
			//trace("mouse koordi iz boatcontrollera su:"  + stage.mouseX + " i " + stage.mouseY);
			//trace("boat controller's handleMouseDown metod accessed");
			//tell the game controller that this is the currently navigated boat
			this.game.navigated_boat=this;			
			graphics.clear();
			
			set_ready_for_new_path(true);
			
			if(get_ready_for_navigation())
			{
			    wipe_whole_motion_path();
			}
		}
		
		public function init_boat():void
		{			
			trace("boat controller instanciran");
			this.addChild(alertCircle);
			this.alertCircle.x = -0.1;
			this.alertCircle.y = -0.1;
			this.alertCircle.visible = false;
			
		}
		
		public function activateExplosion():void
		{
			//set listener for the explosion
			this.addEventListener(Event.ENTER_FRAME, enterFrameExplosionHandler);
			
			//set the explosion initially
			medium_explosion = new MediumExplosion(this);			
			medium_explosion.create(0,0);
			
		}
		
		private function enterFrameExplosionHandler(event:Event):void
		{
			// update the explosion instance every frame			
			medium_explosion.update();		
		}
		
		public function get_last_trajectory_rotation():Number
		{
			return this.last_trajectory_rotation;		
		}
		
		public function set_last_trajectory_rotation(par:Number):void
		{
			last_trajectory_rotation = par;		
		}
		
		public function get_last_trajectory_point():Point
		{
			return this.last_trajectory_point;		
		}
		
		public function set_last_trajectory_point(x_par:Number,y_par:Number):void
		{
			this.last_trajectory_point = new Point(x_par,y_par);
			//trace("Last traj. point of this boat set to: "+x_par+" , "+y_par);
		}
		
		public function set_ready_for_new_path(par:Boolean):void
		{
			ready_for_new_path=par;
		}
		
		public function get_ready_for_new_path():Boolean
		{
			return  ready_for_new_path;
		}
		
		public function add_tween(time:Number, par_x:Number, par_y:Number):void
		{
		   //let's calculate sine of the angle for which this boat is to be rotated by
		   //there are off course, 4 situations:
		   //------------------------------>X
		   //I  setting of the rotation is clockwise....
		   //I
		   //I     X1,Y1 (1)              X2,Y2 (2) 
		   //I       
		   //I     
		   //I                  X0,Y0   
		   //I
		   //I      
		   //I     X3,Y3 (3)              X4,Y4 (4)
		   //I
		   //I   (1)  180+angle=180+asin(|dy|/d)
		   //I        sine=|dy|/d
		   //I   (2)   
		   //I
		   //I
		   //I   a) imamo novi ugao u kom treba da stoji brodic Lnovo
		   //I   b) imamo diferencijal za koji treba da se rotira, to nam je bitno, ovo ide za tween
		   //I      =Lnovo-rotation
		   //I   c) 
		   //I
		   //I
		   //I
		   //I   L1=taj mali uglic izmedju hipotenuze i x-ose
		   //I
		   //I
		   //I
		   //I
		   //V
		   //Y
		   //
		   //
		   //
		   //
		   //
		   //
		   
		   //the hypothenusis is:
		   var distance:Number = pp_maths.distance(get_last_trajectory_point(), new Point(par_x,par_y) );
		   
		   var curr_angle:Number = rotation;
		   
		   var X0:Number = get_last_trajectory_point().x;
		   var Y0:Number = get_last_trajectory_point().y;
		   
		   var X1:Number = par_x;
		   var Y1:Number = par_y;
		   
		   var L1 = (1/Math.PI)*180*Math.asin(Math.abs(Y0-Y1)/distance)
		   
		   var has_to_be_rotated_to:Number;
		   
		   //slucaj 1
		   if(X1<X0 && Y1<Y0)
		   {
		     has_to_be_rotated_to = 180+L1;//-curr_angle;		
			 
			 //trace("slucaj 1");
		   }
		   
		   //slucaj 2
		   if(X1>X0 && Y1<Y0)
		   {
		     has_to_be_rotated_to = 360-L1;//-curr_angle;		   
			 //trace("slucaj 2");
		   }
		   
		   //slucaj 3
		   if(X1<X0 && Y1>Y0)
		   {
		     has_to_be_rotated_to = 180-L1;//-curr_angle;		   
			 //trace("slucaj 3");
		   }
		   
		   //slucaj 4
		   if(X1>X0 && Y1>Y0)
		   {
		     has_to_be_rotated_to = L1;//-curr_angle;		   
			 //trace("slucaj 4");
		   }
		   
		   //trace("boat's rotation is: " + rotation);
		   //has_to_be_rotated je broj izmedju 0 i 360 cisto da znamo
		   
		   //preslikana matematika sa papira:
		   
		   var a:Number = get_last_trajectory_rotation();  //changes from - to + infinity
		   //trace("ltr je: "+a);
		   
		   //let's normalize the current rotation to be between 0 and 360, put this into "a"
		   while(a<0) a+=360;
		   while(a>360) a-=360;
		   
		   var b:Number = has_to_be_rotated_to;
		   
		   var sv:Number; //ovo je prosto broj ZA koji treba da se rotiramo,ali u smeru
		                  //koji se u narednim linijama odredjuje.
		   
		   //a - (0,360) angle that we are currently in
		   //b - (0,360) angle that we need to get to
		   
		   //taking this into consideration , let's determine by how much (sv) we need
		   //to rotate the boat by. The positive value is clockwise direction, and vice versa.
		   
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
		   
		   
		   var svs:String = sv.toString();
		     
		   //trace("sv je: " + sv);
		   
		   //Next "if" is because it sometimes happens that tween is too long(from the edge of
		   //the screen to some point.....
		   if(pp_maths.distance(get_last_trajectory_point(), new Point(par_x,par_y) ) < (2*game.boat_tween_length))
		   {
			   //if we haven't hit a coast...... 
			   if(!game.test_coasts_hit(new Point(par_x,par_y)))
			   {
				   //test here if we hitted a dock, in which case adding special tweens for docking and unloading
				   //which will be named specially, so we can later -upon new mouse click on the boat and new 
				   //trajectory point creation- remove those tweens that are  unnecessary.
				   //those tweens can be named for example docking_tweens and unloading_tweens
                   if(game.test_docks_hit(this,new Point(par_x,par_y))!=null)
				   {
					   //SECI OVDE AKO NEMA NISTA ZA ISTOVAR!!!!!!!!!!!!!!!!
					   if(get_unloading_cargos().length!=0)
					   {
						 trace ("Number of unloading cargos is: "+ get_unloading_cargos().length); 
					     disable_navigation();
					     erase_trajectory_line();
					   
					     //so we have actually hit a dock, add special tweens
					     //for docking......
					     //trace("DOKS HIT!!!!!!!!!!!!!!!!!!!!!!!!!!");
					   
					     //calculate additional(transitional) rotations for docking
					     //and docked position of the boat to the dock (well second
					     //of these is zero, since the rotation is the same in the
					     //docking and docked position
					   
					     var docking_trans_rotation:Number=pp_maths.find_transitional_rotation(get_last_trajectory_rotation(),docked_dock.get_unloading_boat_rotation());
					   
					     //this tween is getting the boat to the docking point
					     timeline.append(     new TweenLite(this , 
												    time ,												    
												    {x:docked_dock.docking_point.x, 
		   						                     y:docked_dock.docking_point.y, 
													 rotation:svs ,
		                                     		 ease:Linear.easeNone}													 
													 ) );
													 
													 
                         //this tween is getting the boat to the docked point													 
		                 timeline.append(     new TweenLite(this , 
												    (time*2) ,												    
												    {x:docked_dock.docked_point.x, 
		   						                     y:docked_dock.docked_point.y, 
													 rotation:docked_dock.get_unloading_boat_rotation(),//has to be decided based on current rotation and dock
		                                     		 ease:Linear.easeNone}													 
													 ) );
													 
													
													 
													 
					     //TO DO add tweens for unloading the cargos...(cargos fading tweens)
					     //1 - yellow cargo
					     //0 - red cargo
					     for(var i:Number=0 ; i<unloading_cargos.length ; i++)
					     {
						   timeline.append(     new TweenLite(unloading_cargos[i] , 
												    2 ,												    
												    { 
													 alpha:0,													 
		                                     		 ease:Linear.easeNone,
													 onComplete:game.increment_and_refresh_points}													 
													 ) );	
						   
						   
					     }
					   
					     //fake tween after which we orientate the ship to be ready for sailing off
					     //and enable navigation again
					     trace("setting the unloaded ship rot to "+docked_dock.get_unloaded_boat_rotation());
					     timeline.append(new TweenLite(this , 
												    0.001 ,												    
												    { 			
													 rotation:docked_dock.get_unloaded_boat_rotation(), 
		                                     		 ease:Linear.easeNone,
													 onComplete:enable_navigation
													 }													 
													 ) );	

					   					   
					   }
					   else
					   {
						   trace("no cargos for unloading");						   
					   }
													 
		               //trace("DOKS HIT!!!!!!!!!!!PASSED!!!!!!!!!!!");		   
				   }
				   else  //regular trajectory segment
				   {
				     //trace("CHECK!");
					 //TO DO: Insert a onComplete here to wipe the last trajectory segment
					 //from the navigated boat
		             timeline.append(     new TweenLite(this , 
					  							    time/20*game.boat_tween_length ,												    
					 							    {x:par_x, 
		   			 			                     y:par_y, 
					 								 rotation:svs ,
		                                     		 ease:Linear.easeNone}													 
				     									 ) );
					  
					 //Next we will add a tween for prolonged movement of boat, after manual
					 //navigation has been done
					 timeline.append(     new TweenLite(this , 
					  							    time/20*game.boat_tween_length ,												    
					 							    {x:par_x, 
		   			 			                     y:par_y, 
					 								 rotation:svs ,
		                                     		 ease:Linear.easeNone}													 
				     									 ) );
					 
					  
				   }
			       set_last_trajectory_point(par_x, par_y);	
				   game.draw_trajectory_segment(par_x, par_y);
				   
			   }
			   else  //(if we HAVE hit a coast)
			   {
				   //prekinuti putanju (kao da je dugme misa pusteno)
				   game.handleMouseUp(null);
				   
			   }
				//test_docks_hit(par_x,par_y);
				
		   }
	       
		   //trace("This boat's timeline played-from BoatController");
		   timeline.play(); 
		   // trace("is timeline active: "+timeline.active);
		   timeline.play(); 
		   
		   set_last_trajectory_rotation(get_last_trajectory_rotation()+sv);
			
		}
		
		private function set_sail():void
		{
			rotation=90;
			enable_navigation();
		}
		
		private function test_docks_hit(par_x,par_y):void
		{
			    var _point:Point = new Point(par_x,par_y);
	
	            
	            if(game.dock3.hitTestPoint(_point.x, _point.y, true))
                {
	               trace("IPSA!!! TEST NA HIT DOKA3 USPEO");
                }			
		}
		
		public function check_potential_trajectory_end(par_x:Number,par_y:Number):void
		{
			
			
		}		
		
		public function append_motion_point(x:Number,y:Number):void
		{
			this.motion_route.push(new Array(x,y));
			
		}
		
		public function append_next_tween():void
		{			
			
		}		
		
		public function wipe_whole_motion_path():void
		{
			timeline.killTweensOf(this,true);
			timeline.killTweensOf(timeline,true);
			timeline.clear();
			timeline.play();
			timeline=new TimelineLite();
			timeline.play();
			
			
		}
		
		//Delete the trajectory line in the BoatController
		public function erase_trajectory_line():void
		{
			
			game.erase_trajectory_for_navigated_boat();
			
			
		}
		
		public function get_unloading_cargos():Array
		{
			return unloading_cargos;
		}
		
		public function set_unloading_cargos():void
		{
			if (docked_dock.dock_color==RED) unloading_cargos = red_cargos; 
			else unloading_cargos = yellow_cargos;
		}		
		
		private function enable_navigation():void
		{
			trace("nav enabled");
			ready_for_navigation=true;
		}
		
		private function disable_navigation():void
		{
			ready_for_navigation=false;
		}
		
		private function get_ready_for_navigation():Boolean
		{
			return ready_for_navigation;			
		}

	}
	
}
