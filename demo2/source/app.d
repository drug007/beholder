module demo;

import gfm.math : vec3f, vec4f;
import taggedalgebraic : TaggedAlgebraic;

struct Foo
{
	int i;
	float f;
	string str;
	int[2] i2 = [ 101, 112 ];
}

struct Bar
{
	int i;
	string[] string_array;
}

struct DataPoint
{
	int source;
	int dataset;
	vec3f position;
	long timestamp;
}

struct Types
{
	Foo f;
	Bar b;
	DataPoint dp;
}

alias Value = TaggedAlgebraic!Types;

struct Vertex
{
	vec3f position;
	vec4f color;
}
alias CoordType = float;
enum NumberOfDimensions = 3;

struct Payload
{
	long index;
	int source;
	int subset;

	this(int source, int subset, long idx)
	{
		this.index  = idx;
		this.source = source;
		this.subset = subset;
	}
}

import rtree;
alias RTreeIndex = RTree!(Payload, CoordType, NumberOfDimensions, CoordType);

import common : Parent, Renderer, Simulator;
import guirenderer : GUIRenderer;
import gridrenderer : GridRenderer;
import trackrenderer : TrackRenderer;
import mainsimulator : MainSimulator;
import beholder.camera : Camera;

import nuklearapp : NuklearApp;

class DemoApplication : NuklearApp, Parent
{
	import std.datetime : Duration, SysTime;
	import std.typecons : Nullable;
	import gfm.math : vec2f;

	RTreeIndex index;

	import std.container.array : Array;
	private Array!Renderer  _renderers;
	private Array!Simulator _simulators;
	private SysTime _current_simulation_timestamp;
	private Duration _simulation_start_timeshift;
	private Camera _camera;
	private bool _camera_moving;
	private float _mouse_x, _mouse_y;
	private bool _simulation_in_progress;

	this(string title, int w, int h, NuklearApp.FullScreen flag)
	{
		super(title, w, h, flag);

		index = new RTreeIndex();

		_camera = new Camera(
			vec2f(_width, _height), 
			vec3f(0, 0, 0),
			15_000
		);

		new GridRenderer(this);
		auto track_renderer = new TrackRenderer(this);
		new GUIRenderer(this);
		auto s = new MainSimulator(this, track_renderer);

		stopSimulation;
		startSimulation;
	}

	@property mouseX() const { return _mouse_x; }
	@property mouseY() const { return _mouse_y; }

	void addRenderer(Renderer renderer)
	{
		_renderers ~= renderer;
	}

	void addSimulator(Simulator simulator)
	{
		_simulators ~= simulator;
	}

	void startSimulation()
	{
		_simulation_in_progress = true;
		_current_simulation_timestamp = currTimestamp;
		_simulation_start_timeshift = _current_simulation_timestamp - SysTime(0);
	}

	void stopSimulation()
	{
		_simulation_in_progress = false;
		_current_simulation_timestamp = SysTime(0);
		_simulation_start_timeshift = Duration.zero;
	}

	void clearFinished()
	{
		_current_simulation_timestamp = currTimestamp;
		_simulation_start_timeshift = _current_simulation_timestamp - SysTime(0);
		foreach(sim; _simulators)
		{
			if (auto s = cast(MainSimulator) sim)
			{
				s.clearFinished;
			}
		}
	}

	auto currSimulationTimestamp() const { return _current_simulation_timestamp.toUTC - _simulation_start_timeshift; }

	override void onIdle()
	{
		if (_simulation_in_progress)
		{
			import std.datetime : dur;
			enum SimulationPeriod = 15.dur!"msecs";
			auto delta = currTimestamp - _current_simulation_timestamp;
			if (delta >= SimulationPeriod)
			{
				do
				{
					_simulation_in_progress = false;
					_current_simulation_timestamp += SimulationPeriod;
					foreach(s; _simulators)
					{
						auto simulation_timestamp = _current_simulation_timestamp - _simulation_start_timeshift;
						if (simulation_timestamp < s.finishTimestamp)
							_simulation_in_progress = true;
						s.onSimulation(simulation_timestamp);
					}
					delta -= SimulationPeriod;
				} while (delta >= SimulationPeriod);
			}
		}
		draw();
	}

