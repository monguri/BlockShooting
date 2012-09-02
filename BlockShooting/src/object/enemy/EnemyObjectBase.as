package object.enemy
{
	import dataModel.IFXmlData;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import object.CollisionEvent;
	import object.ImageObjectBase;
	import object.enemy.IFEnemy;
	
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class EnemyObjectBase extends ImageObjectBase implements IFEnemy
	{
		private var _life:int;
		protected var _bulletInterval:int;
		protected var _bulletSpeed:int;
		protected var _bulletTexture:String = null;
		protected var _bulletClass:Class;
		protected var _bulletLayer:Sprite;
		protected var _explosionTexture:String = null;
		protected var _explosionClass:Class;
		protected var _explosionLayer:Sprite;
		
		public static const EVENT_TYPE_SELF_DISPOSE:String = "selfDispose";

		public function EnemyObjectBase(texture:Texture)
		{
			super(texture);
		}

		public function start():void
		{
			
		}

		public function stop():void
		{
			
		}

		public function collisionHandler(event:CollisionEvent):void
		{
		}

		public function get life():int
		{
			return _life;
		}

		public function set life(value:int):void
		{
			_life = value;
		}

		public function set bulletInterval(value:int):void
		{
			_bulletInterval = value;
		}

		public function get bulletSpeed():int
		{
			return _bulletSpeed;
		}

		public function set bulletSpeed(value:int):void
		{
			_bulletSpeed = value;
		}

		public function set bulletTexture(value:String):void
		{
			_bulletTexture = value;
		}

		public function set bulletClass(value:Class):void
		{
			_bulletClass = value;
		}

		public function set bulletLayer(value:Sprite):void
		{
			_bulletLayer = value;
		}

		public function set explosionTexture(value:String):void
		{
			_explosionTexture = value;
		}

		public function set explosionClass(value:Class):void
		{
			_explosionClass = value;
		}

		public function set explosionLayer(value:Sprite):void
		{
			_explosionLayer = value;
		}

	}
}