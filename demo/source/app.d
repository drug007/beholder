import asdf;
import beholder : Beholder, PointC2f;

import std.concurrency;

struct Target
{
    struct Id
    {
        uint source, target;
    }

    Id id;
    PointC2f position;
    ulong    timestamp;

    static auto fromAsdf(Asdf)(ref Asdf asdf)
    {
        import std.datetime : SysTime;

        Target tgt;

        tgt.id.source = cast(uint) asdf["id"]["source"];
        tgt.id.target = cast(uint) asdf["id"]["target"];
        tgt.position.x = cast(float) asdf["position"]["x"];
        tgt.position.y = cast(float) asdf["position"]["y"];
        tgt.timestamp = SysTime.fromISOExtString(cast(string) asdf["timestamp"]).stdTime;

        return tgt;
    }
}

struct Vertex
{
	import gfm.math : vec3f, vec4f;

	vec3f position;
	vec4f color;
}

struct Stage
{
	import beholder.renderables.polyline : Polyline;

	import gfm.math : vec3f, vec4f;

	alias TargetIndex = uint;

	enum PrimitiveRestartIndex = 0xFFFF;

@safe:
	Target[] targets;
	TargetIndex[][typeof(Target.Id.source)] tracks;
	Beholder* beholder;
	Polyline polyline;

	@disable this();

	this(ref Beholder beholder) @trusted
	{
		this.beholder = &beholder;

		import gfm.math : vec3f;
		import beholder.vertex_data.vertex_data;
		import beholder.vertex_data.vertex_spec;
		import beholder.draw_state;
		import beholder.context : Context;

        import beholder.render_state.render_state : RenderState;

        auto renderState = RenderState();
		renderState.primitiveRestart.enabled = true;
		renderState.primitiveRestart.index = PrimitiveRestartIndex;

        const program_source =
				"#version 330 core

				#if VERTEX_SHADER
				layout(location = 0) in vec3 position;
				layout(location = 1) in vec4 color;
				out vec4 vColor;
				uniform mat4 mvp_matrix;
				void main()
				{
					gl_Position = mvp_matrix * vec4(position.xyz, 1.0);
					vColor = color;
				}
				#endif

				#if FRAGMENT_SHADER
				in vec4 vColor;
				out vec4 color_out;

				void main()
				{
					color_out = vColor;
				}
				#endif
			";

		auto program = Context.makeProgram(program_source);

        auto vertexSpec = new VertexSpec!Vertex(program);
		auto vertexData = new VertexData(
			vertexSpec,
			[Vertex(vec3f(0, 0, 0), vec4f(0, 0, 0, 0))],
			[0u]
		);
		polyline = new Polyline(renderState, program, vertexData);
        this.beholder.renderable ~= polyline;
	}

	void addTargets(Target[] targets) @trusted
	{
		foreach(t; targets)
		{
			this.targets ~= t;

			import std : castFrom;
			assert(this.targets.length);
			tracks[t.id.source] ~= castFrom!ulong.to!TargetIndex(this.targets.length - 1);
		}

		if (!this.targets.length)
			return;

		import std.algorithm : map;
		import std.range : iota;
		import std.array : array;
		auto newData = this.targets.map!(tgt=>Vertex(vec3f(tgt.position.x, tgt.position.y, 0), vec4f(tgt.id.source == 17 ? 0.9 : 0, 0.6, 0.7, 1))).array;
		polyline.drawState.vertexData.vbo.setData(newData);

		TargetIndex[] indices;
		foreach (track; tracks)
		{
			if (track.length > 1)
				indices ~= track ~ PrimitiveRestartIndex;
		}

		polyline.drawState.vertexData.ibo.setData(indices);
		
		polyline.visible = true;
	}
}

alias DataChunk = shared(const(Target))[];

int main(string[] args) @safe
{
	import std.datetime : msecs;
	import std.file : exists;

	if (args.length < 2)
	{
		import std : writefln, baseName;
		writefln("Usage:\n\t%s filename", baseName(args[0]));
		return 1;
	}

	const filename = args[1];
	if (!filename.exists)
	{
		import std : writeln;
		writeln("File ", filename, " does not exist");
		return 2;
	}

	scope beholder = new Beholder(1000, 800, "Demo");
	auto stage = Stage(beholder);

	() @trusted {
		spawn(&loadData, thisTid, filename);

		beholder.onBeforeLoopStart = () @trusted {
			receiveTimeout(0.msecs, (DataChunk p) {
				stage.addTargets(cast(Target[]) p);
			});
		};
	} ();

	beholder.run();

	return 0;
}

void loadData(Tid ownerTid, string filename)
{
	import std.algorithm : max;
	import std.concurrency : send;
	import std.datetime : msecs;
	import std.file : readText;
	import std.stdio : writefln;

	import core.thread : Thread;

	auto txt = readText(filename);
	auto json = txt.parseJson;
	auto data = cast(DataChunk) jsonToData(json);

	const total = 10;
	const step = max(data.length / total, 1);
	size_t i = step;
	for(; i < data.length; i += step)
	{
		writefln("sent %s..%s", i-step, i);
		send(ownerTid, data[i - step..i]);
		Thread.sleep(1000.msecs);
	}
	writefln("sent %s..%s", i-step, data.length);
	send(ownerTid, data[i-step..$]);
}

auto jsonToData(ref Asdf json) @trusted
{

	Target[] targets;
	foreach(record; json.byElement)
	{
		auto kj = record["kind"];
		if (kj == Asdf.init)
			continue;

		const kind = cast(string) kj;
		switch (kind)
		{
			case "Target":
				targets ~= Target.fromAsdf(record);
			break;
			default:
		}
	}
	return targets;
}