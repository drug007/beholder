module beholder.nuklearapp;

import beholder.sdlapp : SdlApp;

class NuklearApp : SdlApp
{
	import std.typecons : Nullable;
	import gfm.math : vec2f;
	import gfm.sdl2 : SDL_Event;
	import bindbc.nuklear;
	import beholder.nuklear_sdl_gl3;

	enum MAX_VERTEX_MEMORY = 512 * 1024;
	enum MAX_ELEMENT_MEMORY = 128 * 1024;

	nk_context* ctx;

	this(string title, int w, int h, SdlApp.FullScreen flag)
	{
		super(title, w, h, flag);

		version(BindNuklear_Static) {}
		else
		{
			NuklearSupport nuksup = loadNuklear();
			if(nuksup != NuklearSupport.Nuklear4)
			{
				import core.stdc.stdio : printf;
				printf("Error: Nuklear library is not found.\n");
				import std.exception : enforce;
				enforce(0);
			}
		}

		ctx = nk_sdl_init(window().nativeWindow);
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
		return nk_item_is_any_active(ctx) != 0;
	}

	override void onEventLoopStart()
	{
		nk_input_begin(ctx);
	}

	override void onEventLoopEnd()
	{
		nk_input_end(ctx);
	}
}