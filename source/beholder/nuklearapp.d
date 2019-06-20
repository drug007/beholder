module beholder.nuklearapp;

import beholder.sdlapp : SdlApp;

class NuklearApp : SdlApp
{
	import std.typecons : Nullable;
	import gfm.math : vec2f;
	import bindbc.sdl : SDL_Event;
	import nuklear_sdl_gl3;
	import bindbc.nuklear.types : nk_context;

	enum MAX_VERTEX_MEMORY = 512 * 1024;
	enum MAX_ELEMENT_MEMORY = 128 * 1024;

	nk_context* ctx;

	this(string title, int w, int h, SdlApp.FullScreen flag)
	{
		super(title, w, h, flag);

		ctx = nk_sdl_init(window);
		nk_font_atlas *atlas;
		nk_sdl_font_stash_begin(&atlas);
		nk_sdl_font_stash_end();
	}

	~this()
	{
		nk_sdl_shutdown();
	}

	override bool isInputConsumed(ref SDL_Event event)
	{
		nk_sdl_handle_event(&event);
		return isAnyNuklearWindowHoveredExceptOne(ctx, "Main");
	}

	override void onEventLoopStart()
	{
		nk_input_begin(ctx);
	}

	override void onEventLoopEnd()
	{
		nk_input_end(ctx);
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
							return true;
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