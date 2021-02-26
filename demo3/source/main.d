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

	version(none) {}
	else
	{
		NuklearSupport nuksup = loadNuklear();
		if(nuksup != NuklearSupport.Nuklear4)
		{
			printf("Error: Nuklear library is not found.");
			return -1;
		}
	}

	version(none) {}
	else
	{
		import std.experimental.logger : FileLogger, LogLevel;
		// create a logger
		import std.stdio : stdout;
		auto _logger = new FileLogger(stdout, LogLevel.warning);

		// load dynamic libraries
		auto _sdl2 = new SDL2(_logger, SharedLibVersion(2, 0, 0));
		auto _gl = new OpenGL(_logger); // in fact we disable logging
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
	}
	// reload OpenGL now that a context exists
	_gl.reload();

	SDL_GL_SetSwapInterval(1);

	glViewport(0, 0, width, height);

	nk_context *ctx;
	nk_colorf bg;
	ctx = nk_sdl_init(_window._window);

	nk_font_atlas *atlas;
	nk_sdl_font_stash_begin(&atlas);
	nk_sdl_font_stash_end();

	bg.r = 0.10f, bg.g = 0.18f, bg.b = 0.24f, bg.a = 1.0f;
	enum {EASY, HARD}
	int op = EASY;
	int property = 20;

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

		if (nk_begin(ctx, "Demo", nk_rect(50, 50, 230, 250),
					 NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
					 NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
		{
			nk_layout_row_static(ctx, 30, 80, 1);
			if (nk_button_label(ctx, "button"))
			{
				printf("button pressed\n");
			}
			nk_layout_row_dynamic(ctx, 30, 2);
			if (nk_option_label(ctx, "easy", op == EASY)) op = EASY;
			if (nk_option_label(ctx, "hard", op == HARD)) op = HARD;
			nk_layout_row_dynamic(ctx, 25, 1);
			nk_property_int(ctx, "Compression:", 0, &property, 100, 10, 1);

			nk_layout_row_dynamic(ctx, 20, 1);
			nk_label(ctx, "background:", NK_TEXT_LEFT);
			nk_layout_row_dynamic(ctx, 25, 1);
			if (nk_combo_begin_color(ctx, nk_rgb_cf(bg), nk_vec2(nk_widget_width(ctx),400))) {
				nk_layout_row_dynamic(ctx, 120, 1);
				bg = nk_color_picker(ctx, bg, NK_RGBA);
				nk_layout_row_dynamic(ctx, 25, 1);
				bg.r = nk_propertyf(ctx, "#R:", 0, bg.r, 1.0f, 0.01f,0.005f);
				bg.g = nk_propertyf(ctx, "#G:", 0, bg.g, 1.0f, 0.01f,0.005f);
				bg.b = nk_propertyf(ctx, "#B:", 0, bg.b, 1.0f, 0.01f,0.005f);
				bg.a = nk_propertyf(ctx, "#A:", 0, bg.a, 1.0f, 0.01f,0.005f);
				nk_combo_end(ctx);
			}
		}
		nk_end(ctx);

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
		SDL_GL_SwapWindow(_window._window);
	}
	nk_sdl_shutdown();
	destroy(_gl);
	destroy(_window);
	destroy(_sdl2);

	return 0;
}

