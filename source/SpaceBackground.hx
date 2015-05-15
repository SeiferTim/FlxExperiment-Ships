package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.filters.BlurFilter;

class SpaceBackground extends FlxSprite
{

	
	
	public function new() 
	{
		super(0,0);
		
		
		createStarfield();
		
		
	}
	
	private function createStarfield():Void
	{
		var originalData:BitmapData = new BitmapData(FlxG.width, FlxG.height, false, 0xff000000);
		
		var rLevel:Int;
		var gLevel:Int;
		var bLevel:Int;
		var aLevel:Int;
		var finalColor:FlxColor;
		var pixelLoc:FlxPoint = FlxPoint.get();
		
		for (i in 0...Std.int((FlxG.width*FlxG.height)/100))
		{
			finalColor = FlxG.random.color(FlxColor.fromRGB(120, 120, 120,0), FlxColor.fromRGB(255, 255, 255,255));
			finalColor.alpha = FlxG.random.int(0, 255);
			
			pixelLoc.set(FlxG.random.int(0, FlxG.width), FlxG.random.int(0, FlxG.height));
			
			if (FlxG.random.bool(3))
			{
				if (FlxG.random.bool(3))
				{
					originalData.setPixel32(Std.int(pixelLoc.x), Std.int(pixelLoc.y), finalColor.getLightened(.4));
					originalData.setPixel32(Std.int(pixelLoc.x) + 1, Std.int(pixelLoc.y), finalColor);
					originalData.setPixel32(Std.int(pixelLoc.x), Std.int(pixelLoc.y) + 1, finalColor);
					originalData.setPixel32(Std.int(pixelLoc.x) - 1, Std.int(pixelLoc.y), finalColor);
					originalData.setPixel32(Std.int(pixelLoc.x), Std.int(pixelLoc.y) - 1, finalColor);
					
					originalData.setPixel32(Std.int(pixelLoc.x) + 2, Std.int(pixelLoc.y), finalColor);
					originalData.setPixel32(Std.int(pixelLoc.x), Std.int(pixelLoc.y) + 2, finalColor);
					originalData.setPixel32(Std.int(pixelLoc.x) - 2, Std.int(pixelLoc.y), finalColor);
					originalData.setPixel32(Std.int(pixelLoc.x), Std.int(pixelLoc.y) - 2, finalColor);
					
					originalData.setPixel32(Std.int(pixelLoc.x) + 1, Std.int(pixelLoc.y) + 1, finalColor.getLightened());
					originalData.setPixel32(Std.int(pixelLoc.x) - 1, Std.int(pixelLoc.y) + 1, finalColor.getLightened());
					originalData.setPixel32(Std.int(pixelLoc.x) - 1, Std.int(pixelLoc.y) - 1, finalColor.getLightened());
					originalData.setPixel32(Std.int(pixelLoc.x) + 1, Std.int(pixelLoc.y) - 1, finalColor.getLightened());
				}
				else
				{
					originalData.setPixel32(Std.int(pixelLoc.x), Std.int(pixelLoc.y), finalColor.getLightened());
					originalData.setPixel32(Std.int(pixelLoc.x) + 1, Std.int(pixelLoc.y), finalColor);
					originalData.setPixel32(Std.int(pixelLoc.x), Std.int(pixelLoc.y) + 1, finalColor);
					originalData.setPixel32(Std.int(pixelLoc.x) - 1, Std.int(pixelLoc.y), finalColor);
					originalData.setPixel32(Std.int(pixelLoc.x), Std.int(pixelLoc.y) - 1, finalColor);
				}
				
				
			}
			else
			{
				originalData.setPixel32(Std.int(pixelLoc.x), Std.int(pixelLoc.y), finalColor);
			}
		}
		pixelLoc.put();
		//originalData.applyFilter(originalData, originalData.rect, _flashPoint, new BlurFilter(2, 2, 1));
		
		var colors:Array<UInt> = [];
		var baseHue:UInt = FlxG.random.int(0, 360);
		
		for (i in 0...4)
		{
			baseHue = FlxMath.wrapValue(baseHue+(20 * FlxG.random.int( -2, 2)),0,360);
			colors.push(FlxColor.fromHSB(baseHue, FlxG.random.float(.5, 1), FlxG.random.float(.5, 1), FlxG.random.float(0, .8)));
		}
		
		var gradData:BitmapData = FlxGradient.createGradientBitmapData(FlxG.width, FlxG.height, colors, 1, FlxG.random.int(1,360));
		var noise:BitmapData = new BitmapData(FlxG.width, FlxG.height, true, 0x0);
		noise.perlinNoise(FlxG.width, FlxG.height, 32, FlxG.random.int(),   true,  true,  7 , true);
		gradData.copyChannel(noise, noise.rect, _flashPoint, BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
		noise.dispose();
		originalData.copyPixels(gradData, gradData.rect, _flashPoint);
		
		gradData.dispose();
		
		loadGraphic(originalData, false, FlxG.width, FlxG.height, false, "starfield");
	}
	
}