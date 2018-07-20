module beholder.application;

class GuiApplication
{
    import std.experimental.logger : FileLogger, LogLevel;
    import std.typecons : Flag;
    import gfm.sdl2: SDL_Event;

    alias FullScreen = Flag!"FullScreen";

    @disable
    this();

    this(string title, int width, int height, FullScreen fullscreen)
    {
        import derelict.util.loader : SharedLibVersion;
        import gfm.sdl2, gfm.opengl;

        _width = width;
        _height = height;

        // create a logger
        import std.stdio : stdout;
        _logger = new FileLogger(stdout, LogLevel.warning);

        // load dynamic libraries
        _sdl2 = new SDL2(_logger, SharedLibVersion(2, 0, 0));
        _gl = new OpenGL(_logger); // in fact we disable logging
        // initialize each SDL subsystem we want by hand
        _sdl2.subSystemInit(SDL_INIT_VIDEO);
        _sdl2.subSystemInit(SDL_INIT_EVENTS);

        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);

        // create an OpenGL-enabled SDL window
        _window = new SDL2Window(_sdl2,
                                SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
                                width, height,
                                SDL_WINDOW_OPENGL);

        _window.setTitle(title);
        if (fullscreen)
        {
            _window.setFullscreenSetting(SDL_WINDOW_FULLSCREEN_DESKTOP);
            auto ws = _window.getSize;
            _width  = ws.x;
            _height = ws.y;
        }

        import gfm.math : vec2f, vec3f;
        _camera = new Camera(vec2f(_width, _height), vec3f(0, 0, 0), 2.0);

        // reload OpenGL now that a context exists
        _gl.reload();

        // redirect OpenGL output to our Logger
        _gl.redirectDebugOutput();

        _running = true;
        _camera_moving = false;
    }

    ~this()
    {
        
    }

    void destroy()
    {
        _gl.destroy();
        _window.destroy();
        _sdl2.destroy();
    }

    auto add(Renderer)(Renderer renderer)
    {
        _renderer_delegates ~= delegate() {
            renderer.draw(_camera.mvpMatrix);
        };
    }

    auto run()
    {
        import gfm.sdl2: SDL_GetTicks, SDL_QUIT, SDL_KEYDOWN, SDL_KEYDOWN, SDL_KEYUP, SDL_MOUSEBUTTONDOWN,
            SDL_MOUSEBUTTONUP, SDL_MOUSEMOTION, SDL_MOUSEWHEEL;

        while(_running)
        {
            SDL_Event event;
            while(_sdl2.pollEvent(&event))
            {
                switch(event.type)
                {
                    case SDL_QUIT:
                        if (aboutQuit()) return;
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
                    default:
                }
            }

            draw();

            _window.swapBuffers();
        }
    }

    auto camera()
    {
        return _camera;
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

    auto gl()
    {
        return _gl;
    }

protected:
    import gfm.sdl2;
    import gfm.opengl: OpenGL;
    import beholder.camera : Camera;

    SDL2Window _window;
    int _width;
    int _height;

    Camera _camera;

    ubyte _left_button, _right_button, _middle_button;

    bool _running;
    bool _camera_moving;
    int _mouse_x, _mouse_y;

    FileLogger _logger;

    OpenGL _gl;
    SDL2 _sdl2;

    alias RendererDelegate = void delegate();
    RendererDelegate[] _renderer_delegates;

    bool aboutQuit()
    {
        return true;
    }

    void draw()
    {
        import gfm.opengl;

        // clear the whole window
        glViewport(0, 0, _width, _height);
        glClearColor(0.6f, 0.6f, 0.6f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        foreach(dlg; _renderer_delegates)
            dlg();
    }

    void processMouseWheel(ref const(SDL_Event) event)
    {
        if(event.wheel.y > 0)
        {
            _camera.size = camera.size * 1.1;
        }
        else if(event.wheel.y < 0)
        {
            _camera.size = camera.size * 0.9;
        }
    }

    void processMouseUp(ref const(SDL_Event) event)
    {
        switch(event.button.button)
        {
            case SDL_BUTTON_LEFT:
                _left_button = 0;
            break;
            case SDL_BUTTON_RIGHT:
                _right_button = 0;
                _camera_moving = false;
            break;
            case SDL_BUTTON_MIDDLE:
                _middle_button = 0;
            break;
            default:
        }
    }

    void processMouseDown(ref const(SDL_Event) event)
    {
        switch(event.button.button)
        {
            case SDL_BUTTON_LEFT:
                _left_button = 1;
            break;
            case SDL_BUTTON_RIGHT:
                _right_button = 1;
                _camera_moving = true;
            break;
            case SDL_BUTTON_MIDDLE:
                _middle_button = 1;
            break;
            default:
        }
    }
    
    void processMouseMotion(ref const(SDL_Event) event)
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
        }

        _mouse_x = new_mouse_x;
        _mouse_y = new_mouse_y;

        _left_button   = (event.motion.state & SDL_BUTTON_LMASK);
        _right_button  = (event.motion.state & SDL_BUTTON_RMASK);
        _middle_button = (event.motion.state & SDL_BUTTON_MMASK);
    }
}