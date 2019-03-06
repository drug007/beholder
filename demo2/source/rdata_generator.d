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

	try debug
	{
		writeln(start, "\t", finish);
		foreach(l; iota(start.stdTime, finish.stdTime, 100_000))
		{
			auto t = SysTime(l, UTC());
			foreach(ref s; dsources)
			{
				s.update(t);
			}

			foreach(int trk, ref m; movables[0..1])
			{
				m.update(t);
				// writeln(m);
				foreach(int src, ref s; dsources[0..1])
				{
					import std.math : sqrt, PI, sin, atan2;
					const p1 = s.pos;
					const p2 = s.beamPosition(t);
					const r = (m.pos - s.pos).magnitude;
					const betta = 3 * PI / 180.0;
					const w = 0.1;//r * sin(betta/2);
					import gfm.math : cross;
					// const d = (p2 - p1).cross(p1 - m.pos).magnitude / (p2 - p1).squaredMagnitude;
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

					if (d < w * w)
					{
						writeln(p1, " ", p2, "\t", trk, ": ", t, ", ", m.pos, " - ", "w: ", w, " ", sqrt(d));
						points ~= Point(src, trk, m.pos, atan2(m.vel.y, m.vel.x));
						writeln(y);
					}
				}
			}
			// writeln(l/cast(double)(finish.stdTime-start.stdTime));
		}
		// writeln("total: ", points.length);
	}
	catch(Exception e)
	{

	}

	return points;
}