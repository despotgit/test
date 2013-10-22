﻿package  {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	import com.greensock.*;
	import com.greensock.easing.*;	
	
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Cruiser extends BoatController 
	{		
		
		public function Cruiser(par:Main,  cargos:Array ):void
		{
			// constructor code
			boat_gra = boat_gr;
			ready_for_navigation = true;                                                      
			
			red_cargos = new Array();
			yellow_cargos = new Array();
			
			all_cargos = cargos;
			
			//initing boat's cargo (zero here as parametar means red, and 1 means yellow) and length
			
				  			
				  cargo1_color=cargos[0];  
				  cargo2_color=cargos[1];
				  cargo3_color=cargos[2];  
				  cargo4_color=cargos[3];
				  
				  trace("cargo1_color je"+cargo1_color);
				  trace("cargo2_color je"+cargo2_color);
				  trace("cargo3_color je"+cargo3_color);
				  trace("cargo4_color je"+cargo4_color);
				  
				
				  if (cargo1_color==RED) 
				  {
					trace("cargo1_color je RED");
					(Cargo)(getChildByName("cargo1_mc")).gotoAndStop("red"); 
					red_cargos.push((Cargo)(getChildByName("cargo1_mc")));
				  }
				  else
				  {
					trace("cargo1_color je YELLOW");
					(Cargo)(getChildByName("cargo1_mc")).gotoAndStop("yellow"); 
					yellow_cargos.push((Cargo)(getChildByName("cargo1_mc")));
				  }			
				
				  if (cargo2_color==RED) 
				  {
					trace("cargo2_color je RED");  
					(Cargo)(getChildByName("cargo2_mc")).gotoAndStop("red"); 
					red_cargos.push((Cargo)(getChildByName("cargo2_mc")));
				  }
				  else
				  {
					trace("cargo2_color je YELLOW");  
					(Cargo)(getChildByName("cargo2_mc")).gotoAndStop("yellow"); 
					yellow_cargos.push((Cargo)(getChildByName("cargo2_mc")));
				  }
				  
				  if (cargo3_color==RED) 
				  {
					trace("cargo3_color je RED");  
					(Cargo)(getChildByName("cargo3_mc")).gotoAndStop("red"); 
					red_cargos.push((Cargo)(getChildByName("cargo3_mc")));
				  }
				  else
				  {
					trace("cargo3_color je YELLOW");  
					(Cargo)(getChildByName("cargo3_mc")).gotoAndStop("yellow"); 
					yellow_cargos.push((Cargo)(getChildByName("cargo3_mc")));
				  }
				  
				  if (cargo4_color==RED) 
				  {
					trace("cargo4_color je RED");  
					(Cargo)(getChildByName("cargo4_mc")).gotoAndStop("red"); 
					red_cargos.push((Cargo)(getChildByName("cargo4_mc")));
				  }
				  else
				  {
					trace("cargo4_color je YELLOW");  
					(Cargo)(getChildByName("cargo4_mc")).gotoAndStop("yellow"); 
					yellow_cargos.push((Cargo)(getChildByName("cargo4_mc")));
				  }
				
			this.game=par;
			this.timeline = new TimelineLite();
			timeline.autoRemoveChildren=true;
			this.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown); 
			//this.addEventListener(MouseEvent.MOUSE_UP,handleMouseUp); 
			ready_for_new_path=true;			
			
			// constructor code
		}

	}
	
}