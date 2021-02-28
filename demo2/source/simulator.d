module simulator;

import std.math : PI;
import std.datetime : SysTime, Clock, seconds;
import std.typecons : Tuple;
import vecs;
import gfm.math;

import trackrenderer : TrackVertex = Vertex;
import sourcerenderer : RadarVertex = Vertex;

struct Position
{
	vec2f value;

	alias value this;

	this(Args...)(Args args)
	{
		value = vec2f(args);
	}
}

struct Velocity
{
	vec2f value;

	alias value this;

	this(Args...)(Args args)
	{
		value = vec2f(args);
	}
}

struct BeamPosition
{
	vec2f origin, beam;

	this(vec2f o, vec2f b)
	{
		origin = o;
		beam   = b;
	}
}

struct RotationVelocity
{
	float value;

	alias value this;
}

struct LifeTime
{
	SysTime start_timestamp, last_timestamp;
}

class Simulator
{
	import std.datetime;

	private EntityManager em;
	private TrackVertex[] _track_vertices;
	private RadarVertex[] _source_vertices;

	auto trackVertices()
	{
		return _track_vertices;
	}

	auto trackIndices()
	{
		import std.range : iota;
		auto l = cast(uint) _track_vertices.length;
		return l.iota;
	}

	auto sourceVertices()
	{
		return _source_vertices;
	}

	auto sourceIndices()
	{
		import std.range : iota;
		auto l = cast(uint) _source_vertices.length;
		return l.iota;
	}

	this()
	{
		em = new EntityManager();
		init;
	}

	void init()
	{
		auto entities = em.entityBuilder()
			.gen(Position(3.0f, 6.0f), Velocity(-130.0, 60), LifeTime(Clock.currTime, Clock.currTime+5.seconds))
			.gen(Position(0.0f, 0.0f), Velocity(-121.0, 40), LifeTime(Clock.currTime, Clock.currTime+7.seconds))
			.gen(BeamPosition(vec2f(1000.0, 1000.0), vec2f(PI/2, 250_000)), RotationVelocity(2*PI/5), LifeTime(Clock.currTime, Clock.currTime+8.seconds))
			.get;
	}

	void onUpdate(Duration timeDelta)
	{
		systemObjectMoving(em.query!(Tuple!(Entity, Position,Velocity)));
		systemLifeTime(em.query!(Tuple!(Entity, LifeTime)));
		systemRadarRotating(em.query!(Tuple!(BeamPosition, RotationVelocity)), timeDelta);
	}

	void systemObjectMoving(Query!(Tuple!(Entity, Position, Velocity)) query)
	{
		_track_vertices.length = 0;
		foreach(ent, pos, vel; query)
		{
			pos.x += vel.x;
			pos.y += vel.y;

			_track_vertices ~= TrackVertex(
				vec3f(pos.x, pos.y, 0),
				vec4f(1, 0, 0, 1),
				vec3f(vel.x, vel.y, 0),
			);
		}
	}

	void systemRadarRotating(Query!(Tuple!(BeamPosition, RotationVelocity)) query, Duration timeDelta)
	{
		_source_vertices.length = 0;
		foreach(pos, vel; query)
		{
			pos.beam.x += *vel*timeDelta.total!"hnsecs"/1e7;

			_source_vertices ~= RadarVertex(
				vec3f(pos.origin, 0),
				vec4f(0.3, 0.3, 0.3, 1),
				pos.beam.x, // heading
				pos.beam.y, // range
			);
		}
	}

	void systemLifeTime(Query!(Tuple!(Entity, LifeTime)) query)
	{
		foreach(ent, lf; query)
		{
			if (Clock.currTime > lf.last_timestamp)
			{
				em.discard(ent);
			}
		}
	}
}