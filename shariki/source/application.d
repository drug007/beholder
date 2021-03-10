module application;

import std.math;

import gfm.math;
import gfm.sdl2;

import beholder.camera;
import beholder.nuklearapp;

class Application : NuklearApp
{
	import common;
	import sharikirenderer;
	import axis;

	private
	{
		Renderer[] _renderers;
		Camera _camera;
		SharikiRenderer _sharikirenderer;
		AxisRenderer    _axisrenderer;
		bool _camera_moving, _camera_rotating;
		float _mouse_x, _mouse_y;
	}

	this(string title, int w, int h)
	{
		super(title, w, h, NuklearApp.FullScreen.no);
		_camera = new Camera(vec2f(w, h), vec3f(0, 0, 1400), 1500);
		_camera.modifyAngles(2*PI, 0);
		_sharikirenderer = new SharikiRenderer(_camera);
		_axisrenderer    = new AxisRenderer(_camera);
		_renderers ~= _sharikirenderer;
		_renderers ~= _axisrenderer;
		_camera_moving = _camera_rotating = false;
		_mouse_x = _mouse_y = 0;
	}

	override void destroy()
	{
		if (_sharikirenderer)
		{
			.destroy(_sharikirenderer);
			_sharikirenderer = null;
		}
		if (_axisrenderer)
		{
			.destroy(_axisrenderer);
			_axisrenderer = null;
		}
		super.destroy();
	}

	void setData(R)(R data)
	{
		import std.range;
		_sharikirenderer.update(data, (cast(uint)data.length).iota);
	}

	override void onIdle()
	{
		draw();
	}

	void draw()
	{
		{
			import gfm.opengl;

			glViewport(0, 0, _width, _height);
			glClearColor(0.1f, 0.2f, 0.1f, 1.0f);
			glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

			foreach(r; _renderers)
				r.onRender();
		}
	}

	override void onMouseUp(ref const(SDL_Event) event)
	{
		switch(event.button.button)
		{
			case SDL_BUTTON_RIGHT:
				_camera_rotating = false;
			break;
			case SDL_BUTTON_MIDDLE:
			break;
			case SDL_BUTTON_LEFT:
				_camera_moving = false;
			break;
			default:
		}
	}

	override void onMouseDown(ref const(SDL_Event) event)
	{
		import gfm.sdl2;

		switch(event.button.button)
		{
			case SDL_BUTTON_RIGHT:
				_camera_rotating = true;
			break;
			case SDL_BUTTON_MIDDLE:
			break;
			case SDL_BUTTON_LEFT:
				_camera_moving = true;
			break;
			default:
		}
	}

	override void processMouseMotion(ref const(SDL_Event) event)
	{
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
			auto pos_change = vec3f(
				(_mouse_x - new_mouse_x)*factor_x, 
				(_mouse_y - new_mouse_y)*factor_y,
				0,
			);
			enum { right, up, direction }
			// the camera basis
			vec3f[3] basis;
			basis[direction] = (_camera.origin-_camera.position);
			basis[direction].normalize;
			basis[right] = basis[direction].cross(vec3f(0, 1, 0));
			basis[up] = basis[right].cross(basis[direction]);
			// change the basis of the camera position change
			// from the camera to the world one
			auto A = mat3f.fromColumns(basis[]);
			pos_change = A*pos_change;

			_camera.position = _camera.position + pos_change;
			_camera.origin   = _camera.origin + pos_change;
		}
		else if (_camera_rotating)
		{
			enum MouseSpeed = 1.0/180.;
			_camera.modifyAngles(
				(_mouse_x - new_mouse_x)*MouseSpeed,
				(_mouse_y - new_mouse_y)*MouseSpeed
			);
		}

		_mouse_x = new_mouse_x;
		_mouse_y = new_mouse_y;
	}

	override void onMouseWheel(ref const(SDL_Event) event)
	{
		super.onMouseWheel(event);

		if(event.wheel.y > 0)
		{
			_camera.size = _camera.size * 1.1;
		}
		else if(event.wheel.y < 0)
		{
			_camera.size = _camera.size * 0.9;
		}
	}
}