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

// Textured vertex
struct TVertex
{
	import gfm.math : vec2f, vec3f, vec4f;

	vec3f position;
	vec4f color;
	vec2f texCoord;
}

struct Stage
{
	import beholder.renderables.polylines : Polylines;
	import beholder.renderables.points : Points;
	import beholder.renderables.billboard : Billboard;

	import gfm.math : vec2f, vec3f, vec4f;

	alias TargetIndex = uint;

	enum PrimitiveRestartIndex = 0xFFFF;

@safe:
	import std.datetime : Duration, SysTime;

	Target[] targets;
	TargetIndex[][typeof(Target.Id.source)] tracks;
	Beholder* beholder;
	Polylines polylines;
	Points    points;
	Billboard billboard;
	SysTime   lastScanTimestamp;

	@disable this();

	this(ref Beholder beholder) @trusted
	{
		this.beholder = &beholder;

		import gfm.math : vec3f;
		import beholder.vertex_data.vertex_data;
		import beholder.vertex_data.vertex_spec;
		import beholder.draw_state;

        import beholder.render_state.render_state : RenderState;

        auto renderState = RenderState();
		renderState.primitiveRestart.enabled = true;
		renderState.primitiveRestart.index = PrimitiveRestartIndex;

		auto program1 = createProgram1();
		auto program2 = createProgram2();

        auto vertexSpec1 = new VertexSpec!Vertex(program1);
		auto vertexSpec2 = new VertexSpec!TVertex(program2);

		auto vertexData1 = new VertexData(
			vertexSpec1,
			[Vertex(vec3f(0, 0, 0), vec4f(0, 0, 0, 0))],
			[0u]
		);
		auto billBoardVertexData = new VertexData(
			vertexSpec2,
			[
				TVertex(vec3f(2048,    0, 0), vec4f(0, 1, 0, 1), vec2f(1, 0)),
				TVertex(vec3f(   0,    0, 0), vec4f(0, 0, 1, 1), vec2f(0, 0)),
				TVertex(vec3f(2048, 2048, 0), vec4f(1, 0, 0, 1), vec2f(1, 1)),
				TVertex(vec3f(   0, 2048, 0), vec4f(0, 1, 1, 1), vec2f(0, 1))
			],
			[0u, 1u, 3u, 0u, 3u, 2u]
		);

		polylines = new Polylines(renderState, program1, vertexData1);
        this.beholder.renderable ~= polylines;

		points = new Points(renderState, program1, vertexData1);
		this.beholder.renderable ~= points;

		billboard = new Billboard(renderState, program2, billBoardVertexData);
		this.beholder.renderable ~= billboard;
	}

