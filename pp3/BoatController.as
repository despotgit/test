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
	import flash.display.Graphics;
	import fl.transitions.Tween;
	
	
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
		
		//This is the current prolonged motion that occurs when all the motion tweens
		//for the boat are played out
		var prolonged_tween:TweenLite;  
		
		//Timeline for the boat
		var timeline:TimelineLite;  
		
		//These two Points serve for calculating the prolonged trajectory tween
		var last_trajectory_point:Point;
		var one_before_last_trajectory_point:Point;		
		
		var last_trajectory_rotation:Number;
		var last_trajectory_tween_segment:TweenLite;
		
		//Graphic lines for the trajectory
		var trajectory_line_segments:Array;
		
		//Array of tweens and their associated indices
		var trajectoryLines_indices:Array=new Array();
		
		//Current index of the trajectory array
		var currentTrajectoryIndex:Number=-1;
		
		//Index of earliest tween for which to erase the trajectory line
		var earliest_line_index:Number=0;
		
		//Dock that the boat is docked on, if any
		var docked_dock:Dock;
		
		var tween_time:Number=2;
		var game:Main;
        var ready_for_new_path:Boolean;   //indicator if the mouse is up and the boat still has a 
		                                  //motion tween path attached, so it is to be deleted 
										  //upon next mouse drag, and last_motion_point set to new point.
		
		var unloading_cargos:Array;
		var alertCircle:AlertCircle;
		
		//indicator whether the alert circle should be displayed or not
		var display_alert:Boolean;
		
		public var ready_for_navigation:Boolean;
		
		//vars for explosion
		private var explosion_timer:Timer;		
		private var medium_explosion:MediumExplosion;	
		
		public function BoatController():void
		{
			init_boat();
		}
		
		public function init_boat():void
		{						
		    timeline=new TimelineLite();
			alertCircle=new AlertCircle();
			this.addChild(alertCircle);
			this.alertCircle.x = 0;//-0.1;
			this.alertCircle.y = 0;//-0.1;
			this.alertCircle.visible = false;
			this.display_alert=false;
			alertCircle.AnimateCircle();
			alertCircle.StopAnimating();
			
			//not needed here actually: timeline.play();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown); 			
			
		}		
		
		function handleMouseDown(event:MouseEvent):void 
		{
			//trace("mouse koordi iz boatcontrollera su:"  + stage.mouseX + " i " + stage.mouseY);
			//trace("boat controller's handleMouseDown metod accessed");
			//tell the game controller that this is the currently navigated boat
			game.navigated_boat=this;					
			
			graphics.clear();
			
			set_ready_for_new_path(true);
			
			if(get_ready_for_navigation())
			{
			    wipe_whole_motion_path();
			}
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
			   if(!game.test_coasts_edges_hit(new Point(par_x,par_y)))
			   {
				   //Test here if we hitted a dock, in which case adding special tweens for docking and unloading
				   //which will be named specially, so we can later -upon new mouse click on the boat and new 
				   //trajectory point creation- remove those tweens that are  unnecessary.
				   //those tweens can be named for example docking_tweens and unloading_tweens
                   var potential_docked_dock:Dock=game.test_docks_hit(this,new Point(par_x,par_y));
				   if(potential_docked_dock!=null)
				   {
					   //SECI OVDE AKO NEMA NISTA ZA ISTOVAR
					   //Ako ima, dock the boat! :)
				   	   if(get_unloading_cargos().length!=0)
					   {						
					       docked_dock=potential_docked_dock;
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
						   //trace("Adding tween for preparing to dock");
					       timeline.append(     new TweenLite(this , 
						 						    time ,												    
						 						    {x:docked_dock.docking_point.x, 
		   				 		                     y:docked_dock.docking_point.y, 
						 							 rotation:svs ,
		                                     		 ease:Linear.easeNone}													 
						 							 ) );						   
						 							 
                           //this tween is getting the boat to the docked point													 
						   
						   //trace("Adding tween for docking");
		                   timeline.append(     new TweenLite(this , 
						 						    (time*2) ,												    
						 						    {x:docked_dock.docked_point.x, 
		   				 		                     y:docked_dock.docked_point.y, 
						 							 rotation:docked_dock.get_unloading_boat_rotation(),//has to be decided based on current rotation and dock
		                                     		 ease:Linear.easeNone}													 
						 							 ) );
						   
					       //1 - yellow cargo
					       //0 - red cargo
						   var n:Number=unloading_cargos.length;
					       for(var i:Number=0 ; i<n ; i++)
					       {
						   	   //trace("unloading one cargo");
						   	   var currently_unloading_cargo:Cargo=unloading_cargos.pop();  
						       timeline.append(     new TweenLite(currently_unloading_cargo , 
							  					    2 ,												    
						     					    { 
						     						 alpha:0,													 
		                                     		 ease:Linear.easeNone,
						      					     onComplete:update_score
						     						}													 
						      							 
						         					 ) );	
							
						       
						       
					       }  
						   
					       //fake tween after which we orientate the ship to be ready for sailing off
					       //and enable navigation again
					       //trace("setting the unloaded ship rot to "+docked_dock.get_unloaded_boat_rotation());
					       timeline.append(new TweenLite(this , 
						   						    0.01 ,												    
						   						    { 			
						   							 rotation:rotation,
		                                     		 ease:Linear.easeNone,
						   							 onComplete:enable_navigation
						   							 }													 
						   							 ) );	
                           //game.navigated_boat=null;
					   }        					     
					   else
					   {
						     //trace("no cargos for unloading");						   
				       }
			                										 
		                 //trace("DOKS HIT!!!!!!!!!!!PASSED!!!!!!!!!!!");		   
				   }
				   else  //Regular trajectory segment
				   {
				       //1.Inserting the regular trajectory segment tween
					   //2.Also insert a onComplete here to wipe the last trajectory segment
					   //from the navigated boat, and last trajectory line as well				 
					   //3.Update the index of current trajectory
					   this.currentTrajectoryIndex++;
					 
					   //Add the Graphicls for drawing the line and index it
					   var tlm:MovieClip=new MovieClip();
					   append_trajectoryLine_index(tlm,this.currentTrajectoryIndex);
				    
					   //Draw the actual line
					   var lp:Point=get_last_trajectory_point();
					   game.draw_trajectory_line(tlm, lp.x, lp.y, par_x, par_y);
					 
					   //Add the trajectory tween
		               var regularTween:TweenLite=new TweenLite(this , 
					  							       time/20*game.boat_tween_length ,												    
					 							       {x:par_x, 
		   			 			                        y:par_y, 
					 								    rotation:svs ,
		                                     		    ease:Linear.easeNone,
													    onComplete:erase_line_graphic_for_earliest_tween
														//onComplete:doComplete
													   }													 
				     									 )					
					 
					   timeline.append(regularTween);					
					
					   var lp:Point=get_last_trajectory_point();
				       set_one_before_last_trajectory_point(lp.x,lp.y);
			           set_last_trajectory_point(par_x, par_y);						   
					
					   set_last_trajectory_rotation(get_last_trajectory_rotation()+sv);			
				   }
				   		   
				   
			   }
			   else  //(if we HAVE hit a coast)
			   {
				   
							   
			   }							
		   }	      
		   
		   timeline.play(); 
		  		
	   }
		 
	   //This function removes the unloaded cargo from boat and updates game's score
	   function update_score():void
	   {
		   game.increment_and_refresh_points();
		   //removeChild(parameter1);
			 
			 
	   }
		 
	   //Append the prolonging tween based on last two trajectory points		
	   public function append_prolonged_tween(initial:Boolean=false):void
	   {
		   //trace("In append_prolonged_tween");
		   //If it is initial prolonged tween, put a pause at the beginning
		   if (initial==true)
		   {
			   //trace("Initial is true, this is the initial prolonged tween, so has extra tween");
			   var pause_tween:TweenLite=new TweenLite(this , 
		 							           1,												    
		     						           {x:this.x,
		 									    y:this.y,
		                                        ease:Linear.easeNone
		 			 				           }													
		 	 	     				          );
		 		
		       timeline.append(pause_tween);	
			   
		   }		
		   
		   //Next, we will remove the boat's prolonging tween and then add 
	       //a new prolonging tween, for prolonged movement of boat. This is because after
		   //manual navigation has been done, the boat should continue to move in that same
		   //direction.
		   var p1:Point = get_one_before_last_trajectory_point();
		   var p2:Point = get_last_trajectory_point();		
		   //trace(p1.x+" "+p1.y+" "+p2.x+" "+p2.y);
		  
		   //If one of these points has x=y=0 that means the point is actually not yet set
		   //It is not much possible that a point is set to exactly (0,0) :)
		   //there is probably a smarter way to detect if the point is not set, 
		   //but for now, this is the easier dumber way, so leaving it as it is for now
		     if ((p1.x==0 && p1.y==0)||(p2.x==0 && p2.y==0)) return;		  
		   else 
		   {//trace("p1:"+p1+" p2:"+p2+" prosli smo u append prolonged");
		   }
		  
		   //If there is a docked dock, don't prolong the tween, we are docking.
		   if(docked_dock!=null) return;		  
		 
		   var time:Number=game.tween_time;		
		 
		   //Let's detach the old prolonged_tween here, so we can attach a new one
		   var all:Array = timeline.getChildren();
		   if(all.indexOf(this.prolonged_tween)!=-1)
		   {
 		       //trace("Prolonged tween je: "+this.prolonged_tween);
 		       //trace("indexOf it is: "+all.indexOf(this.prolonged_tween));
 	        
 		       timeline.remove(this.prolonged_tween);
 		       this.prolonged_tween=null;
		   }
		   else 
		   {  
		       //Don't do anything, there is no prolonged tween to erase
		   }
		 
		   //Calculate the prolonged tween's last point to tween to. Avoid coasts and docks
		   var c:Array = game.calculate_prolonged_point(p1.x, p1.y, p2.x, p2.y, initial );
		 
		   //Assign the prolonged tween here, so later we can find and detach it and 
		   //attach a potential new one 
		   this.prolonged_tween=new TweenLite(this , 
		 							           time*c[2],												    
		     						           {x:c[0],
		 									    y:c[1],
		                                        ease:Linear.easeNone,
												onComplete:after_prolonged_tween,
												onCompleteParams:[c[3]]
		 			 				           }													
		 	 	     				          );
		 		
		   timeline.append(this.prolonged_tween);	
		  
	   }
	   
	   //Function which applies after boat finishes prolonged tween
	   private function after_prolonged_tween(param1:Boolean):void
	   {
		   if(param1)
		   {
		       game.delete_boat(this);			   
			   //trace("Boat should be deleted");
		   }
		   
	   }
	   
		
	   //Append tween and its associated line graphics to the array 
	   //trajectoryLines_indices
	   private function append_trajectoryLine_index(line_par:MovieClip,index:Number):void
	   {
			
			//trace("index traj line indexa je: "+index);
			var new_couple:Object={lin:line_par,ind:index};
			this.trajectoryLines_indices.push(new_couple);			
			
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
		
		//Delete the whole trajectory line for the boat
		public function erase_trajectory_line():void
		{			
			game.erase_trajectory_for_navigated_boat();		
			
		}
		
		//Erase the trajectory tween's trajectory line graphic segment
		public function erase_line_graphic_for_earliest_tween():void
		{			
		  
			var index_par:Number=this.earliest_line_index;
			var ar:Array=get_trajectoryLines_indices();
			
			if(ar.length==0) return;
			//trace ("index_par je: "+index_par);
			//trace ("ar je: "+ar);			
			
			var tl:MovieClip;			
			if(true)
			{
			  tl=ar[index_par].lin;				
			
			  if(tl!=null)
			  {
			    
				tl.graphics.clear();
			    tl=null;
			  }
			
			  //Earliest line index will be the next one after the just erased one
			  this.earliest_line_index++;
			}
			
			
			
		}
		
		//Delete all trajectory lines for the boat
		public function erase_all_trajectory_line_graphics():void
		{
			//trace ("in erase all traj line graphics");
			var ar:Array=get_trajectoryLines_indices();
			var tl:MovieClip;
			for(var i:Number=0;i<ar.length;i++)
			{				
			  tl=ar[i].lin;
			  tl.graphics.clear();			  
			  tl=null;
				
			}	
			
			this.trajectoryLines_indices=new Array();
			this.earliest_line_index=0;
			this.currentTrajectoryIndex=-1;
			//trace ("earliest line index je: "+this.earliest_line_index);
		}
		
		public function stop_animating()
		{
			timeline.stop();
			
		}
		
		public function get_unloading_cargos():Array
		{
			return unloading_cargos;
		}
		
		//Designate the cargos for unloading in the dock that boat is docked onto
		public function set_unloading_cargos():void
		{
			if (docked_dock.dock_color==RED) unloading_cargos = red_cargos; 
			else unloading_cargos = yellow_cargos;
		}		
		
		//Enable navigation after unloading cargos on dock
		private function enable_navigation():void
		{
			//trace("nav enabled");
			ready_for_navigation=true;
			rotation=docked_dock.get_unloaded_boat_rotation();
			this.docked_dock=null;
		}
		
		private function disable_navigation():void
		{
			ready_for_navigation=false;
		}
		
		public function get_ready_for_navigation():Boolean
		{
			return ready_for_navigation;			
		}
		
		public function set_ready_for_navigation(par:Boolean):void
		{
			ready_for_navigation=par;			
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
		}
		
		public function get_one_before_last_trajectory_point():Point
		{
			return this.one_before_last_trajectory_point;		
		}
		
		public function set_one_before_last_trajectory_point(x_par:Number,y_par:Number):void
		{
			this.one_before_last_trajectory_point = new Point(x_par,y_par);			
		}
		
		public function set_ready_for_new_path(par:Boolean):void
		{
			ready_for_new_path=par;
		}
		
		public function get_ready_for_new_path():Boolean
		{
			return  ready_for_new_path;
		}
		
		private function get_trajectoryLines_indices():Array
		{
			return this.trajectoryLines_indices;
			
		}
		
		private function set_trajectoryLines_indices(par:Array):void
		{
			this.trajectoryLines_indices=par;
			
		}
		
		public function stopTimeline()
		{
			this.timeline.stop();
		}
		
		

	}
	
}
