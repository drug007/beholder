module guirenderer;

import common : Parent, Renderer;

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

		nk_style *s = &_app.ctx.style;
		nk_style_push_color(_app.ctx, &s.window.background, nk_rgba(0,0,0,0));
		nk_style_push_style_item(_app.ctx, &s.window.fixed_background, nk_style_item_color(nk_rgba(0,0,0,0)));
		if (nk_begin(_app.ctx, "Main", popup_window, NK_WINDOW_BACKGROUND))
		{
			// if (nk_input_mouse_clicked(&_app.ctx.input, NK_BUTTON_LEFT, nk_rect(0, 0, _width, _height)))
			// {
			// 	if (!popup_active || !nk_input_mouse_clicked(&_app.ctx.input, NK_BUTTON_LEFT, popup_window))
			// 	{
			// 		const span = vec3f(1, 1, 1)*2*camera.size/_width*10; // 10 pixels around mouse pointer
			// 		auto mouse = vec2f(_mouse_x, _mouse_y);
			// 		auto ray = projectWindowToPlane0(mouse);
			// 		auto min = ray - span;
			// 		auto max = ray + span;
			// 		search_result = index.search(min.ptr[0..NumberOfDimensions], max.ptr[0..NumberOfDimensions]);

			// 		if (!search_result.empty)
			// 		{
			// 			popup_active = true;
			// 			popup_window = nk_rect(_mouse_x, _height - _mouse_y, 200, 400);
			// 			import std.stdio;
			// 			writeln(search_result[], " ", _mouse_x, " ", _mouse_y);
			// 		}
			// 		else
			// 		{
			// 			popup_active = false;
			// 			popup_window = nk_rect(0, 0, 0, 0);
			// 			search_result.length = 0;
			// 		}
			// 	}
			// }
			// if (popup_active)
			// {
			// 	nk_style_pop_color(_app.ctx);
			// 	nk_style_pop_style_item(_app.ctx);

			// 	nk_layout_row_dynamic(_app.ctx, 250, 1);
			// 	auto pw = nk_rect(0, 0, popup_window.w, popup_window.h);
			// 	if (nk_popup_begin(_app.ctx, NK_POPUP_DYNAMIC, "Popup", NK_WINDOW_SCALABLE, pw))
			// 	{
			// 		char[512] buffer;
			// 		foreach(ref e; search_result[])
			// 		{
			// 			import std.format : sformat;
			// 			auto formatted_output = sformat!"[%d]\0"(buffer[], e.index);
			// 			value_drawer.state[e.index].draw(_app.ctx, formatted_output, value[e.index]);
			// 		}
			// 		nk_popup_end(_app.ctx);
			// 	}
			// 	nk_style_push_color(_app.ctx, &s.window.background, nk_rgba(0,0,0,0));
			// 	nk_style_push_style_item(_app.ctx, &s.window.fixed_background, nk_style_item_color(nk_rgba(0,0,0,0)));
			// }
		}
		nk_end(_app.ctx);
		nk_style_pop_color(_app.ctx);
		nk_style_pop_style_item(_app.ctx);

		auto width = _app.window.getWidth;
		if (nk_begin(_app.ctx, "Parameters", nk_rect(width -230 - 30, 50, 230, 450),
			NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
			NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
		{
			nk_layout_row_dynamic(_app.ctx, 12, 1);
			import std.conv : text;
			nk_label(_app.ctx, text("Mouse position: ", _app.mouseX, " ", _app.mouseY, "\0").ptr, NK_TEXT_LEFT);
			with(_app.camera.position)
				nk_label(_app.ctx, text("Camera position: ", x, " ", y, "\0").ptr, NK_TEXT_LEFT);
			with(_app.camera)
				nk_label(_app.ctx, text("Camera scale: ", size, "\0").ptr, NK_TEXT_LEFT);
			nk_label(_app.ctx, text("Time: ", _app.currTimestamp, "\0").ptr, NK_TEXT_LEFT);
			nk_label(_app.ctx, text("Time: ", _app.currSimulationTimestamp, "\0").ptr, NK_TEXT_LEFT);
		}
		nk_end(_app.ctx);
		
		const height = _app.window.getHeight;
		const padding = 10;
		const panel_height = 60;
		if (nk_begin(_app.ctx, "Timeline", 
			nk_rect(padding, height - panel_height + padding, width - 2*padding, panel_height - 2*padding), 0))
		{
			import std.conv : text;
			import std.datetime : SysTime, UTC;

			nk_layout_row(_app.ctx, NK_DYNAMIC, 20, 5, [0.05f, 0.05f, 0.05f, 0.65f, 0.2f].ptr);
			if (nk_button_label(_app.ctx, "play"))
				_app.startSimulation;
			if (nk_button_label(_app.ctx, "pause"))
				_app.pauseSimulation;
			if (nk_button_label(_app.ctx, "stop"))
				_app.stopSimulation;
			float value = _app.currSimulationTimestamp.stdTime;
			float finish = _app.lastTimestamp.stdTime;
			nk_slider_float(_app.ctx, 0.0001, &value, finish, value*typeof(value).epsilon);
			nk_label(_app.ctx, text("value: ", SysTime(cast(long)value, UTC()), "\0").ptr, NK_TEXT_LEFT);
			_app.currSimulationTimestamp = SysTime(cast(long) value);
		}
		nk_end(_app.ctx);

		nk_sdl_render(NK_ANTI_ALIASING_ON, _app.MAX_VERTEX_MEMORY, _app.MAX_ELEMENT_MEMORY);
	}
private:
	import nuklear_sdl_gl3;

	DemoApplication _app;
	nk_colorf _bg;
}