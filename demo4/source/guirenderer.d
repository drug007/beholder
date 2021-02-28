module guirenderer;

import common : Renderer;

class GUIRenderer : Renderer
{
	import demo : DemoApplication;

	this(DemoApplication parent)
	{
		parent.addRenderer(this);
		_app = parent;
		_bg.r = 0.10f, _bg.g = 0.18f, _bg.b = 0.24f, _bg.a = 1.0f;
	}

	void onRender()
	{
		static bool popup_active;
		static nk_rect popup_window;
		import std.container.array : Array;
		// static Array!Payload search_result;

		nk_style_pop_color(_app.ctx);
		nk_style_pop_style_item(_app.ctx);

		const menu_bar_height = 40;
		if (nk_begin(_app.ctx, "menu", nk_rect(2, 2, 400, menu_bar_height), 0))
		{
			nk_menubar_begin(_app.ctx);
			scope(exit) nk_menubar_end(_app.ctx);

			/* menu #1 */
			nk_layout_row_begin(_app.ctx, NK_STATIC, menu_bar_height, 3);
			nk_layout_row_push(_app.ctx, 35);
			if (nk_menu_begin_label(_app.ctx, "MENU", NK_TEXT_LEFT, nk_vec2(120, 200)))
			{
				enum MenuState { MENU_NONE, MENU_FILE }
				static auto menu_state = MenuState.MENU_NONE;
				nk_collapse_states state;

				auto curr_menu_state = (menu_state == MenuState.MENU_FILE) ? NK_MAXIMIZED: NK_MINIMIZED;
				if (nk_tree_state_push(_app.ctx, NK_TREE_TAB, "FILE", &curr_menu_state)) {
					menu_state = MenuState.MENU_FILE;
					if (nk_menu_item_label(_app.ctx, "Exit", NK_TEXT_LEFT))
						_app.close;
					nk_tree_pop(_app.ctx);
				} else menu_state = (menu_state == MenuState.MENU_FILE) ? MenuState.MENU_NONE: menu_state;

				nk_menu_end(_app.ctx);
			}
		}
		nk_end(_app.ctx);

		{
			const width  = _app.window.getWidth;
			const height = _app.window.getHeight;
			const panel_width = 730;
			if (nk_begin(_app.ctx, "Parameters", nk_rect(width - panel_width - 5, 5, panel_width, 130),
				NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
				NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
			{
				nk_layout_row_dynamic(_app.ctx, 12, 1);
				import std.conv : text;
				nk_label(_app.ctx, text("Screen coordinates: ", _app.mouseX, " ", _app.mouseY, "\0").ptr, NK_TEXT_LEFT);
				
				auto un = _app.camera.unproject(_app.mouseX, _app.mouseY);
				nk_label(_app.ctx, text("World coordinates: ", un.orig.x, " ", un.orig.y, "\0").ptr, NK_TEXT_LEFT);
				
				with(_app.camera.position)
					nk_label(_app.ctx, text("Camera position: ", x, " ", y, "\0").ptr, NK_TEXT_LEFT);
				with(_app.camera)
					nk_label(_app.ctx, text("Camera scale: ", size, "\0").ptr, NK_TEXT_LEFT);
				nk_label(_app.ctx, text("Time: ", _app.currTimestamp, "\0").ptr, NK_TEXT_LEFT);
			}
			nk_end(_app.ctx);
		}

		{
			const width  = _app.window.getWidth;
			const height = _app.window.getHeight;
			const panel_width = 330;
			if (nk_begin(_app.ctx, "Sources&Tracks", nk_rect(width - panel_width - 5, 140, panel_width, height - 145),
				NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
				NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
			{
				nk_layout_row_dynamic(_app.ctx, 12, 1);
				import std.conv : text;
				foreach(ref src; _app.situation.source)
				{
					nk_collapse_states s = src.gui_state ? NK_MAXIMIZED : NK_MINIMIZED;
					scope(exit) src.gui_state = s == NK_MAXIMIZED;
					if (nk_tree_state_push(_app.ctx, NK_TREE_NODE, text("Source: ", src.id, "\0").ptr, &s))
					{
						foreach(ref t; src.track)
						{
							nk_collapse_states ts = t.gui_state ? NK_MAXIMIZED : NK_MINIMIZED;
							scope(exit) t.gui_state = ts == NK_MAXIMIZED;
							if (nk_tree_state_push(_app.ctx, NK_TREE_NODE, text("Track: ", t.id, "\0").ptr, &ts))
							{
								foreach(ref p; t.point)
									nk_label(_app.ctx, text("Point: ", p.x, ", ", p.y, ", ", p.timestamp, "\0").ptr, NK_TEXT_LEFT);
								nk_tree_state_pop(_app.ctx);
							}
						}
						nk_tree_state_pop(_app.ctx);
					}
				}
			}
			nk_end(_app.ctx);
		}

		nk_sdl_render(NK_ANTI_ALIASING_ON, _app.MAX_VERTEX_MEMORY, _app.MAX_ELEMENT_MEMORY);
	}
private:
	import bindbc.nuklear;
	import beholder.nuklear_sdl_gl3;

	DemoApplication _app;
	nk_colorf _bg;
}