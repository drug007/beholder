module demo;

import gfm.math : vec3f, vec4f;
import common : Renderer;
import guirenderer : GUIRenderer;
import gridrenderer : GridRenderer;
import beholder.camera : Camera;
import beholder.nuklearapp : NuklearApp;

class DemoApplication : NuklearApp
{
	import std.datetime : Duration, SysTime;
	import std.typecons : Nullable;
	import std.range : only;
	import gfm.math : vec2f;
	import std.container.array : Array;

	private Array!Renderer  _renderers;
	private Camera _camera;
	private bool _camera_moving;
	private float _mouse_x, _mouse_y;

	import situation : Situation, makeTestSituation;
	Situation situation;

	this(string title, int w, int h, NuklearApp.FullScreen flag)
	{
		super(title, w, h, flag);

		_camera = new Camera(
			vec2f(_width, _height), 
			vec3f(0, 0, 0),
			150_000
		);

		situation = makeTestSituation;

		new GridRenderer(this);
		// GUI should be at top
		new GUIRenderer(this);
	}

	@property mouseX() const { return _mouse_x; }
	@property mouseY() const { return _mouse_y; }

	void addRenderer(Renderer renderer)
	{
		_renderers ~= renderer;
	}

	auto close() pure nothrow @nogc
	{
		_running = false;
	}

	override void onIdle()
	{
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

	override void onResize(ref const(SDL_Event) event)
	{
		_camera.window = vec2f(window.getWidth, window.getHeight);
		updateGridRenderer;
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
	import bindbc.nuklear;

	auto app = new DemoApplication("Demo application", 1200, 768, NuklearApp.FullScreen.no);
	scope(exit) app.destroy();
	
	app.run();

	return 0;
}
