module demo;

import gfm.math : vec3f, vec4f;
import taggedalgebraic : TaggedAlgebraic;

import beholder.nuklearapp : NuklearApp;

class Application : NuklearApp
{
	import std.typecons : Nullable;
	import gfm.math : vec2f;
	import nuklear_sdl_gl3;
	import beholder.drawer : drawer, DrawerOf;

	TaWrapper ta_wrapper;
	DrawerOf!ta_wrapper ta_wrapper_drawer;

	TaWrapper[] ta_array;
	DrawerOf!ta_array ta_array_wrapper;
	
	this(string title, int w, int h, Application.FullScreen flag)
	{
		super(title, w, h, flag);

		ctx = nk_sdl_init(&window());
		nk_font_atlas *atlas;
		nk_sdl_font_stash_begin(&atlas);
		nk_sdl_font_stash_end();

		auto test_struct = TestStruct(111, 1.23, "Test structure", TestEnum.middle, Nested([3, 9, 11], "nested struct"));

		{
			ta_wrapper = Nested([3, 9, 11], "one nested struct");
			ta_wrapper_drawer = drawer(ta_wrapper);
		}

		{
			ta_array ~= TaWrapper(2);
			ta_array ~= TaWrapper(3.0);
			ta_array ~= TaWrapper("some str");
			ta_array ~= TaWrapper("another str");
			ta_array ~= TaWrapper("yet another str");
			ta_array ~= TaWrapper(100.0);
			ta_array ~= TaWrapper(Nested());
			ta_array ~= TaWrapper(200);
			ta_array ~= TaWrapper(Nested([2, 21], "another nested struct"));

			ta_array_wrapper = drawer(ta_array);
		}
	}

	override void onIdle()
	{
		if (nk_begin(ctx, "User defined types", nk_rect(25+230+25+250+25, 50, 300, 600),
			NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
			NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
		{
			ta_wrapper_drawer.makeLayout(ctx);
			ta_wrapper_drawer.draw(ctx, "TaggedAlgebraic", ta_wrapper);

			ta_array_wrapper.makeLayout(ctx);
			ta_array_wrapper.draw(ctx, "The list of heterogeneous data", ta_array);
		}
		nk_end(ctx);

		nk_sdl_render(NK_ANTI_ALIASING_ON, MAX_VERTEX_MEMORY, MAX_ELEMENT_MEMORY);
	}
}



	enum TestEnum : ulong { left, middle, right, }

	struct Nested
	{
		float[] farr;
		string str;
	}

	struct TestStruct
	{
		int i;
		float f;
		string str;
		TestEnum e;
		Nested nested;
	}

	struct TaWrapper
	{
		private TaggedAlgebraic!TestStruct _ta;

		ref auto get() inout { return _ta; }

		alias get this;

		this(T)(auto ref T t)
		{
			_ta = t;
		}
	}

int main(string[] args)
{
	auto app = new Application("Demo gui application", 1200, 768, Application.FullScreen.no);
	scope(exit) app.destroy();

	app.run();

	return 0;
}
