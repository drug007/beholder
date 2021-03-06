module beholder.sdlapp;

class SdlApp
{
	import std.experimental.logger : FileLogger, LogLevel;
	import std.typecons : Flag;
	import bindbc.sdl: SDL_Event;

	alias FullScreen = Flag!"FullScreen";

	@disable
	this();

	this(string title, int width, int height, FullScreen fullscreen)
	{
		import std.exception : enforce;

		_width = width;
		_height = height;

		// load dynamic libraries
		version(BindSDL_Dynamic)
		{
			import core.stdc.stdio : printf;
			SDLSupport sdlsup = loadSDL();
			if (sdlsup != sdlSupport)
			{
				if (sdlsup == SDLSupport.badLibrary)
					printf("Warning: failed to load some SDL functions. It seems that you have an old version of SDL.");
				else
				{
					printf("Error: SDL library is not found. Please, install SDL 2.0.5");
					enforce(0);
				}
			}
		}
		// initialize each SDL subsystem we want by hand
		enforce(!SDL_InitSubSystem(SDL_INIT_VIDEO));
		enforce(!SDL_InitSubSystem(SDL_INIT_EVENTS));

		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);

		// create an OpenGL-enabled SDL window
		import std.string : toStringz;
		_window = SDL_CreateWindow(title.toStringz,
								SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
								width, height,
								SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE);
		enforce(_window);

		_gl_context = SDL_GL_CreateContext(_window);

		import bindbc.opengl;
		GLSupport glsup = loadOpenGL();
		if (!isOpenGLLoaded())
		{
			printf("Error: failed to load OpenGL functions. Please, update graphics card driver and make sure it supports OpenGL");
			enforce(0);
		}

		SDL_GL_SetSwapInterval(1);

		if (fullscreen)
		{
			enforce(SDL_SetWindowFullscreen(_window, SDL_WINDOW_FULLSCREEN_DESKTOP));
			SDL_GetWindowSize(_window, &_width, &_height);
		}
		_running = true;

		import std.datetime : Clock;
		_prev_timestamp = Clock.currTime;
		_timestamp = Clock.currTime;
	}

	~this()
	{
		
	}

	void destroy()
	{
		if (_gl_context !is null)
		{
			_gl_context.destroy();
			_gl_context = null;
		}

		if (_window !is null)
		{
			SDL_DestroyWindow(_window);
			_window = null;
		}
		SDL_Quit();
	}

	/// allows to interrupt input processing if returns true
	bool isInputConsumed(ref SDL_Event event)
	{
		return false;
	}

	/// is called on event processing iteration start
	void onEventLoopStart()
	{

	}

	/// is called on event processing iteration end
	void onEventLoopEnd()
	{

	}

	/// called on idle
	void onIdle()
	{

	}

	void run()
	{
		while(_running)
		{
			SDL_Event event;
			import std.datetime : Clock;
			_prev_timestamp = _timestamp;
			_timestamp = Clock.currTime;
			onEventLoopStart();
			while(SDL_PollEvent(&event))
			{
				if (!isInputConsumed(event))
					defaultProcessEvent(event);
			}
			onEventLoopEnd();

			onIdle();

			assert(_gl_context !is null);
			SDL_GL_SwapWindow(_window);
		}
	}

	void onKeyDown(ref const(SDL_Event) event)
	{

	}

	void onKeyUp(ref const(SDL_Event) event)
	{

	}

	void onMouseWheel(ref const(SDL_Event) event)
	{

	}

	void onMouseMotion(ref const(SDL_Event) event)
	{

	}

	void onMouseUp(ref const(SDL_Event) event)
	{

	}

	void onMouseDown(ref const(SDL_Event) event)
	{

	}

	void onResize(ref const(SDL_Event) event)
	{

	}

	ref window()
	{
		return _window;
	}

	/// Current timestamp
	auto currTimestamp() const pure nothrow
	{
		return _timestamp;
	}

	/// Previous timestamp
	auto prevTimestamp() const pure nothrow
	{
		return _prev_timestamp;
	}