	void draw()
	{
		{
			import gfm.opengl;

			// clear the whole window
			glViewport(0, 0, _width, _height);
			glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
			glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

			foreach(r; _renderers)
				r.onRender();
		}
	}

	import gfm.sdl2 : SDL_Event;
	override void onMouseWheel(ref const(SDL_Event) event)
	{
		super.onMouseWheel(event);

		if(event.wheel.y > 0)
		{
			_camera.size = camera.size * 1.1;
			updateGridRenderer;
		}
		else if(event.wheel.y < 0)
		{
			_camera.size = camera.size * 0.9;
			updateGridRenderer;
		}
	}

	private auto updateGridRenderer()
	{
		foreach(r; _renderers)
			if (auto gridrenderer = cast(GridRenderer) r)
				gridrenderer.update;
	}

	override void processMouseMotion(ref const(SDL_Event) event)
	{
		import gfm.math : vec3f;

		auto new_mouse_x = event.motion.x;
		auto new_mouse_y = _height - event.motion.y;
		
		if(_camera_moving)
		{
			float factor_x = void, factor_y = void;
			const aspect_ratio = _width/cast(float)_height;
			if(_width > _height) 
			{
				factor_x = 2.0f * _camera.size / cast(float) _width * aspect_ratio;
				factor_y = 2.0f * _camera.size / cast(float) _height;
			}
			else
			{
				factor_x = 2.0f * _camera.size / cast(float) _width;
				factor_y = 2.0f * _camera.size / cast(float) _height / aspect_ratio;
			}
			auto new_pos = _camera.position + vec3f(
				(_mouse_x - new_mouse_x)*factor_x, 
				(_mouse_y - new_mouse_y)*factor_y,
				0,
			);
			_camera.position = new_pos;
			updateGridRenderer;
		}

		_mouse_x = new_mouse_x;
		_mouse_y = new_mouse_y;

		// _left_button   = (event.motion.state & SDL_BUTTON_LMASK);
		// _right_button  = (event.motion.state & SDL_BUTTON_RMASK);
		// _middle_button = (event.motion.state & SDL_BUTTON_MMASK);
	}

	override void onMouseUp(ref const(SDL_Event) event)
	{
		import gfm.sdl2;

		switch(event.button.button)
		{
			case SDL_BUTTON_LEFT:
				// _left_button = 0;
			break;
			case SDL_BUTTON_RIGHT:
				// _right_button = 0;
				_camera_moving = false;
			break;
			case SDL_BUTTON_MIDDLE:
				// _middle_button = 0;
			break;
			default:
		}
	}

	override void onMouseDown(ref const(SDL_Event) event)
	{
		import gfm.sdl2;

		switch(event.button.button)
		{
			case SDL_BUTTON_LEFT:
				// _left_button = 1;
			break;
			case SDL_BUTTON_RIGHT:
				// _right_button = 1;
				_camera_moving = true;
			break;
			case SDL_BUTTON_MIDDLE:
				// _middle_button = 1;
			break;
			default:
		}
	}

	auto gl() { return _gl; }
	auto camera() { return _camera; }
}

int main(string[] args)
{
	auto app = new DemoApplication("Demo application", 1200, 768, NuklearApp.FullScreen.no);
	scope(exit) app.destroy();
	
	// enum displace = vec3f(0.01, 0.01, 0.01);
	// size_t i;
	// int[int][int] ids;
	// foreach(p; data)
	// {
	// 	if (p.kind == Value.Kind.dp)
	// 	{
	// 		auto payload = Payload(p.source, p.dataset, i);
	// 		app.index.insert((p.position-displace).ptr[0..NumberOfDimensions], (p.position+displace).ptr[0..NumberOfDimensions], payload);

	// 		i++;
	// 	}
	// 	ids[p.source][p.dataset]++;
	// }
	
	app.run();

	return 0;
}
