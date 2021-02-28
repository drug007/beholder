module rdata_generator;

import std.datetime : SysTime;
import mainsimulator : Movable, RDataSource;
import gfm.math : vec3f;

struct RDataPoint
{
	import gfm.math : vec3f;
	int source;
	int track;
	vec3f pos;
	vec3f pos_error;
	vec3f vel;
	SysTime timestamp;

	this(int source, int track, vec3f pos, vec3f pos_error, vec3f vel, SysTime timestamp)
	{
		this.source    = source;
		this.track     = track;
		this.pos       = pos;
		this.pos_error = pos_error;
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

				serializer.putEscapedKey("value");
				{
					auto state4 = serializer.objectBegin;
					scope(exit) serializer.objectEnd(state4);

					serializer.putEscapedKey("decart");
					{
						auto state5 = serializer.objectBegin;
						scope(exit) serializer.objectEnd(state5);

						serializer.putEscapedKey("x");
						serializer.putValue(pos.x);

						serializer.putEscapedKey("y");
						serializer.putValue(pos.y);

						serializer.putEscapedKey("z");
						serializer.putValue(pos.z);
					}

					serializer.putEscapedKey("error");
					{
						auto state5 = serializer.objectBegin;
						scope(exit) serializer.objectEnd(state5);

						serializer.putEscapedKey("x");
						serializer.putValue(pos_error.x);

						serializer.putEscapedKey("y");
						serializer.putValue(pos_error.y);

						serializer.putEscapedKey("z");
						serializer.putValue(pos_error.z);
					}

					serializer.putEscapedKey("state");
					serializer.putValue("Updated");
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

			serializer.putEscapedKey("velocity");
			{
				auto state4 = serializer.objectBegin;
				scope(exit) serializer.objectEnd(state4);

				serializer.putEscapedKey("decart");
				{
					auto state5 = serializer.objectBegin;
					scope(exit) serializer.objectEnd(state5);

					serializer.putEscapedKey("x");
					serializer.putValue(vel.x);

					serializer.putEscapedKey("y");
					serializer.putValue(vel.y);

					serializer.putEscapedKey("z");
					serializer.putValue(vel.z);
				}

				serializer.putEscapedKey("error");
				{
					auto state5 = serializer.objectBegin;
					scope(exit) serializer.objectEnd(state5);

					serializer.putEscapedKey("x");
					serializer.putValue("nan");

					serializer.putEscapedKey("y");
					serializer.putValue("nan");

					serializer.putEscapedKey("z");
					serializer.putValue("nan");
				}
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

auto calculateMse(vec3f origin, vec3f polar_mse, vec3f point) pure @nogc @safe
{
	auto vector = point - origin;
	const range = vector.magnitude;
	vector.normalize;

	import std.math : abs, tan, sin;
	import gfm.math : angleBetween;

	assert((abs(vector.x) > 0) || (abs(vector.y) > 0));

	float x = range*sin(polar_mse.x);
	float y = polar_mse.y;
	float xy = vector.y/vector.x;

	return vec3f(x, y, xy);
}

auto generateRData(RDataSourceRange)(Movable[] movables, RDataSourceRange dsources) nothrow
{
	RDataPoint[] points;

	try
	{
		foreach(int trk, ref m; movables)
		{
			foreach(ref s; dsources)
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
						import std.math : PI;
						const mse = calculateMse(s.pos0, s.error, r[0]);
						points ~= RDataPoint(s.id, trk+1, r[0], mse, r[1], curr_t);
						delta = base_delta;
					}
					grad_is_positive = new_grad_is_positive;
					curr_d = d;
					curr_t += delta;
				}
			}
		}
	}
	catch(Exception e)
	{

	}

	return points;
}