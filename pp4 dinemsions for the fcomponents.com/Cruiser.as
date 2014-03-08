package  {
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
				
				  if (cargo1_color==RED) 
				  {					
					(Cargo)(getChildByName("cargo1_mc")).gotoAndStop("red"); 
					red_cargos.push((Cargo)(getChildByName("cargo1_mc")));
				  }
				  else
				  {
					(Cargo)(getChildByName("cargo1_mc")).gotoAndStop("yellow"); 
					yellow_cargos.push((Cargo)(getChildByName("cargo1_mc")));
				  }			
				
				  if (cargo2_color==RED) 
				  { 
					(Cargo)(getChildByName("cargo2_mc")).gotoAndStop("red"); 
					red_cargos.push((Cargo)(getChildByName("cargo2_mc")));
				  }
				  else
				  { 
					(Cargo)(getChildByName("cargo2_mc")).gotoAndStop("yellow"); 
					yellow_cargos.push((Cargo)(getChildByName("cargo2_mc")));
				  }
				  
				  if (cargo3_color==RED) 
				  { 
					(Cargo)(getChildByName("cargo3_mc")).gotoAndStop("red"); 
					red_cargos.push((Cargo)(getChildByName("cargo3_mc")));
				  }
				  else
				  { 
					(Cargo)(getChildByName("cargo3_mc")).gotoAndStop("yellow"); 
					yellow_cargos.push((Cargo)(getChildByName("cargo3_mc")));
				  }
				  
				  if (cargo4_color==RED) 
				  {
					(Cargo)(getChildByName("cargo4_mc")).gotoAndStop("red"); 
					red_cargos.push((Cargo)(getChildByName("cargo4_mc")));
				  }
				  else
				  { 
					(Cargo)(getChildByName("cargo4_mc")).gotoAndStop("yellow"); 
					yellow_cargos.push((Cargo)(getChildByName("cargo4_mc")));
				  }
				
			this.game=par;
			
			
			
			// constructor code
		}

	}
	
}
