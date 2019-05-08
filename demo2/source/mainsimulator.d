module mainsimulator;

import common : Simulator;

import gfm.math : vec3f, vec4f;
import std.math : PI;

struct Movable
{
	import std.typecons : tuple, Tuple;

	private Tuple!(vec3f, vec3f) _state;
	private SysTime _curr_timestamp;
	Timeline tl;
	uint id;

	this(uint id, Timepoint[] points)
	{
		this.id = id;
		tl = Timeline(points);
	}

	void reset()
	{
		_state = tuple(vec3f(), vec3f());
		_curr_timestamp = SysTime();
	}

	void update(SysTime ts)
	{
		_state = calculate(ts);
		_curr_timestamp = ts;
	}

	auto calculate(SysTime ts) const nothrow @safe
	{
		return tl.calculate(ts);
	}

	@property
	auto pos() const nothrow @nogc @safe
	{
		return _state[0];
	}

	@property
	auto vel() const nothrow @nogc @safe
	{
		return _state[1];
	}
}

struct RDataSource
{
	uint id;
	vec3f pos0, pos;
	float phi0, angle_speed, phi, range;
	SysTime start_timestamp, finish_timestamp, curr_timestamp;
	vec3f error;

	this(uint id, vec3f pos, float r, float p0, float as, vec3f error, SysTime st, SysTime ft)
	{
		this.id = id;
		this.pos0 = pos;
		this.range = r;
		this.phi0 = p0;
		this.angle_speed = as;
		this.error = error;
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

	auto beamPosition(SysTime ts) const nothrow @safe
	{
		if (ts < start_timestamp ||
		    ts >= finish_timestamp)
		{
			return vec3f();
		}

		auto phi = phi0 + angle_speed * (ts - start_timestamp).total!"hnsecs"/1e7;
		import std.math : sin, cos;
		return pos0 + range*vec3f(cos(phi), -sin(phi), 0);
	}

	void serialize(S)(ref S serializer) const
	{
		import std.format : sformat;
		char[8] buffer;
		auto str = sformat(buffer[], "%d", id);
		
		serializer.putEscapedKey(str);
		auto s2 = serializer.objectBegin;
		scope(exit) serializer.objectEnd(s2);
		
		serializer.putEscapedKey("update_period");
		serializer.putValue(2*PI/angle_speed);
		
		serializer.putEscapedKey("polar_mse");
		{
			auto s3 = serializer.objectBegin;
			scope(exit) serializer.objectEnd(s3);

			serializer.putEscapedKey("x");
			serializer.putValue(error.x);

			serializer.putEscapedKey("y");
			serializer.putValue(error.y);

			serializer.putEscapedKey("z");
			serializer.putValue("nan");
		}
		
		serializer.putEscapedKey("elevation_error_kind");
		serializer.putValue("Polar");
		
		serializer.putEscapedKey("hierarchy_kind");
		serializer.putValue("Subordinate");

		serializer.putEscapedKey("position");
		{
			auto s3 = serializer.objectBegin;
			scope(exit) serializer.objectEnd(s3);

			serializer.putEscapedKey("x");
			serializer.putValue(pos0.x);

			serializer.putEscapedKey("y");
			serializer.putValue(pos0.y);

			serializer.putEscapedKey("z");
			serializer.putValue(pos0.z);
		}
		
		serializer.putEscapedKey("lag");
		serializer.putNumberValue(0);
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
			_movables ~= Movable(
				44, [
				Timepoint(vec3f( -3899, -9615, 0), SysTime(          0)),
				Timepoint(vec3f(-33462, 25537, 0), SysTime(180_000_000)),
				Timepoint(vec3f(-39649, 39994, 0), SysTime(360_000_000)),
				Timepoint(vec3f(-78649, 80994, 0), SysTime(720_000_000)),
			]);
			_movables ~= Movable(
				64, [
				Timepoint(vec3f(-8462,  8537, 0), SysTime(130_000_000)),
				Timepoint(vec3f(-5649,  9994, 0), SysTime(230_000_000)),
				Timepoint(vec3f( 9818,  7221, 0), SysTime(330_000_000)),
			]);
			_movables ~= Movable(
				65, [
				Timepoint(vec3f(-5649,  9994, 0), SysTime(120_000_000)),
				Timepoint(vec3f( 9818,  7221, 0), SysTime(240_000_000)),
				Timepoint(vec3f( 6059, -5893, 0), SysTime(350_000_000)),
			]);
			_movables ~= Movable(
				18, [
				Timepoint(vec3f( 9818,  7221, 0), SysTime(130_000_000)),
				Timepoint(vec3f( 6059, -5893, 0), SysTime(160_000_000)),
				Timepoint(vec3f( 6723,  -595, 0), SysTime(190_000_000)),
			]);
			_movables ~= Movable(
				19, [
				Timepoint(vec3f( 6059, -5893, 0), SysTime(130_000_000)),
				Timepoint(vec3f( 6723,  -595, 0), SysTime(160_000_000)),
				Timepoint(vec3f(-8651,  3537, 0), SysTime(190_000_000)),
			]);
			_movables ~= Movable(
				20, [
				Timepoint(vec3f( 6723,  -595, 0), SysTime(130_000_000)),
				Timepoint(vec3f(-8651,  3537, 0), SysTime(160_000_000)),
				Timepoint(vec3f( 5605, -5733, 0), SysTime(190_000_000)),
			]);
			_movables ~= Movable(
				113, [
				Timepoint(vec3f(-8651,  3537, 0), SysTime(30_000_000)),
				Timepoint(vec3f( 5605, -5733, 0), SysTime(60_000_000)),
				Timepoint(vec3f(-6263,  5981, 0), SysTime(90_000_000)),
			]);
			_movables ~= Movable(
				234, [
				Timepoint(vec3f( 5605, -5733, 0), SysTime(30_000_000)),
				Timepoint(vec3f(-6263,  5981, 0), SysTime(60_000_000)),
				Timepoint(vec3f( 8599, -2917, 0), SysTime(90_000_000)),
			]);
			_movables ~= Movable(
				235, [
				Timepoint(vec3f(-6263,  5981, 0), SysTime(30_000_000)),
				Timepoint(vec3f( 8599, -2917, 0), SysTime(60_000_000)),
				Timepoint(vec3f(-8462,  8537, 0), SysTime(90_000_000)),
			]);
			_movables ~= Movable(
				236, [
				Timepoint(vec3f( 8599, -2917, 0), SysTime(30_000_000)),
				Timepoint(vec3f(-8462,  8537, 0), SysTime(60_000_000)),
				Timepoint(vec3f(-5649,  9994, 0), SysTime(90_000_000)),
			]);
		}

		{
			_sources[100] = RDataSource(
				100, vec3f( 7000, -9000, 0), 400_000,  0, 2*PI / 10, vec3f(1.8*PI/180, 400, float.nan), SysTime(         0), SysTime(360_000_000)
			);
			_sources[301] = RDataSource(
				301, vec3f(-8000,  18000, 0), 700_000, PI/3, 2*PI / 10, vec3f(8*PI/180, 800, float.nan), SysTime(30_000_000), SysTime(390_000_000)
			);
			_sources[202] = RDataSource(
				202, vec3f(-42000,  -9000, 0), 150_000,  0, 2*PI / 5, vec3f(4*PI/180, 300, float.nan), SysTime(30_000_000), SysTime(390_000_000)
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

		_track_renderer2 = new ErrorRenderer(gl, parent.camera);
		parent.addRenderer(_track_renderer2);
		_track_renderer2.update(_track_vertices, _track_indices);

		_track_renderer = new TrackRenderer(gl, parent.camera);
		parent.addRenderer(_track_renderer);
		_track_renderer.update(_track_vertices, _track_indices);

		_source_renderer = new RDataSourceRenderer(gl, parent.camera);
		parent.addRenderer(_source_renderer);
		_source_renderer.update(_source_vertices, _source_indices);

		_auxinfo_renderer = new AuxInfoRenderer(gl, parent.camera);
		parent.addRenderer(_auxinfo_renderer);
	}

	void onSimulation(SysTime new_timestamp, ray3f ray)
	{
		foreach(ref m; _movables)
			m.update(new_timestamp);
		
		foreach(ref s; _sources)
			s.update(new_timestamp);

		updateVertices;
		updateRDataIndices(new_timestamp);
		_track_renderer.update(_track_vertices, _track_indices);
		_source_renderer.update(_source_vertices, _source_indices);

		// auto r = updateAuxInfo(new_timestamp, ray);
		// _auxinfo_renderer.update(r[0], r[1]);
	}

	auto rdataSource() const
	{
		return _sources;
	}

	void clearFinished()
	{
		foreach(ref m; _movables)
			m.tl.clear;

		onSimulation(SysTime(0), ray3f());
	}

	SysTime startTimestamp()
	{
		return _intervals[0].timestamp;
	}

	SysTime finishTimestamp()
	{
		return _intervals[$-1].timestamp;
	}

	auto generateRData()
	{
		import std.parallelism : task, taskPool;
		import rdata_generator : generateRData;
		
		auto t = task!generateRData(_movables, _sources);
		taskPool.put(t);
		_rdata_points = t.yieldForce;

		return _rdata_points;
	}

	auto resetRData()
	{
		_track_renderer2.reset;
	}

private:
	import std.datetime : SysTime;
	import gfm.opengl : OpenGL;
	import gfm.math : ray3f;
	import timestamp_storage : TimestampStorage;
	import trackrenderer : TrackRenderer, TrackVertex = Vertex;
	import error_renderer : ErrorRenderer;
	import sourcerenderer : RDataSourceRenderer, SourceVertex = Vertex;
	import auxinforenderer : AuxInfoRenderer, AuxInfoVertex = Vertex;
	import rdata_generator : RDataPoint;

	TrackVertex[] _track_vertices;
	SourceVertex[] _source_vertices;
	AuxInfoVertex[] _auxinfo_vertices;
	uint[] _track_indices, _source_indices, _auxinfo_indices;
	TrackRenderer _track_renderer;
	ErrorRenderer _track_renderer2;
	RDataSourceRenderer _source_renderer;
	AuxInfoRenderer _auxinfo_renderer;

	Movable[] _movables;
	RDataSource[uint] _sources;
	Entry[] _intervals;
	TimestampStorage _ts_storage;
	RDataPoint[] _rdata_points;

	void updateVertices()
	{
		import std.range : iota;
		import std.array : array;
		import beholder.color_table : ColorTable;
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
			v = TrackVertex(m.pos, clr, m.vel);
		}

		clr_idx = 0;
		foreach(ref s, ref v; lockstep(_sources.byValue, _source_vertices))
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

	auto updateAuxInfo(SysTime ts, ray3f ray)
	{
		import auxinforenderer : Vertex;
		Vertex[] vertices;
		foreach(ref s; _sources)
		{
			foreach(ref m; _movables)
			{
				vertices ~= Vertex(m.pos, vec4f(1, 0, 0, 1));
				vertices ~= Vertex(s.beamPosition(ts), vec4f(1, 0, 0, 1));
			}
		}

		import std.typecons : tuple;
		import std.array : array;
		import std.range : iota;
		return tuple(vertices, (cast(uint)vertices.length).iota.array);
	}

	void updateIndices()
	{
		import std.array : array;
		import std.range : iota;
		import std.conv : castFrom;

		_track_indices.length = _track_vertices.length;
		import std.algorithm : copy;
		copy(castFrom!ulong.to!uint(_track_vertices.length).iota, _track_indices);

		_source_indices.length = _source_vertices.length;
		import std.algorithm : copy;
		copy(castFrom!ulong.to!uint(_source_vertices.length).iota, _source_indices);

		_auxinfo_indices.length = _auxinfo_vertices.length;
		import std.algorithm : copy;
		copy(castFrom!ulong.to!uint(_auxinfo_vertices.length).iota, _auxinfo_indices);
	}

	void updateRDataIndices(SysTime timestamp)
	{
		import std.algorithm : map;
		import std.array : array;
		import std.conv : castFrom;
		import std.range : iota;
		import error_renderer : Vertex;
		import beholder.color_table : ColorTable;

		if (_rdata_points.length == 0)
			return;

		auto c = cast(uint) _movables.length;
		auto color = ColorTable(c.iota.array);

		static convert(C)(C c)
		{
			return vec4f(c.r, c.g, c.b, 1.0);
		}

		static convertError(V)(V v)
		{
			import std.math : atan;
			import gfm.math : mat3f;
			const angle = atan(v.z);
			const m = mat3f.rotateZ(angle);
			const tangent = m * vec3f(v.x,   0, 0);
			const radial  = m * vec3f(  0, v.y, 0);
			return vec4f(tangent.xy, radial.xy);
		}

		auto track_vertices = _rdata_points.map!(p=>Vertex(p.pos, convertError(p.pos_error), convert(color(p.source)), p.vel));
		uint[] track_indices;
		track_indices.reserve(track_vertices.length);
		int i;
		foreach(ref p; _rdata_points)
		{
			import std.datetime : seconds;
			if (timestamp - 5.seconds < p.timestamp && p.timestamp <= timestamp)
				track_indices ~= i;
			i++;
		}

		_track_renderer2.update(track_vertices, track_indices);
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
	import std.typecons : Tuple;
	import mir.ndslice.slice: sliced;
	import mir.interpolate.pchip : pchip;

	import std.algorithm : map;
	import std.array : array;

	import std.container.array : Array;
	private Array!Timepoint _points;
	private Tuple!(vec3f, vec3f) _state;

	alias Interpolator = typeof(pchip!float((float[]).init.idup.sliced, (float[]).init.sliced));
	Interpolator sx, sy;

	this(Timepoint[] points)
	{
		_points = points;
		auto t = _points[].map!"cast(float)a.timestamp.stdTime".array.idup.sliced;
		auto x = _points[].map!"a.pos.x".array.sliced;
		auto y = _points[].map!"a.pos.y".array.sliced;

		sx = pchip!float(t, x);
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

	auto value() const nothrow @nogc @safe
	{
		return _state[0];
	}

	auto derivative() const nothrow @nogc @safe
	{
		return _state[1];
	}

	auto clear()
	{
		_state = typeof(_state)();
	}

	auto points() const
	{
		return _points;
	}

	auto update(SysTime ts)
	{
		_state = calculate(ts);
	}

	auto calculate(SysTime ts) const nothrow @safe
	{
		import std.typecons : tuple;
		if (ts < start ||
		    ts >= finish) 
			return tuple(vec3f(), vec3f());

		auto new_x = sx.withDerivative(ts.stdTime);
		auto new_y = sy.withDerivative(ts.stdTime);

		return tuple(vec3f(new_x[0], new_y[0], 0),
					 vec3f(new_x[1]*1e7, new_y[1]*1e7, 0));
	}
}
