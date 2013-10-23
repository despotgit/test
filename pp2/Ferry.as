package  {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Ferry extends BoatController 
	{

		public function Ferry(par:Main,  cargos:Array ):void
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
