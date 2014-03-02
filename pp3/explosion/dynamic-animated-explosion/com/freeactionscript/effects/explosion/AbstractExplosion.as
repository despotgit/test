/**
 * Dynamic Animated Explosion
 * ---------------------
 * VERSION: 1.0
 * DATE: 8/22/2011
 * AS3
 * UPDATES AND DOCUMENTATION AT: http://www.FreeActionScript.com
 **/
package com.freeactionscript.effects.explosion 
{
	import com.freeactionscript.effects.explosion.Particle;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.BlurFilter;
	import flash.filters.GradientGlowFilter;
	
	
	///////////////////////////
	/**
	 * This is an Abstract class. Do not instantiate it directly. Extend it instead.
	 */
	///////////////////////////
	
	public class AbstractExplosion 
	{
		// properties
		protected var _numberOfFireballs:Number;
		protected var _explosionRange:Number;
		protected var _growScale:Number;
		protected var _growSpeed:Number;
		protected var _growAlpha:Number;
		protected var _fadeSpeed:Number;
		protected var _speedY:Number;
		protected var _speedX:Number;
		protected var _randomRangeX:Number;
		protected var _randomRangeY:Number;
		protected var _randomNumber:Number;
		protected var _randomBlur:Number;
		
		// vars
		protected var _tempParticle:Particle;
		protected var _container:DisplayObjectContainer;
		protected var _particles:Array = [];
		
		// filters
		protected var _blurFilter:BlurFilter;
		protected var _gradientGlowFilter:GradientGlowFilter;
		
		/**
		 * Explosion Constructor
		 * @param	container	Takes MovieClip, Sprite, Document Class as argument
		 */
		function AbstractExplosion(container:DisplayObjectContainer) 
		{
			// save reference to parent container
			_container = container;
			
			// set initial stats
			setStats();
		}
		
		//////////////////////////////////////
		// Public API 
		//////////////////////////////////////
		
		/**
		 * Create Multiple fireballs at X & Y
		 * @param	amount
		 * @param	targetX
		 * @param	targetY
		 */
		public function create(targetX:Number, targetY:Number):void
		{
			createBurnMark(targetX, targetY);
			
			createFireballBase(targetX, targetY);
			
			for (var i:int = 0; i < _numberOfFireballs; i++)
			{
				createFireball(targetX, targetY);
			}
			
			createLight(targetX, targetY);
			
		}
		
		/**
		 * This method updates all the particles
		 */
		public function update():void
		{
			for (var i:int = 0; i < _particles.length; i++)
			{
				_tempParticle = _particles[i] as Particle;
				
				_tempParticle.scaleX += _tempParticle.growSpeed;
				_tempParticle.scaleY += _tempParticle.growSpeed;
				_tempParticle.alpha -= _tempParticle.fadeSpeed;
				_tempParticle.x -= _tempParticle.vx;
				_tempParticle.y -= _tempParticle.vy;
				
				if (_tempParticle.alpha <= 0)
				{
					destroyParticle(_tempParticle);
				}
			}
			
		}
		
		//////////////////////////////////////
		// Private Methods 
		//////////////////////////////////////
		
		/**
		 * This function sets explosion settings
		 */
		protected function setStats():void
		{
			// default stats
			_numberOfFireballs = 15;
			_explosionRange = 35;
			_growScale = Math.random() * 100 * .01;
			_growSpeed = .1
			_growAlpha = Math.random() * 200 * .01;
			_fadeSpeed = .1
			_randomRangeX = Math.random() * _explosionRange - _explosionRange * .5;
			_randomRangeY = Math.random() * _explosionRange - _explosionRange * .5;
			_randomNumber = Math.round(Math.random() * 1);
			_speedX = 0;
			_speedY = 0;
			_randomBlur = Math.random() * 3 + 3;
		}
		
		/**
		 * Create single fireball at X & Y
		 * @param	targetX
		 * @param	targetY
		 */
		private function createFireball(targetX:Number, targetY:Number):void
		{
			_tempParticle = new Particle(new Fireball());
			
			setStats();
			
			// set particle properties
			_tempParticle.x = targetX + _randomRangeX;
			_tempParticle.y = targetY + _randomRangeY;
			_tempParticle.scaleX = _growScale;
			_tempParticle.scaleY = _growScale;
			_tempParticle.alpha = _growAlpha;
			_tempParticle.growSpeed = _growSpeed;
			_tempParticle.fadeSpeed = _fadeSpeed;
			_tempParticle.vx = _speedX;
			_tempParticle.vy = _speedY;
			
			// add filters
			if (_randomNumber == 1)
			{
				setupFilters();
				_tempParticle.filters = [_blurFilter, _gradientGlowFilter];
			}
			
			// add to display list
			_container.addChild(_tempParticle);
			
			// add to particle array
			_particles.push(_tempParticle);
		}
		
		/**
		 * Create light at X & Y
		 * @param	targetX
		 * @param	targetY
		 */
		protected function createLight(targetX:Number, targetY:Number):void
		{
			_tempParticle = new Particle(new Light());
			
			// set particle properties
			_tempParticle.x = targetX;
			_tempParticle.y = targetY;
			_tempParticle.scaleX = 3.5;
			_tempParticle.scaleY = 3.5;
			_tempParticle.alpha = .5;
			_tempParticle.growSpeed = .5;
			_tempParticle.fadeSpeed = .1;
			_tempParticle.vx = 0;
			_tempParticle.vy = 0;
			
			// add to display list
			_container.addChild(_tempParticle);
			
			// add to particle array
			_particles.push(_tempParticle);
		}
		
		/**
		 * Create fireball base at X & Y
		 * @param	targetX
		 * @param	targetY
		 */
		protected function createFireballBase(targetX:Number, targetY:Number):void
		{
			_tempParticle = new Particle(new Fireball());
			
			// set particle properties
			_tempParticle.x = targetX;
			_tempParticle.y = targetY;
			_tempParticle.scaleX = 2;
			_tempParticle.scaleY = 2;
			_tempParticle.alpha = 1;
			_tempParticle.growSpeed = .2;
			_tempParticle.fadeSpeed = .1;
			_tempParticle.vx = 0;
			_tempParticle.vy = 0;
			
			// add to display list
			_container.addChild(_tempParticle);
			
			// add to particle array
			_particles.push(_tempParticle);
		}
		
		/**
		 * Create fireball burn mark at X & Y
		 * @param	targetX
		 * @param	targetY
		 */
		protected function createBurnMark(targetX:Number, targetY:Number):void
		{
			_tempParticle = new Particle(new BurnMark());
			
			// set particle properties
			_tempParticle.x = targetX;
			_tempParticle.y = targetY;
			_tempParticle.scaleX = 2;
			_tempParticle.scaleY = 2;
			_tempParticle.alpha = 1;
			_tempParticle.growSpeed = 0;
			_tempParticle.fadeSpeed = 0;
			_tempParticle.vx = 0;
			_tempParticle.vy = 0;
			_tempParticle.rotation = Math.random() * 360;
			
			// add to display list
			_container.addChild(_tempParticle);
			
			// burn marks dont get added to _particles array
			//_particles.push(_tempParticle);
		}
		
		/**
		 * Use this to setup filters
		 */
		protected function setupFilters():void
		{
			// create blur filter
			_blurFilter = new BlurFilter(); 
			_blurFilter.blurX = _randomBlur;
			_blurFilter.blurY = _randomBlur;
			_blurFilter.quality = BitmapFilterQuality.MEDIUM; 
			
			// create gradient glow filter
			_gradientGlowFilter = new GradientGlowFilter();			
			_gradientGlowFilter.distance = 0; 
			_gradientGlowFilter.angle = 45; 
			_gradientGlowFilter.colors = [0x000000, 0xFF0000]; 
			_gradientGlowFilter.alphas = [0, 1]; 
			_gradientGlowFilter.ratios = [0, 255]; 
			_gradientGlowFilter.blurX = _randomBlur;
			_gradientGlowFilter.blurY = _randomBlur;
			_gradientGlowFilter.strength = 2; 
			_gradientGlowFilter.quality = BitmapFilterQuality.LOW; 
			_gradientGlowFilter.type = BitmapFilterType.OUTER; 
		}
		
		/**
		 * Use this to destroy partcles
		 * @param	particle	Takes particle movieclip
		 */
		private function destroyParticle(particle:Particle):void
		{
			// loop thru _bullets array
			for (var i:int = 0; i < _particles.length; i++)
			{
				// save a reference to current bullet
				_tempParticle = _particles[i] as Particle;
				
				// if found bullet in array
				if (_tempParticle == particle)
				{
					// remove from array
					_particles.splice(i, 1);
					
					// remove from display list
					_tempParticle.parent.removeChild(particle);
					
					// stop loop
					return;
				}
			}
		}
		
	}

}