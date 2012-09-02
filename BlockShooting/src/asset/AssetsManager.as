package asset
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class AssetsManager
	{
		// static varって書き方もできるのは知らなかったな
		private static var textures:Object = new Object();
		private static var textureAtlases:Object = new Object();
		private static var xmls:Object = new Object();

		public static function getTexture(name:String):Texture
		{
			if (textures[name] == undefined)
			{
				var data:Object = create(name);
				textures[name] = Texture.fromBitmap(data as Bitmap, true, false);
			}
			
			return textures[name];
		}

		public static function getXml(name:String):XML
		{
			if (xmls[name] == undefined)
			{
				var data:Object = create(name);
				xmls[name] = XML(data); // data as Stringやdata as XMLにするとnullになる。型は不明。
			}
			
			return xmls[name];
		}

		public static function getTextureAtlas(name:String):Vector.<Texture>
		{
			if (textureAtlases[name] == undefined)
			{
				var texture:Texture = getTexture(name + "Bitmap");
				var xml:XML = getXml(name + "Xml");
				var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
				var frames:Vector.<Texture> = textureAtlas.getTextures(name);
				textureAtlases[name] = frames;
			}
			
			return textureAtlases[name];
		}

		private static function create(name:String):Object
		{
			return new AssetEmbeds[name];
		}

	}
}
