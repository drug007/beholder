module mainsimulator;

import common : Parent, Simulator;

import gldata : Vertex;
import gfm.math : vec3f, vec4f;
import std.math : PI;

interface MotionModel
{
	import std.datetime : Duration;

	void update(ref Movable m, Duration duration);
}

class LinearMotionModel : MotionModel
{
	import std.datetime : Duration;

	void update(ref Movable m, Duration duration)
	{
		m.pos += m.vel * duration.total!"hnsecs" / 10_000_000.0;
		m.vel += m.acc;
	}
}

class CircleMotionModel : MotionModel
{
	import std.datetime : Duration;

	void update(ref Movable m, Duration duration)
	{
		auto t = duration.total!"hnsecs" / 10_000_000.0;
		m.pos += m.vel * t;

		import gfm.math;
		auto rot = mat3x3f.rotation(2*PI/120.0 * t, vec3f(0, 0, 1));
		m.vel = rot * m.vel;
	}
}

static LinearMotionModel linearMotionModel;
static CircleMotionModel circleMotionModel;

static this()
{
	linearMotionModel = new LinearMotionModel();
	circleMotionModel = new CircleMotionModel();
}

Dg linear = delegate(vec3f f, vec3f t, float tt)
{
	return f + (t-f)*tt;
};

Dg circular = delegate(vec3f f, vec3f t, float tt)
{
	auto radius = vec3f(0, 1000, 0);
	auto center = vec3f( 7899+10_000, -9615 - 1_000, 0);
	auto velocity = 2 * PI / 1;

	import gfm.math;
	auto rot = mat3f.rotateZ(-velocity * tt);

	return center + rot * radius;
};

struct Movable
{
	import std.datetime : Duration;

	vec3f pos;
	vec3f vel;
	vec3f acc;

	Timeline tl;

	this(Timepoint[] points)
	{
		this.pos = vec3f(0, 0, 0);
		this.vel = vec3f(0, 0, 0);
		this.acc = vec3f(0, 0, 0);

		tl = Timeline(points);
	}

	void update(Duration duration)
	{
		auto new_pos = tl.update(duration);
		auto new_vel = new_pos - pos;
		if (new_vel.squaredMagnitude)
			vel = new_vel;
		else
			tl.clear;
		pos = new_pos;
	}
}

class MainSimulator : Simulator
{
	import trackrenderer : TrackRenderer;

	this(Parent parent, TrackRenderer track_renderer)
	{
		import std.array : uninitializedArray;

		_movables = uninitializedArray!(typeof(_movables))(10);
		version(none)
		{
			foreach(ref e; _movables)
			{
				import std.random : uniform;
				enum loPos = -10_000, hiPos = 10_000;
				enum loVel = -200, hiVel = 200;
				e.pos = vec3f(
					uniform(loPos, hiPos),
					uniform(loPos, hiPos),
					0
				);
				e.vel = vec3f(
					uniform(loVel, hiVel),
					uniform(loVel, hiVel),
					0
				);
			}
		}
		else
		{
			// fix values to get deterministic value for debugging
			_movables[0] = Movable([
				Timepoint(vec3f( 7899, -9615, 0), SysTime(         0), null),
				Timepoint(vec3f(-8462,  8537, 0), SysTime(30_000_000), null),
				Timepoint(vec3f(-5649,  9994, 0), SysTime(60_000_000), null),
			]);
			_movables[1] = Movable([
				Timepoint(vec3f(-8462,  8537, 0), SysTime(10_000_000), null),
				Timepoint(vec3f(-5649,  9994, 0), SysTime(40_000_000), null),
				Timepoint(vec3f( 9818,  7221, 0), SysTime(70_000_000), null),
			]);
			_movables[2] = Movable([
				Timepoint(vec3f(-5649,  9994, 0), SysTime(10_000_000), null),
				Timepoint(vec3f( 9818,  7221, 0), SysTime(40_000_000), null),
				Timepoint(vec3f( 6059, -5893, 0), SysTime(70_000_000), null),
			]);
			_movables[3] = Movable([
				Timepoint(vec3f( 9818,  7221, 0), SysTime(10_000_000), null),
				Timepoint(vec3f( 6059, -5893, 0), SysTime(40_000_000), null),
				Timepoint(vec3f( 6723,  -595, 0), SysTime(70_000_000), null),
			]);
			_movables[4] = Movable([
				Timepoint(vec3f( 6059, -5893, 0), SysTime(10_000_000), null),
				Timepoint(vec3f( 6723,  -595, 0), SysTime(40_000_000), null),
				Timepoint(vec3f(-8651,  3537, 0), SysTime(70_000_000), null),
			]);
			_movables[5] = Movable([
				Timepoint(vec3f( 6723,  -595, 0), SysTime(10_000_000), null),
				Timepoint(vec3f(-8651,  3537, 0), SysTime(40_000_000), null),
				Timepoint(vec3f( 5605, -5733, 0), SysTime(70_000_000), null),
			]);
			_movables[6] = Movable([
				Timepoint(vec3f(-8651,  3537, 0), SysTime(10_000_000), null),
				Timepoint(vec3f( 5605, -5733, 0), SysTime(40_000_000), null),
				Timepoint(vec3f(-6263,  5981, 0), SysTime(70_000_000), null),
			]);
			_movables[7] = Movable([
				Timepoint(vec3f( 5605, -5733, 0), SysTime(10_000_000), null),
				Timepoint(vec3f(-6263,  5981, 0), SysTime(40_000_000), null),
				Timepoint(vec3f( 8599, -2917, 0), SysTime(70_000_000), null),
			]);
			_movables[8] = Movable([
				Timepoint(vec3f(-6263,  5981, 0), SysTime(10_000_000), null),
				Timepoint(vec3f( 8599, -2917, 0), SysTime(40_000_000), null),
				Timepoint(vec3f(-8462,  8537, 0), SysTime(70_000_000), null),
			]);
			_movables[9] = Movable([
				Timepoint(vec3f( 8599, -2917, 0), SysTime(10_000_000), null),
				Timepoint(vec3f(-8462,  8537, 0), SysTime(40_000_000), null),
				Timepoint(vec3f(-5649,  9994, 0), SysTime(70_000_000), null),
			]);
		}

		_vertices = uninitializedArray!(typeof(_vertices))(_movables.length);

		updateVertices;
		updateIndices;

		_track_renderer = track_renderer;
		_track_renderer.update(_vertices, _indices);

		parent.addSimulator(this);
	}

