module beholder.panel;

class Panel
{
	import bindbc.nuklear;

	nk_colorf bg;
	enum {EASY, HARD}
	int op;
	int property;
	float w, h, x, y;
	string name;

	this(string name, float x, float y, float w, float h, nk_colorf bg)
	{
		this.bg = bg;
		op = EASY;
		property = 20;
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.name = name ~ '\0';
	}

	void draw(C)(C ctx)
	{
		import core.stdc.stdio;

		if (nk_begin(ctx, name.ptr, nk_rect(x, y, w, h),
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
	}
}