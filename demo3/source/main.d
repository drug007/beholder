module main;

import gfm.sdl2;
import gfm.opengl;
import bindbc.nuklear;

import core.stdc.string;
import core.stdc.stdlib;
import core.stdc.math;
import core.stdc.stdio;

import beholder.nuklear_sdl_gl3;

int main(string[] args)
{
	int width= 1200;
	int height = 800;

	version(BindNuklear_Static) {}
	else
	{
		NuklearSupport nuksup = loadNuklear();
		if(nuksup != NuklearSupport.Nuklear4)
		{
			printf("Error: Nuklear library is not found.");
			return -1;
		}
	}

	import std.experimental.logger : FileLogger, LogLevel;
	// create a logger
	import std.stdio : stdout;
	auto _logger = new FileLogger(stdout, LogLevel.warning);

	// load dynamic libraries
	auto _sdl2 = new SDL2(_logger);
	// initialize each SDL subsystem we want by hand
	_sdl2.subSystemInit(SDL_INIT_VIDEO);
	_sdl2.subSystemInit(SDL_INIT_EVENTS);

	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
	SDL_GL_SetAttribute (SDL_GL_CONTEXT_FLAGS, SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG);
	SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

	// create an OpenGL-enabled SDL window
	auto _window = new SDL2Window(_sdl2,
							SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
							width, height,
							SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE);

	GLSupport retVal = loadOpenGL();
	if(retVal >= GLSupport.gl33)
	{
		// configure renderer for OpenGL 3.3
		import std.stdio;
		writefln("Available version of opengl: %s", retVal);
	}
	else
	{
		import std.stdio;
		if (retVal == GLSupport.noLibrary)
			writeln("opengl is not available");
		else
			writefln("Unsupported version of opengl %s", retVal);
		return 1;
	}

	auto _gl = new OpenGL(_logger);

	SDL_GL_SetSwapInterval(1);

	glViewport(0, 0, width, height);

	nk_context *ctx;
	ctx = nk_sdl_init(_window.nativeWindow);

	nk_font_atlas *atlas;
	nk_sdl_font_stash_begin(&atlas);
	nk_sdl_font_stash_end();

	nk_colorf bg;
	bg.r = 0.10f, bg.g = 0.18f, bg.b = 0.24f, bg.a = 1.0f;

	import beholder.panel;
	auto panels = [
		new Panel("demo2", 550, 50, 230, 250, bg),
		new Panel("demo", 50, 50, 230, 250, bg),
	];

	bool running = true;
	while(running)
	{
		/* Input */
		SDL_Event evt;
		nk_input_begin(ctx);
		while (SDL_PollEvent(&evt)) {
			if (evt.type == SDL_QUIT)
			{
				running = false;
				continue;
			}
			nk_sdl_handle_event(&evt);
		}
		nk_input_end(ctx);

		foreach(e; panels)
			e.draw(ctx);

		/* Draw */
		glViewport(0, 0, _window.getWidth, _window.getHeight);
		glClear(GL_COLOR_BUFFER_BIT);
		glClearColor(bg.r, bg.g, bg.b, bg.a);
		/* IMPORTANT: `nk_sdl_render` modifies some global OpenGL state
		* with blending, scissor, face culling, depth test and viewport and
		* defaults everything back into a default state.
		* Make sure to either a.) save and restore or b.) reset your own state after
		* rendering the UI. */
		nk_sdl_render(NK_ANTI_ALIASING_ON,512*1024, 128*1024);
		SDL_GL_SwapWindow(_window.nativeWindow);
	}
	nk_sdl_shutdown();
	destroy(_gl);
	destroy(_window);
	destroy(_sdl2);

	return 0;
}