	void addTargets(Target[] targets) @trusted
	{
		foreach(t; targets)
		{
			// prevent index overflow
			if (targets.length >= TargetIndex.max)
			{
				import std.stdio : writeln;
				writeln("Index exceeds max possible value. No data added.");
				break;
			}

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
		auto newData = this.targets.map!(
			tgt=>Vertex(
				vec3f(tgt.position.x, tgt.position.y, 0), 
				vec4f(tgt.id.source == 17 ? 0.9 : 0, 0.6, 0.7, 1)
			)).array;
		polylines.drawState.vertexData.vbo.setData(newData);
		points.drawState.vertexData.vbo.setData(newData);

		TargetIndex[] indices;
		foreach (track; tracks)
		{
			indices ~= track ~ PrimitiveRestartIndex;
		}

		polylines.drawState.vertexData.ibo.setData(indices);
		points.drawState.vertexData.ibo.setData(indices);
		
		polylines.visible = true;
		points.visible = true;
		billboard.visible = true;
	}

	auto createProgram1() @trusted
	{
		import beholder.context : Context;

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

		return Context.makeProgram(program_source);
	}

	auto createProgram2() @trusted
	{
		import beholder.context : Context;

        const program_source =
				"#version 330 core

				#if VERTEX_SHADER
				layout(location = 0) in vec3 position;
				layout(location = 1) in vec4 color;
				layout(location = 2) in vec2 texCoord;
				out vec4 vColor;
				out vec2 vTexCoord;
				uniform mat4 mvp_matrix;
				void main()
				{
					gl_Position = mvp_matrix * vec4(position.xyz, 1.0);
					vColor = color;
    				vTexCoord = texCoord;
				}
				#endif

				#if FRAGMENT_SHADER
				in vec4 vColor;
				in vec2 vTexCoord;
				out vec4 FragOut;
        		uniform sampler2D frontTex;
				uniform float deltaTime;

                const vec4 newColorMax    = vec4(0.62745098,  0.749019608, 0.360784314, 1.0); // A0BF5C
                const vec4 newColorMin    = vec4(0.749019608/2, 0.721568627/2, 0.0,         1.0); // BFB800
                const vec4 afterglowColor = vec4(0.0,         0.658823529, 1.0,         1.0); // 00A8FF
                const vec4 black          = vec4(0.0, 0.0, 0.0, 1.0);
				const vec4 beam = newColorMax;
				const float PI = radians(180.0);

				void main()
				{
					float dt = clamp(deltaTime, 0.0, 1.0);

					vec2 decart = vTexCoord - 0.5;
					float r = length(decart);
					if (r >= 0.5)
						discard;

					float phi = atan(decart.x, decart.y);
					vec2 polarCoord = vec2(r*2, (phi+PI)/2/PI);
					vec4 it = texture(frontTex, polarCoord);
					float p = step(0.05, it.g);
					vec4 fr = p*mix(black, afterglowColor, it.r) +
					          (1 - p)*mix(newColorMin, newColorMax, it.r);

					float a = dt - 2.0/2048.0;
					float b = dt + 2.0/2048.0; 
					float t = step(a,polarCoord.y)*step(polarCoord.y,b);
					FragOut = beam*t + fr*(1-t);
				}
				#endif
			";

		return Context.makeProgram(program_source);
	}
}

// Global flag to communicate to other threads
__gshared bool __global_running = true;

alias DataChunk = shared(const(Target))[];

int main(string[] args) @safe
{
	import std.datetime : msecs, Clock, seconds, SysTime;
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

	scope beholder = new Beholder(1024, 1024, "Demo");
	beholder.clearEnabled = false;
	beholder.sceneState.camera.halfWorldWidth = 1027;
	beholder.sceneState.camera.position.x = 1027;
	beholder.sceneState.camera.position.y = 1030;
	() @trusted { beholder.sceneState.camera.updateMatrices; } ();
	auto stage = Stage(beholder);

	() @trusted {
		spawn(&loadData, thisTid, filename);

		stage.lastScanTimestamp = Clock.currTime;
		stage.billboard.updatePeriod = 4.seconds;

		beholder.onBeforeLoopStart = () @trusted {
			beholder.invalidate;
			auto currTimestamp = Clock.currTime;
			if (currTimestamp > stage.lastScanTimestamp)
			{
				while (currTimestamp - stage.lastScanTimestamp > stage.billboard.updatePeriod)
				{
					stage.lastScanTimestamp += stage.billboard.updatePeriod;
				}

				stage.billboard.deltaTime = currTimestamp - stage.lastScanTimestamp;
			}
			else
			{
				// TODO log about error
			}

			receiveTimeout(0.msecs, (DataChunk p) {
				stage.addTargets(cast(Target[]) p);
			});
		};
	} ();


	import nanogui : Window;
	import info_window, exit_window, tuning_window;

	ExitWindow exitWindow;
	InfoWindow infoWindow;
	TuningWindow tuningWindow;

	infoWindow = new InfoWindow(beholder);
	exitWindow = new ExitWindow(beholder);
	tuningWindow = new TuningWindow(beholder);

	() @trusted {
		import nanogui;

		exitWindow.btnYes.callback = () { beholder.close; };
		exitWindow.btnNo.callback  = () { exitWindow.visible = false; };

		tuningWindow.attenuationFactor.value = 999999;

		// now we should do layout manually yet for the first time
		beholder.performLayout();

		const x = (beholder.width  - exitWindow.width) / 2;
		const y = (beholder.height - exitWindow.height) / 2;
		exitWindow.position = Vector2i(x, y);
		infoWindow.position = Vector2i(0, infoWindow.height);
		tuningWindow.position = Vector2i(beholder.width - tuningWindow.width, 0);
		tuningWindow.attenuationFactor.callback = (float v) { stage.billboard.attenuationFactor = v; };
		tuningWindow.attenuationFactor.value = 8.85;
		stage.billboard.attenuationFactor = 8.85;
	} ();

	beholder.onClose = () { exitWindow.visible = true; return false; };

	beholder.onMouseMotion = delegate(ref const(beholder.Event) event)
	{
		() @trusted
		{
			import std.conv : to;
			import gfm.math : vec2i;
			auto mcoord = vec2i(event.motion.x, event.motion.y);
			auto ray = beholder.sceneState.camera.rayFromMouseCoord(mcoord);
			infoWindow.xValue.caption = ray.x.to!string;
			infoWindow.yValue.caption = ray.y.to!string;
			infoWindow.camX.caption = beholder.sceneState.camera.position.x.to!string;
			infoWindow.camY.caption = beholder.sceneState.camera.position.y.to!string;
			infoWindow.scale.caption = (2*beholder.sceneState.camera.halfWorldWidth).to!string;
		} ();
		return false;
	};

	beholder.onMouseWheel = delegate(ref const(beholder.Event) event)
	{
		() @trusted
		{
			import std.conv : to;
			infoWindow.scale.caption = (2*beholder.sceneState.camera.halfWorldWidth).to!string;
		} ();
		return false;
	};

	beholder.run();

	() @trusted {
		__global_running = false;
	} ();

	// TODO:
	// Добавить поддержку кадров (группирования разнородных данных)
	// Сделать диалоговое окно при выходе модальным
	// Обработка изменения размеров окна
	// Загрузка текстур
	// Управление отображением данных
	// Трассы имеют тип линии
	// Каждое донесение может имеет символ (помимо точки, например, треугольник)
	// Добавить координатную сетку
	// 	- полярную
	// 	- декартову

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
		if (!__global_running)
		{
			writefln("Main thread has been stopped");
			return;
		}
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