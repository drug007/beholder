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

		if (nk_begin(_app.ctx, "Demo", nk_rect(50, 50, 230, 450),
			NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
			NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
		{
			enum { SimulationOn, SimulationOff }
			static int op = SimulationOn;
			static int property = 20;

			nk_layout_row_static(_app.ctx, 30, 120, 1);
			if (nk_button_label(_app.ctx, "clear"))
			{
				// import mainsimulator;
				_app.clearFinished;
			}
			// if (nk_button_label(_app.ctx, "button"))
			// {
			// 	printf("button pressed!\n");
			// 	final switch(value[0].kind)
			// 	{
			// 		case Value.Kind.f:
			// 			value[0] = Bar();
			// 		break;
			// 		case Value.Kind.b:
			// 			value[0] = data[0];
			// 		break;
			// 		case Value.Kind.dp:
			// 			value[0] = Foo();
			// 		break;
			// 	}
			// }
			nk_label(_app.ctx, "Simulation is:", NK_TEXT_LEFT);
			nk_layout_row_dynamic(_app.ctx, 30, 2);
			auto old_op = op;
			if (nk_option_label(_app.ctx, "on",  op == SimulationOn))  op = SimulationOn;
			if (nk_option_label(_app.ctx, "off", op == SimulationOff)) op = SimulationOff;
			if (op != old_op)
			{
				if (op == SimulationOn)
					_app.startSimulation;
				else
					_app.stopSimulation;
			}


			nk_layout_row_dynamic(_app.ctx, 22, 1);
			nk_property_int(_app.ctx, "Compression:", 0, &property, 100, 10, 1);

			nk_layout_row_dynamic(_app.ctx, 20, 1);
			nk_label(_app.ctx, "background:", NK_TEXT_LEFT);
			nk_layout_row_dynamic(_app.ctx, 25, 1);
			if (nk_combo_begin_color(_app.ctx, nk_rgb_cf(_bg), nk_vec2(nk_widget_width(_app.ctx),400))) {
				nk_layout_row_dynamic(_app.ctx, 120, 1);
				_bg = nk_color_picker(_app.ctx, _bg, NK_RGBA);
				nk_layout_row_dynamic(_app.ctx, 25, 1);
				_bg.r = nk_propertyf(_app.ctx, "#R:", 0, _bg.r, 1.0f, 0.01f,0.005f);
				_bg.g = nk_propertyf(_app.ctx, "#G:", 0, _bg.g, 1.0f, 0.01f,0.005f);
				_bg.b = nk_propertyf(_app.ctx, "#B:", 0, _bg.b, 1.0f, 0.01f,0.005f);
				_bg.a = nk_propertyf(_app.ctx, "#A:", 0, _bg.a, 1.0f, 0.01f,0.005f);
				nk_combo_end(_app.ctx);
			}
		}
		nk_end(_app.ctx);

		auto width = _app.window.getWidth;
		if (nk_begin(_app.ctx, "Parameters", nk_rect(width -230 - 30, 50, 230, 450),
			NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
			NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
		{
			nk_layout_row_dynamic(_app.ctx, 22, 1);
			import std.conv : text;
			nk_label(_app.ctx, text("Mouse position: ", _app.mouseX, " ", _app.mouseY, "\0").ptr, NK_TEXT_LEFT);
			with(_app.camera.position)
				nk_label(_app.ctx, text("Camera position: ", x, " ", y, "\0").ptr, NK_TEXT_LEFT);
			with(_app.camera)
				nk_label(_app.ctx, text("Camera scale: ", size, "\0").ptr, NK_TEXT_LEFT);
			nk_label(_app.ctx, text("Time: ", _app.currTimestamp, "\0").ptr, NK_TEXT_LEFT);
		}
		nk_end(_app.ctx);

		nk_sdl_render(NK_ANTI_ALIASING_ON, _app.MAX_VERTEX_MEMORY, _app.MAX_ELEMENT_MEMORY);
	}
private:
	import nuklear_sdl_gl3;

	DemoApplication _app;
	nk_colorf _bg;
}