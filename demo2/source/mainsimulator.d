module mainsimulator;

import common : Simulator;

import gfm.math : vec3f, vec4f;
import std.math : PI;

struct Movable
{
	vec3f pos;
	vec3f vel;
	vec3f acc;

	Timeline tl;
	private SysTime curr_timestamp;

	this(Timepoint[] points)
	{
		tl = Timeline(points);
	}

	void reset()
	{
		vel = vec3f();
		pos = vec3f();
		acc = vec3f();
	}

	void update(SysTime ts)
	{
		if (ts < tl.start ||
		    ts >= tl.finish)
		{
			reset;
			return;
		}

		if (ts == curr_timestamp)
			return;

		auto old_ts = curr_timestamp;
		auto new_pos = tl.update(ts);
		vel = (new_pos - pos)/(ts - curr_timestamp).total!"hnsecs"/1e7;
		pos = new_pos;
		curr_timestamp = ts;
	}
}

struct RDataSource
{
	vec3f pos0, pos;
	float phi0, angle_speed, phi, range;
	SysTime start_timestamp, finish_timestamp, curr_timestamp;

	this(vec3f pos, float r, float p0, float as, SysTime st, SysTime ft)
	{
		this.pos0 = pos;
		this.range = r;
		this.phi0 = p0;
		this.angle_speed = as;
		this.phi = phi0;
		this.start_timestamp = st;
		this.finish_timestamp = ft;
		this.curr_timestamp = st;
	}

	void reset()
	{
		pos = vec3f();
	}

	void update(SysTime ts)
	{
		if (ts < start_timestamp ||
		    ts >= finish_timestamp)
		{
			reset;
			return;
		}

		pos = pos0;
		phi = phi0 + angle_speed * (ts - start_timestamp).total!"hnsecs"/1e7;
		curr_timestamp = ts;
	}
}

struct Entry
{
	uint interval_idx;
	ubyte point_idx;
	SysTime timestamp;
}

