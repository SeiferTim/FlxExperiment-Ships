package;

class MiniMT
{

	private static inline var N:Int = 624;
	private static inline var M:Int = 397;
	private static inline var MATRIX_A:UInt = 0x9908b0df;
	private static inline var UPPER_MASK:UInt = 0x80000000;
	private static inline var LOWER_MASK:UInt = 0x7fffffff;
	private static inline var TEMPERING_MASK_B:UInt = 0x9d2c5680;
	private static inline var TEMPERING_MASK_C:UInt = 0xefc60000;
	
	public var seed(default, set):Float;
	private var _mt:Array<UInt>;
	private var _mag01:Array<UInt> = [0x0, MATRIX_A];
	private var _mti:UInt;
	
	
	public function new() 
	{
		seed = 0;
	}
	
	
	private function set_seed(Value:Float):Float
	{
		seed = Value;
		_mt = new Array<UInt>();
		_mt[0] = (Std.int(seed) & 0xfffffff);
		for (i in 1...N)
		{
			_mti = i;
			_mt[i] = (1812433253 * (_mt[i - 1] ^ (_mt[i - 1] >>> 30)) + i);
			_mt[i] &= 0xffffffff;
		}
		return seed;
	}
	
	public function generate():UInt 
	{
		
		var y:UInt;
		if (_mti >= N)
		{
			for (kk in 0...N - M)
			{
				y = (_mt[kk] & UPPER_MASK) | (_mt[kk + 1] & LOWER_MASK);
				_mt[kk] = _mt[kk + M] ^ (y >>> 1) ^ _mag01[y & 0x1];
			}
			for (kk in N - M...N - 1)
			{
				y = (_mt[kk] & UPPER_MASK) | (_mt[kk + 1] & LOWER_MASK);
				_mt[kk] = _mt[kk + (M - N)] ^ (y >>> 1) ^ _mag01[y & 0x1];
			}
			y = (_mt[N - 1] & UPPER_MASK) | (_mt[0] & LOWER_MASK);
			_mt[N - 1] = _mt[M - 1] ^ (y >>> 1) ^ _mag01[y & 0x1];
			_mti = 0;
		}
		y = _mt[_mti++];
		y ^= y >>> 11;
		y ^= (y << 7) & TEMPERING_MASK_B;
		y ^= (y << 15) & TEMPERING_MASK_C;
		y ^= (y << 18);
		return y;
		
	}
	
}