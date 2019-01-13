module color_table;

import std.experimental.color.rgb : RGBAf32;
import std.experimental.color.lab : LCh;

struct ColorTable
{
	RGBAf32[uint] tbl;

	this(uint[] numbers)
	{
		auto lch = LCh!float(100, 100, 0);
		const l = numbers.length;
		foreach(i; 0..l/2)
		{
			import std.math : PI;
			lch.radians = i * 2 * PI / l;
			auto rgba = cast(RGBAf32) lch;
			tbl[numbers[i]] = rgba;
		}

		lch.C = 50;
		foreach(i; l/2..l)
		{
			import std.math : PI;
			lch.radians = i * 2 * PI / l;
			auto rgba = cast(RGBAf32) lch;
			tbl[numbers[i]] = rgba;
		}
	}

	auto opCall(uint n) const
	{
		auto clr = n in tbl;
		if(clr)
			return *clr;

		return RGBAf32(1, 0, 0, 1);
	}
}