protected:
	import std.datetime : SysTime;
	import gfm.math : vec2f, vec3f;
	import bindbc.sdl;

	SDL_Window* _window;
	void* _gl_context;
	int _width;
	int _height;
	SysTime _timestamp, _prev_timestamp;

	bool _running;

	void defaultProcessEvent(ref const(SDL_Event) event)
	{
		switch(event.type)
		{
			case SDL_QUIT:
quitLabel:
				if (aboutQuit()) _running = false;
			break;
			case SDL_KEYDOWN:
				onKeyDown(event);
			break;
			case SDL_KEYUP:
				onKeyUp(event);
			break;
			case SDL_MOUSEBUTTONDOWN:
				processMouseDown(event);
				onMouseDown(event);
			break;
			case SDL_MOUSEBUTTONUP:
				processMouseUp(event);
				onMouseUp(event);
			break;
			case SDL_MOUSEMOTION:
				processMouseMotion(event);
				onMouseMotion(event);
			break;
			case SDL_MOUSEWHEEL:
				processMouseWheel(event);
				onMouseWheel(event);
			break;
			case SDL_WINDOWEVENT:
                switch (event.window.event)
                {
                case SDL_WINDOWEVENT_SIZE_CHANGED:
					_width = event.window.data1;
					_height = event.window.data2;
					onResize(event);
					goto case;
                case SDL_WINDOWEVENT_MAXIMIZED:
                case SDL_WINDOWEVENT_MOVED:
                	return;
                case SDL_WINDOWEVENT_CLOSE:
                    goto quitLabel;
version(none) // if SDL2 version is 2.0.5 or higher
{
                case SDL_WINDOWEVENT_SHOWN:
                case SDL_WINDOWEVENT_EXPOSED:
                //case SDL_WINDOWEVENT_TAKE_FOCUS:
                    OnWindowActivate(event.window.data1, event.window.data2);
                    return;
}
                default:
					SDL_Log("Window %d: unknown event %d", event.window.windowID, event.window.event); 
					return;
                }
			default:
		}
	}

	bool aboutQuit()
	{
		return true;
	}

	void processMouseWheel(ref const(SDL_Event) event)
	{
		// if(event.wheel.y > 0)
		// {
		// 	_camera.size = camera.size * 1.1;
		// }
		// else if(event.wheel.y < 0)
		// {
		// 	_camera.size = camera.size * 0.9;
		// }
	}

	void processMouseUp(ref const(SDL_Event) event)
	{
		// switch(event.button.button)
		// {
		// 	case SDL_BUTTON_LEFT:
		// 		_left_button = 0;
		// 	break;
		// 	case SDL_BUTTON_RIGHT:
		// 		_right_button = 0;
		// 		_camera_moving = false;
		// 	break;
		// 	case SDL_BUTTON_MIDDLE:
		// 		_middle_button = 0;
		// 	break;
		// 	default:
		// }
	}

	void processMouseDown(ref const(SDL_Event) event)
	{
		// switch(event.button.button)
		// {
		// 	case SDL_BUTTON_LEFT:
		// 		_left_button = 1;
		// 	break;
		// 	case SDL_BUTTON_RIGHT:
		// 		_right_button = 1;
		// 		_camera_moving = true;
		// 	break;
		// 	case SDL_BUTTON_MIDDLE:
		// 		_middle_button = 1;
		// 	break;
		// 	default:
		// }
	}
	
	void processMouseMotion(ref const(SDL_Event) event)
	{
		// import gfm.math : vec3f;

		// auto new_mouse_x = event.motion.x;
		// auto new_mouse_y = _height - event.motion.y;
		
		// if(_camera_moving)
		// {
		// 	float factor_x = void, factor_y = void;
		// 	const aspect_ratio = _width/cast(float)_height;
		// 	if(_width > _height) 
		// 	{
		// 		factor_x = 2.0f * _camera.size / cast(float) _width * aspect_ratio;
		// 		factor_y = 2.0f * _camera.size / cast(float) _height;
		// 	}
		// 	else
		// 	{
		// 		factor_x = 2.0f * _camera.size / cast(float) _width;
		// 		factor_y = 2.0f * _camera.size / cast(float) _height / aspect_ratio;
		// 	}
		// 	auto nflawed
		// 		(_flawed
		// 		(_flawed
		// 		0,flawed
		// 	);
		// 	_camera.position = new_pos;
		// }

		// _mouse_x = new_mouse_x;
		// _mouse_y = new_mouse_y;

		// _left_button   = (event.motion.state & SDL_BUTTON_LMASK);
		// _right_button  = (event.motion.state & SDL_BUTTON_RMASK);
		// _middle_button = (event.motion.state & SDL_BUTTON_MMASK);
	}
}