package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.FlxAccelerometer;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import openfl.display.BitmapData;

class Ship extends FlxSprite
{
	private inline static var ROWS:UInt = 12;
	private inline static var COLS:UInt = 12;
	
	private inline static var EMPTY:Int = 0;
	private inline static var AVOID:Int = 1;
	private inline static var SOLID:Int = 2;
	private inline static var COKPT:Int = 3;
	
	private inline static var OUTLINE_COLOR:UInt = 0xff333333;
	
	private inline static var SPEED:Int = 200;
	
	public var size(default, null):Int = 0;
	
	private var _basePos:FlxPoint;
	
	public function new() 
	{
		super();
		_basePos = FlxPoint.get();

	}
	
	public function generate(?Seed:UInt=0,?ColorSeed:UInt=0):Void
	{
		
		var _seed:UInt; 
		var _colorseed:UInt;
		if (Seed == 0)
			_seed = FlxG.random.int();
		else
			_seed = Seed;
		if (ColorSeed == 0)
			_colorseed = FlxG.random.int();
		else
			_colorseed = ColorSeed;
		
		
		var _grid:Array<Array<UInt>> = new Array<Array<UInt>>();
		_grid = [];
		for (r in 0...ROWS)
		{
			_grid[r] = [];
			for (c in 0...COLS)
			{
				_grid[r][c] = EMPTY;
			}
		}
		var c:UInt;
		var r:UInt;
		var solidcs:Array<UInt> = [5, 5, 5, 5, 5];
		var solidrs:Array<UInt> = [2, 3, 4, 5, 9];
		for (i in 0...solidcs.length)
		{
			c = solidcs[i];
			r = solidrs[i];
			_grid[r][c] = SOLID;
		}
		var avoidcs:Array<UInt> = [1, 1, 1, 1, 1, 4, 5, 4, 3, 4, 3, 4, 2, 3, 4, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 4, 3, 4, 5];
		var avoidrs:Array<UInt> = [1, 2, 3, 4, 5, 1, 1, 2, 3, 3, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10];
		var bitmask:Int = 1;
		
		for (i in 0...avoidcs.length)
		{
			c = avoidcs[i];
			r = avoidrs[i];
			
			_grid[r][c] = ((_seed & bitmask) != 0) ? AVOID : EMPTY;
			bitmask <<= 1;
		}
		var emptycs = [4,5,4,4];
		var emptyrs = [6,6,7,8];
		bitmask = 1 << 26;
		for (i in 0...emptycs.length)
		{
			c = emptycs[i];
			r = emptyrs[i];
			_grid[r][c] = ((_seed & bitmask) != 0) ? SOLID : COKPT;
			bitmask <<= 1;
		}
		
		var cokptcs = [5, 5];
		var cokptrs = [7, 8];
		for (i in 0...cokptcs.length)
		{
			c = cokptcs[i];
			r = cokptrs[i];
			_grid[r][c] = COKPT;
			
		}
		
		var needsolid:Bool = false;
		var here:Int;
		for (r in 0...ROWS)
		{
			for (c in 0...Std.int(COLS/2))
			{
				
				if (_grid[r][c] == EMPTY)
				{
					needsolid = false;
					if ((c > 0) && (_grid[r][c - 1] == AVOID)) 
						needsolid = true;
					if ((c < (COLS/2) - 1) && (_grid[r][c + 1] == AVOID)) 
						needsolid = true;
					if ((r > 0) && (_grid[r - 1][c] == AVOID)) 
						needsolid = true;
					if ((r < ROWS - 1) && (_grid[r + 1][c] == AVOID)) 
						needsolid = true;
					if (needsolid)
						_grid[r][c] = SOLID;
				}
				
			}
		}
		for (r in 0...ROWS)
		{
			for (c in 0...Std.int(COLS / 2))
			{
				_grid[r][COLS - 1 - c] = _grid[r][c];
			}
		}
		
		
		
		// (COLS, ROWS, 0x0, false, Std.string(_seed+_colorseed));
		
		
		var bm:BitmapData = new BitmapData(COLS, ROWS, true, 0x0);
		
		var sats:Array<Float> = [40,60,80,100,80,60, 80,100,120, 100,80,60];
		var bris:Array<Float> = [70, 100, 130, 160, 190, 220, 220, 190, 160, 130, 100, 70];
		var mysat:Float;
		var mybri:Float;
		var h:Int;
		size = 0;
		for (r in 0...ROWS)
		{
			for (c in 0...COLS)
			{
				switch (_grid[r][c])
				{
					case EMPTY:
						bm.setPixel32(c, r, 0x00ffffff);
					
					case SOLID:
						bm.setPixel32(c, r, OUTLINE_COLOR);
						size+= 2;
					case AVOID:
						mysat = sats[r]+20;
						mybri = bris[c]+20;
						size++;
						h = 0;
						
						if (r < 6)
						{							
							h = (_colorseed & 0xff) >> 0;
						}
						else if (r < 9) 
						{
							h = (_colorseed & 0xff00) >> 8;
						}
						else
							h = (_colorseed & 0xff0000) >> 16;
						
						bm.setPixel32(c, r, FlxColor.fromHSB(h,  mysat/255, mybri/255));
						
					case COKPT:
						size+= 2;
						mysat = sats[c]+80;
						mybri = bris[r] + 100;
						h = (_seed & 0xff);
						bm.setPixel32(c, r, FlxColor.fromHSB(h, mysat/255, mybri/255));
						
				}
				
				
 			}
		}
		
		
		loadGraphic(bm, false, ROWS, COLS, false, Std.string(_seed + _colorseed));
		
		
		spawn();
	}
	
	private function spawn():Void 
	{
		velocity.set();
		switch(FlxG.random.int(0, 3))
		{
			case 0:
				angle = 0;
				x = FlxG.random.int( -8, FlxG.width - 8);
				y = FlxG.height + FlxG.random.int(16,100);
				velocity.y = -SPEED * (1 - (size / 256));
			case 1:
				angle = 90;
				x = FlxG.random.int(-100,-16);
				y = FlxG.random.int( -8, FlxG.height - 8);
				velocity.x = SPEED * (1 - (size / 256));
			case 2:
				angle = 180;
				x = FlxG.random.int( -8, FlxG.width - 8);
				y = -16-FlxG.random.int(16,100);
				velocity.y = SPEED * (1 - (size / 256));
			case 3:
				angle = 270;
				x = FlxG.width + FlxG.random.int(16,100);
				y = FlxG.random.int( -8, FlxG.height - 8);
				velocity.x = -SPEED * (1 - (size / 256));
		}
		_basePos.set(x, y);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (alive && exists)
		{
			if ((velocity.x > 0 && x > FlxG.width) || (velocity.x < 0 && x < -width) || (velocity.y > 0 && y > FlxG.height) || (velocity.y < 0 && y < -height))
			{
				generate();
			}
			
			if (velocity.x != 0)
			{
				// horizontal
				
				y = _basePos.y + (8 * Math.sin((FlxG.game.ticks + size) * .5  * Math.PI / (size*4)));
			}
			else
			{
				//vertical
				x = _basePos.x + (8 * Math.sin((FlxG.game.ticks + size)  * .5 * Math.PI / (size*4)));
			}
			
			
		}
		
		
		super.update(elapsed);
	}
	
}