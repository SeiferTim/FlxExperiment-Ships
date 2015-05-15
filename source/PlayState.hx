package;

import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
using flixel.util.FlxSpriteUtil;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var _ships:FlxTypedGroup<Ship>;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		bgColor = 0xff000000;
		
		add(new SpaceBackground());
		
		var _trails:FlxTrailArea = new FlxTrailArea(0, 0, FlxG.width, FlxG.height,.98,2,false,true, BlendMode.SCREEN);
		_trails.alpha = .33;
		_trails.blend = BlendMode.OVERLAY;
		add(_trails);
		
		var _ship;
		for (i in 0...20)
		{
			_ship = new Ship();
			_ship.generate();
			
			_trails.add(_ship);
			
			
			add(_ship);
		}
		
		
		super.create();
	}
	
}
