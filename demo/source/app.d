module demo;

import gfm.math : vec3f, vec4f;
import taggedalgebraic : TaggedAlgebraic;

import beholder.application : Application;
import beholder.drawer : Drawer;

class NuklearApplication : Application
{
	import std.typecons : Nullable;
	import gfm.math : vec2f;
	import nuklear_sdl_gl3;

	enum MAX_VERTEX_MEMORY = 512 * 1024;
	enum MAX_ELEMENT_MEMORY = 128 * 1024;

    nk_context* ctx;

    this(string title, int w, int h, Application.FullScreen flag)
    {
        super(title, w, h, flag);

        ctx = nk_sdl_init(&window());
        nk_font_atlas *atlas;
        nk_sdl_font_stash_begin(&atlas);
        nk_sdl_font_stash_end();
    }

	~this()
	{
		nk_sdl_shutdown();
	}

	override void draw()
	{
		super.draw();

        if (nk_begin(ctx, "Demo", nk_rect(50, 50, 230, 450),
            NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
            NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
        {
        }
        nk_end(ctx);

		nk_sdl_render(NK_ANTI_ALIASING_ON, MAX_VERTEX_MEMORY, MAX_ELEMENT_MEMORY);
	}

	override void run()
	{
		import gfm.sdl2: SDL_GetTicks, SDL_QUIT, SDL_KEYDOWN, SDL_KEYDOWN, SDL_KEYUP, SDL_MOUSEBUTTONDOWN,
			SDL_MOUSEBUTTONUP, SDL_MOUSEMOTION, SDL_MOUSEWHEEL, SDL_Event;

		while(_running)
		{
			SDL_Event event;
			nk_input_begin(ctx);
			while(_sdl2.pollEvent(&event))
			{
				nk_sdl_handle_event(&event);
				if (isAnyNuklearWindowHoveredExceptOne(ctx, "Main"))
					continue;
				defaultProcessEvent(event);
			}
			nk_input_end(ctx);

			draw();

			_window.swapBuffers();
		}
	}

	private auto isAnyNuklearWindowHoveredExceptOne(nk_context* ctx, string window_name)
	{
		nk_window *iter;
		assert(ctx);
		if (!ctx) return false;
		iter = ctx.begin;
		while (iter)
		{
			import std.string : fromStringz;
			/* check if window is being hovered */
			if(!(iter.flags & NK_WINDOW_HIDDEN)) {
				/* check if window popup is being hovered */
				if (iter.popup.active && iter.popup.win && nk_input_is_mouse_hovering_rect(&ctx.input, iter.popup.win.bounds))
					return true;

				// skip window
				if (iter.name_string.ptr.fromStringz != window_name)
				{
					if (iter.flags & NK_WINDOW_MINIMIZED) {
						nk_rect header = iter.bounds;
						header.h = ctx.style.font.height + 2 * ctx.style.window.header.padding.y;
						if (nk_input_is_mouse_hovering_rect(&ctx.input, header))
							return 1;
					} else if (nk_input_is_mouse_hovering_rect(&ctx.input, iter.bounds)) {
						return true;
					}
				}
			}
			iter = iter.next;
		}
		return false;
	}
}

int main(string[] args)
{
    auto app = new NuklearApplication("Demo gui application", 1200, 768, Application.FullScreen.no);
    scope(exit) app.destroy();

	app.run();

    return 0;
}