class MainSimulator : Simulator
{
	this(Parent)(OpenGL gl, Parent parent)
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
				Timepoint(vec3f( -3899, -9615, 0), SysTime(          0)),
				Timepoint(vec3f(-33462, 25537, 0), SysTime(180_000_000)),
				Timepoint(vec3f(-39649, 39994, 0), SysTime(360_000_000)),
				Timepoint(vec3f(-78649, 80994, 0), SysTime(720_000_000)),
			]);
			_movables[1] = Movable([
				Timepoint(vec3f(-8462,  8537, 0), SysTime(130_000_000)),
				Timepoint(vec3f(-5649,  9994, 0), SysTime(230_000_000)),
				Timepoint(vec3f( 9818,  7221, 0), SysTime(330_000_000)),
			]);
			_movables[2] = Movable([
				Timepoint(vec3f(-5649,  9994, 0), SysTime(120_000_000)),
				Timepoint(vec3f( 9818,  7221, 0), SysTime(240_000_000)),
				Timepoint(vec3f( 6059, -5893, 0), SysTime(350_000_000)),
			]);
			_movables[3] = Movable([
				Timepoint(vec3f( 9818,  7221, 0), SysTime(130_000_000)),
				Timepoint(vec3f( 6059, -5893, 0), SysTime(160_000_000)),
				Timepoint(vec3f( 6723,  -595, 0), SysTime(190_000_000)),
			]);
			_movables[4] = Movable([
				Timepoint(vec3f( 6059, -5893, 0), SysTime(130_000_000)),
				Timepoint(vec3f( 6723,  -595, 0), SysTime(160_000_000)),
				Timepoint(vec3f(-8651,  3537, 0), SysTime(190_000_000)),
			]);
			_movables[5] = Movable([
				Timepoint(vec3f( 6723,  -595, 0), SysTime(130_000_000)),
				Timepoint(vec3f(-8651,  3537, 0), SysTime(160_000_000)),
				Timepoint(vec3f( 5605, -5733, 0), SysTime(190_000_000)),
			]);
			_movables[6] = Movable([
				Timepoint(vec3f(-8651,  3537, 0), SysTime(30_000_000)),
				Timepoint(vec3f( 5605, -5733, 0), SysTime(60_000_000)),
				Timepoint(vec3f(-6263,  5981, 0), SysTime(90_000_000)),
			]);
			_movables[7] = Movable([
				Timepoint(vec3f( 5605, -5733, 0), SysTime(30_000_000)),
				Timepoint(vec3f(-6263,  5981, 0), SysTime(60_000_000)),
				Timepoint(vec3f( 8599, -2917, 0), SysTime(90_000_000)),
			]);
			_movables[8] = Movable([
				Timepoint(vec3f(-6263,  5981, 0), SysTime(30_000_000)),
				Timepoint(vec3f( 8599, -2917, 0), SysTime(60_000_000)),
				Timepoint(vec3f(-8462,  8537, 0), SysTime(90_000_000)),
			]);
			_movables[9] = Movable([
				Timepoint(vec3f( 8599, -2917, 0), SysTime(30_000_000)),
				Timepoint(vec3f(-8462,  8537, 0), SysTime(60_000_000)),
				Timepoint(vec3f(-5649,  9994, 0), SysTime(90_000_000)),
			]);
		}

		_sources = uninitializedArray!(typeof(_sources))(3);
		{
			_sources[0] = RDataSource(
				vec3f( 7000, -9000, 0), 200_000,  0, 2*PI / 10, SysTime(         0), SysTime(360_000_000)
			);
			_sources[1] = RDataSource(
				vec3f(-8000,  8000, 0), 400_000, PI/3, 2*PI / 10, SysTime(30_000_000), SysTime(390_000_000)
			);
			_sources[2] = RDataSource(
				vec3f(-5000,  9999, 0), 150_000,  0, 2*PI / 5, SysTime(30_000_000), SysTime(390_000_000)
			);
		}

		import std.array : appender;
		auto intervals = appender!(Entry[])();

		foreach(uint i, ref m; _movables)
		{
			ubyte j;
			foreach(ref p; m.tl.points)
			{
				intervals ~= Entry(i, j++, p.timestamp);
			}
		}

		foreach(uint i, ref s; _sources)
		{
			intervals ~= Entry(i, 0, s.start_timestamp);
			intervals ~= Entry(i, 1, s.finish_timestamp);
		}

		import std.algorithm : sort, map;
		_intervals = intervals.data;
		_intervals.sort!"a.timestamp < b.timestamp";

		_ts_storage.addTimestamps(_intervals.map!"a.timestamp.stdTime");

		_track_vertices = uninitializedArray!(typeof(_track_vertices))(_movables.length);
		_source_vertices = uninitializedArray!(typeof(_source_vertices))(_sources.length);

		updateVertices;
		updateIndices;

		_track_renderer = new TrackRenderer(gl, parent.camera);
		parent.addRenderer(_track_renderer);
		_track_renderer.update(_track_vertices, _track_indices);

		_source_renderer = new RDataSourceRenderer(gl, parent.camera);
		parent.addRenderer(_source_renderer);
		_source_renderer.update(_source_vertices, _source_indices);
	}

	void onSimulation(SysTime new_timestamp)
	{
		foreach(ref m; _movables)
			m.update(new_timestamp);
		
		foreach(ref s; _sources)
			s.update(new_timestamp);

		updateVertices;
		_track_renderer.update(_track_vertices, _track_indices);
		_source_renderer.update(_source_vertices, _source_indices);
	}

	void clearFinished()
	{
		foreach(ref m; _movables)
			m.tl.clear;

		onSimulation(SysTime(0));
	}

	SysTime startTimestamp()
	{
		return _intervals[0].timestamp;
	}

	SysTime finishTimestamp()
	{
		return _intervals[$-1].timestamp;
	}

