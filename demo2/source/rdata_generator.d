module rdata_generator;

import std.datetime : SysTime;
import mainsimulator : Movable, RDataSource;

struct Point
{
	import gfm.math : vec3f;
	int source;
	int track;
	vec3f pos;
	vec3f vel;
	SysTime timestamp;

	this(int source, int track, vec3f pos, vec3f vel, SysTime timestamp)
	{
		this.source    = source;
		this.track     = track;
		this.pos       = pos;
		this.vel       = vel;
		this.timestamp = timestamp;
	}

	void serialize(S)(ref S serializer) const
	{
		auto state1 = serializer.objectBegin;
		scope(exit) serializer.objectEnd(state1);

		serializer.putEscapedKey("kind");
		serializer.putValue("target_innovation_");
		serializer.putEscapedKey("payload");
		
		{
			auto state2 = serializer.objectBegin;
			scope(exit) serializer.objectEnd(state2);

			serializer.putEscapedKey("id");
			{
				auto state3 = serializer.objectBegin;
				scope(exit) serializer.objectEnd(state3);
				
				serializer.putEscapedKey("source");
				serializer.putValue(source);

				serializer.putEscapedKey("track");
				serializer.putValue(track);
			}

			serializer.putEscapedKey("position");
			{
				auto state3 = serializer.objectBegin;
				scope(exit) serializer.objectEnd(state3);

				serializer.putEscapedKey("decart");
				{
					auto state4 = serializer.objectBegin;
					scope(exit) serializer.objectEnd(state4);

					serializer.putEscapedKey("x");
					serializer.putValue(pos.x);

					serializer.putEscapedKey("y");
					serializer.putValue(pos.y);

					serializer.putEscapedKey("z");
					serializer.putValue(pos.z);
				}
			}

			serializer.putEscapedKey("velocity");
			{
				auto state3 = serializer.objectBegin;
				scope(exit) serializer.objectEnd(state3);

				serializer.putEscapedKey("x");
				serializer.putValue(vel.x);

				serializer.putEscapedKey("y");
				serializer.putValue(vel.y);

				serializer.putEscapedKey("z");
				serializer.putValue(vel.z);
			}

			serializer.putEscapedKey("timestamp");
			{
				import std.format : sformat;

				char[31] buffer = void;
				auto str = timestamp.toUTC.toISOExtString;
				sformat(buffer[], "%-31s", str);
				
				serializer.putValue(str);
			}
		}
	}
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

auto distance(ref const(Movable) m, ref const(RDataSource) s, SysTime t)
{
	const mm = m.calculate(t);	
	const p1 = s.pos0;
	const p2 = s.beamPosition(t);

	return distanceFromPointToSegment(mm[0], p1, p2);
}

auto generateRData(Movable[] movables, RDataSource[] dsources) nothrow
{
	import std.range : iota;

	Point[] points;

	try
	{
		foreach(int trk, ref m; movables[0..$])
		{
			foreach(int src, ref s; dsources[0..$])
			{				
				import std.math : atan2;
				import std.datetime : msecs, UTC, Duration;

				const start  = m.tl.start  > s.start_timestamp  ? m.tl.start  : s.start_timestamp;
				const finish = m.tl.finish < s.finish_timestamp ? m.tl.finish : s.finish_timestamp;
				assert(start < finish);
								
				const base_delta = 100.msecs;
				assert(finish - start > base_delta);

				SysTime curr_t = start;
				float curr_d = distance(m, s, curr_t);

				bool grad_is_positive = true;
				Duration delta = base_delta;
				while(curr_t < finish)
				{
					const d = distance(m, s, curr_t+delta);
					const grad = d - curr_d;
					const new_grad_is_positive = (grad >= 0);
					if (!grad_is_positive && new_grad_is_positive)
					{
						const e = 1.0f;
						if (grad > e)
						{
							delta /= 2;
							assert(delta > Duration.zero);
							continue;
						}
						const r = m.calculate(curr_t);
						points ~= Point(src+1, trk+1, r[0], r[1], curr_t);
						delta = base_delta;
					}
					grad_is_positive = new_grad_is_positive;
					curr_d = d;
					curr_t += delta;
				}
			}
		}

		import asdf, std.algorithm;
		import std.stdio;
		stderr.writeln(points.sort!((a,b)=>a.timestamp < b.timestamp).serializeToJsonPretty);
	}
	catch(Exception e)
	{

	}

	return points;
}