package object
{
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class ImageObjectBase extends Image
	{
		protected var _vx:Number;
		protected var _vy:Number;

		public function ImageObjectBase(texture:Texture)
		{
			super(texture);
		}

		public function get vx():Number
		{
			return _vx;
		}

		public function set vx(value:Number):void
		{
			_vx = value;
		}

		public function get vy():Number
		{
			return _vy;
		}

		public function set vy(value:Number):void
		{
			_vy = value;
		}
	}
}