private:
	import std.datetime : SysTime;
	import gfm.opengl : OpenGL;
	import timestamp_storage : TimestampStorage;
	import trackrenderer : TrackRenderer, TrackVertex = Vertex;
	import sourcerenderer : RDataSourceRenderer, SourceVertex = Vertex;

	TrackVertex[] _track_vertices;
	SourceVertex[] _source_vertices;
	uint[] _track_indices, _source_indices;
	TrackRenderer _track_renderer;
	RDataSourceRenderer _source_renderer;

	Movable[] _movables;
	RDataSource[] _sources;
	Entry[] _intervals;
	TimestampStorage _ts_storage;

	void updateVertices()
	{
		import std.range : iota;
		import std.array : array;
		import color_table : ColorTable;
		auto c = cast(uint) _movables.length;
		auto color = ColorTable(c.iota.array);

		import std.range : lockstep;
		uint clr_idx;
		foreach(ref m, ref v; lockstep(_movables, _track_vertices))
		{
			import std.math : atan2;
			vec4f clr = void;
			auto tmp = color(clr_idx++);
			clr.r = tmp.r;
			clr.g = tmp.g;
			clr.b = tmp.b;
			clr.a = 1;
			v = TrackVertex(m.pos, clr, atan2(m.vel.y, m.vel.x));
		}

		clr_idx = 0;
		foreach(ref s, ref v; lockstep(_sources, _source_vertices))
		{
			import std.math : atan2;
			vec4f clr = void;
			auto tmp = color(clr_idx++);
version(all)
{
			clr.r = 0.7;
			clr.g = 0.7;
			clr.b = 0.7;
			clr.a = 1;
}
else
{
			clr.r = tmp.r;
			clr.g = tmp.g;
			clr.b = tmp.b;
			clr.a = 1;
}
			v = SourceVertex(s.pos, clr, s.phi, s.range);
		}
	}

	void updateIndices()
	{
		import std.array : array;
		import std.range : iota;
		import std.conv : castFrom;

		_track_indices.length = _track_vertices.length;
		import std.algorithm : copy;
		copy(castFrom!ulong.to!uint(_track_vertices.length).iota, _track_indices);

		_source_indices.length = _track_vertices.length;
		import std.algorithm : copy;
		copy(castFrom!ulong.to!uint(_track_vertices.length).iota, _source_indices);
	}
}

import std.datetime : SysTime;

struct Timepoint
{
	vec3f pos;
	SysTime timestamp;
}

struct Timeline
{
	import mir.algorithm.iteration: all;
	import mir.math.common: approxEqual;
	import mir.ndslice.slice: Slice, sliced, mir_slice_kind;
	import mir.ndslice.topology: vmap;
	import mir.ndslice.iterator : MapIterator;
	import mir.interpolate.spline;
	import mir.interpolate.pchip;
	import mir.functional: naryFun;

	import std.algorithm : map;
	import std.array : array;
	import std.traits : ReturnType;

	import gfm.math : Vector;

	import std.container.array : Array;
	private Array!Timepoint _points;
	private vec3f _curr_value;

	float[] _t, _x, _y;
	alias S = typeof(pchip!float(_t.idup.sliced, _x.idup.sliced));
	S sx, sy;

	this(Timepoint[] points)
	{
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

	auto currValue() const
	{
		return _curr_value;
	}

	auto clear()
	{
		_curr_value = _curr_value.init;
		update(SysTime(0));
	}

	auto points() const
	{
		return _points;
	}

	auto update(SysTime new_timestamp)
	{
		if (new_timestamp < start ||
		    new_timestamp >= finish) 
			return _curr_value;

		auto new_x = [cast(float)new_timestamp.stdTime].vmap(sx).front;
		auto new_y = [cast(float)new_timestamp.stdTime].vmap(sy).front;

		_curr_value = vec3f(new_x, new_y, 0);
		return _curr_value;
	}
}
