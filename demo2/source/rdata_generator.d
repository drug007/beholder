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
					
					const p1 = s.pos;
					const p2 = s.beamPosition(t);
					import gfm.math : cross;
					float d = void;

					int y;
					{
						import gfm.math : dot;
						const w0 = p1 - m.pos;
						const w1 = p2 - m.pos;
						const v  = p1 - p2;
						if (w0.dot(v) <= 0)
						{
							d = (p1 - m.pos).squaredMagnitude;
							y = 1;
						}
						else
						if (w1.dot(v) >= 0)
						{
							d = (p2 - m.pos).squaredMagnitude;
							y = 2;
						}
						else
						{
							d = (p2 - p1).cross(p1 - m.pos).magnitude / (p2 - p1).squaredMagnitude;
							y = 3;
						}
					}

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