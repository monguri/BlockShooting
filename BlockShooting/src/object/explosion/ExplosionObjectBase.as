package object.explosion
{
	import flash.media.Sound;
	
	import object.MovieClipObjectBase;
	import object.enemy.EnemyObjectBase;
	import object.enemy.IFEnemy;
	
	import starling.events.Event;
	import starling.textures.Texture;

	public class ExplosionObjectBase extends MovieClipObjectBase
	{
		private var _target:EnemyObjectBase;
		protected var _se:Sound;
		private var _dx:int;
		private var _dy:int;

		public function ExplosionObjectBase(se:Sound, textures:Vector.<Texture>, fps:Number)
		{
			_se = se;
			super(textures, fps);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void
		{
			x = _target.x + _dx;
			y = _target.y + _dy;
			// TODO:ターゲットの爆発位置を指定する
		}
		
		public function set target(value:EnemyObjectBase):void
		{
			_target = value;
		}

		public function set dx(value:int):void
		{
			_dx = value;
		}

		public function set dy(value:int):void
		{
			_dy = value;
		}


	}
}