module rdata_generator;

import std.datetime : SysTime;
import mainsimulator : Movable, RDataSource;

struct Point
{
	import gfm.math : vec3f;
	int source;
	int track;
	vec3f pos;
	float heading;
}

auto distanceFromPointToSegment(V)(V p, V a, V b)
{
	import gfm.math : dot;

	auto n = (b - a);
	const t = (p - a).dot(n) / n.squaredMagnitude;

	if (t < 0)
		return a.distanceTo(p);
	else if (t > 1)
		return b.distanceTo(p);

	version(none)
	{
		const w = a - p;
		n.normalize;
		return (w - w.dot(n) * n).magnitude;
	}
	else
		return (a + n*t).distanceTo(p);
}

auto generateRData(Movable[] movables, RDataSource[] dsources, SysTime start, SysTime finish) nothrow
{
	import std.datetime : UTC;
	import std.range : iota;
	import std.stdio;

	Point[] points;

	try
	{
		foreach(int trk, ref m; movables[0..1])
		{
			foreach(int src, ref s; dsources[0..$])
			{
				float curr_d = 1e7;
				auto curr_m = m;
				bool descending;
				foreach(l; iota(start.stdTime, finish.stdTime, 100_000))
				{
					import std.math : sqrt, PI, sin, atan2;
					
					auto t = SysTime(l, UTC());
					s.update(t);
					m.update(t);

					const d = distanceFromPointToSegment(m.pos, s.pos, s.beamPosition(t));

					if (d < curr_d)
					{
						descending = true;
						curr_d = d;
						curr_m = m;
					}
					if (descending && d > curr_d)
					{
						descending = false;
						points ~= Point(src, trk, m.pos, atan2(m.vel.y, m.vel.x));
						curr_d = d;
					}
				}
			}
		}
	}
	catch(Exception e)
	{

	}

	return points;
}