	void startSimulation(SysTime start)
	{
		_old_timestamp = start;
	}

	void stopSimulation()
	{
		_old_timestamp = SysTime(0);
	}

	void onSimulation(const SysTime timestamp)
	{
		if (_old_timestamp == SysTime(0))
			// simulation is off (TODO isn't it excess checking?)
			return;

		import std.exception : enforce;
		enforce(timestamp >= _old_timestamp);

		if (_old_timestamp == timestamp)
			return;

		auto delta = (timestamp - _old_timestamp);
		foreach(ref m; _movables)
			m.update(delta);
		_old_timestamp += delta;

		updateVertices;
		_track_renderer.update(_vertices, _indices);
	}

private:
	import std.datetime : SysTime;

	Vertex[] _vertices;
	uint[] _indices;
	TrackRenderer _track_renderer;

	Movable[] _movables;
	SysTime _old_timestamp;

	void updateVertices()
	{
		import std.range : iota;
		import std.array : array;
		import color_table : ColorTable;
		auto c = cast(uint) _movables.length;
		auto color = ColorTable(c.iota.array);

		import std.range : lockstep;
		uint clr_idx;
		foreach(ref m, ref v; lockstep(_movables, _vertices))
		{
			import std.math : atan2;
			vec4f clr = void;
			auto tmp = color(clr_idx++);
			clr.r = tmp.r;
			clr.g = tmp.g;
			clr.b = tmp.b;
			clr.a = 1;
			v = Vertex(m.pos, clr, atan2(m.vel.y, m.vel.x));
		}
	}

	void updateIndices()
	{
		import std.array : array;
		import std.range : iota;
		import std.conv : castFrom;

		_indices = castFrom!ulong.to!uint(_vertices.length).iota.array;
	}
}

import std.datetime : SysTime, Duration, UTC;
alias Dg = vec3f delegate(vec3f f, vec3f t, float t);

struct Timepoint
{
	vec3f pos;
	SysTime timestamp;
	Dg dg;
}

struct Timeline
{
	import mir.algorithm.iteration: all;
	import mir.math.common: approxEqual;
	import mir.ndslice.slice: Slice, sliced, mir_slice_kind;
	import mir.ndslice.topology: vmap, MapIterator;
	import mir.interpolate.spline;
	import mir.interpolate.pchip;
	import mir.functional: naryFun;

	import std.algorithm : map;
	import std.array : array;
	import std.traits : ReturnType;

	import gfm.math : Vector;

	import std.container.array : Array;
	private Array!Timepoint _points;
	private SysTime _curr_time;
	private vec3f _curr_value;
	private int _curr_segment;

	float[] _t, _x, _y;
	alias S = typeof(pchip!float(_t.idup.sliced, _x.idup.sliced));
	S sx, sy;

	this(Timepoint[] points)
	{
		_curr_time = SysTime(0, UTC());
		_points.clear;
		_points = points;
		_t = _points[].map!"cast(float)a.timestamp.stdTime".array;
		_x = _points[].map!"a.pos.x".array;
		_y = _points[].map!"a.pos.y".array;

		auto t = _t.idup.sliced;
		auto x = _x.idup.sliced;
		auto y = _y.idup.sliced;
		sx = pchip!float(t, x);//, SplineBoundaryType.secondDerivative);
		sy = pchip!float(t, y);
	}

	auto start() const
	{
		assert(_points.length > 0);
		return _points[0].timestamp;
	}

	auto finish() const
	{
		assert(_points.length > 1);
		return _points[$-1].timestamp;
	}

	auto currTime() const
	{
		return _curr_time;
	}

	auto currValue() const
	{
		return _curr_value;
	}

	auto clear()
	{
		_curr_segment = 0;
		_curr_time = SysTime(0, UTC());
		update(Duration.zero);
	}

	auto update(Duration d)
	{
		auto new_timestamp = _curr_time + d;
		if (new_timestamp > finish)
			return _curr_value;

		auto new_x = [cast(float)new_timestamp.stdTime].vmap(sx).front;
		auto new_y = [cast(float)new_timestamp.stdTime].vmap(sy).front;

		_curr_value = vec3f(new_x, new_y, 0);
		_curr_time = new_timestamp;
		return _curr_value;
	}
}
