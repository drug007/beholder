module demo;

import gfm.math : vec3f, vec4f;
import taggedalgebraic : TaggedAlgebraic;

import beholder.application : Application;

class NuklearApplication : Application
{
	import std.typecons : Nullable;
	import gfm.math : vec2f;
	import beholder.nuklear_sdl_gl3;
	import beholder.drawer : drawer, DrawerOf;
	import bindbc.nuklear;

	enum MAX_VERTEX_MEMORY = 512 * 1024;
	enum MAX_ELEMENT_MEMORY = 128 * 1024;

	nk_context* ctx;

	import std.typetuple : AliasSeq;
	import beholder.drawer : SupportedBasicTypeSequence;

	// init values for fields of supported built in types
	alias BasicTypeValuesSequence = AliasSeq!(
		/* bool   */            true, 
		/* byte   */             127, 
		/* ubyte  */             255, 
		/* short  */       short.min, 
		/* ushort */           65535, 
		/* int,   */       -1000_000,
		/* uint   */         200_000, 
		/* long   */  16_000_000_000, 
		/* ulong  */ -16_000_000_000, 
		/* float  */ 1.234567890123456789e10, 
		/* double */ 1.234567890123456789e10, 
		/* char   */ 'A', 
		/* wchar  */ 'B', 
		/* dchar  */ 'C',
	);

	/** not supported built in types
		void
		cent
		ucent
		real
		ifloat
		idouble
		ireal
		cfloat
		cdouble
		creal
	*/

	static foreach(T; SupportedBasicTypeSequence)
	{
		// generate code like `float float_value;`
		mixin(T.stringof ~ " " ~ T.stringof ~ "_value;");
		// generate code like `DrawerOf!float_value float_drawer;`
		mixin("DrawerOf!" ~ T.stringof ~ "_value " ~ T.stringof ~ "_drawer;");
	}

	/** Derived types:
		pointer
		array
			dynamic array of some char (string)
			dynamic array of non some char (string)
			static array of some char
			static array of non some char
		associative array
		function - not applicable
		delegate - not applicable
	**/

	double* double_ptr;
	char[]  dyn_arr_of_char;
	int[]   dyn_arr_of_int, empty_int_arr;
	char[6] st_arr_of_char;
	int[6]  st_arr_of_int;
	string[string] aa_str_str;
	int[int] aa_int_int;

	DrawerOf!double_ptr      double_ptr_drawer;
	DrawerOf!dyn_arr_of_char dyn_arr_of_char_drawer;
	DrawerOf!dyn_arr_of_int  dyn_arr_of_int_drawer;
	DrawerOf!st_arr_of_char  st_arr_of_char_drawer;
	DrawerOf!st_arr_of_int   st_arr_of_int_drawer;
	DrawerOf!aa_str_str      aa_str_str_drawer;
	DrawerOf!aa_int_int      aa_int_int_drawer;
	DrawerOf!empty_int_arr   empty_int_arr_drawer;

	/** User defined types
		enum
		struct
		union - not implemented
		class - not implemented
	*/

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
		Nested nested;
	}

	TestEnum   test_enum;
	TestStruct test_struct;

	DrawerOf!test_enum     test_enum_drawer;
	DrawerOf!test_struct test_struct_drawer;

	TaggedAlgebraic!TestStruct tagged_algebraic1, tagged_algebraic2;
	DrawerOf!tagged_algebraic1 tagged_algebraic1_drawer;
	DrawerOf!tagged_algebraic2 tagged_algebraic2_drawer;

	Nullable!int nullable_int1, nullable_int2;
	Nullable!TestStruct nullable_test_struct1, nullable_test_struct2;

	DrawerOf!nullable_int1 nullable_int1_drawer;
	DrawerOf!nullable_int2 nullable_int2_drawer;
	DrawerOf!nullable_test_struct1 nullable_test_struct1_drawer;
	DrawerOf!nullable_test_struct2 nullable_test_struct2_drawer;

	import beholder.drawer : horizontal;

	@horizontal
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

	@horizontal
	TaWrapper ta_wrapper;

	import std.traits : getUDAs;
	enum udas1 = [getUDAs!(ta_wrapper, Rendering)];
	pragma(msg, "ta_wrapper: ", typeof(udas1), " ", udas1);
	
	enum udas2 = [getUDAs!(TaWrapper, Rendering)];
	pragma(msg, "TaWrapper: ", typeof(udas2), " ", udas2);

	DrawerOf!ta_wrapper ta_wrapper_drawer;

	struct IntWrapper
	{
		int value;
		alias value this;

		this(int v)
		{
			value = v;
		}
	}

	IntWrapper int_wrapper;
	DrawerOf!int_wrapper int_wrapper_drawer;

	struct AStructRenderedAsString
	{
		int i;
		float f;
		bool b;

		string renderedAs() const
		{
			return "This struct is rendered as string";
		}
	}

	import beholder.drawer : renderingIgnore, Rendering, RenderedAs;

	struct Proxy
	{
		const(TestStruct)* ts;
		this(ref const(TestStruct) ts)
		{
			this.ts = &ts;
		}
		
		string renderedAs() const
		{
			return "ts.f";//ts.f;
		}
	}
	
	struct StructWithUDA
	{
		double d;
		char ch;
		AStructRenderedAsString struct_rendered_as_string;

		@renderingIgnore
		string you_should_not_see_this_field;
		@RenderedAs!Proxy
		TestStruct ts;

		string str1;
		double d2;
		int[] ai;
		@renderingIgnore
		int ignored2;
	}
	StructWithUDA struct_with_uda;
	DrawerOf!struct_with_uda struct_with_uda_drawer;

	TaWrapper[] ta_array;
	DrawerOf!ta_array ta_array_wrapper;
	
	this(string title, int w, int h, Application.FullScreen flag)
	{
		super(title, w, h, flag);

		ctx = nk_sdl_init(window().nativeWindow);
		nk_font_atlas *atlas;
		nk_sdl_font_stash_begin(&atlas);
		nk_sdl_font_stash_end();

		// basic data types
		static foreach(int i, T; SupportedBasicTypeSequence)
		{
			// generate code like `float_value = float.init;`
			mixin(T.stringof ~ "_value = " ~ T.stringof ~ "(BasicTypeValuesSequence[i]);");
			// generate code like `float_drawer = drawer(float_value);`
			mixin(T.stringof ~ "_drawer = drawer(" ~ T.stringof ~ "_value);");
		}

		// derived data types
		{
			double_ptr = &double_value;
			dyn_arr_of_char = cast(char[]) "Dynamic array of char";
			dyn_arr_of_int = [1, 100, 200, 300, 1000];
			st_arr_of_char = "abcdef";
			st_arr_of_int = [ 11, 12, 13, 14, 15, 16, ];
			aa_str_str = [ "abc" : "cba", "qwe" : "ewq", "asd" : "dsa"];
			aa_int_int = [ 100 : 2, 200 : 3, 300 : 4];
			empty_int_arr = null;

			double_ptr_drawer      = drawer(double_ptr);
			dyn_arr_of_char_drawer = drawer(dyn_arr_of_char);
			dyn_arr_of_int_drawer  = drawer(dyn_arr_of_int);
			st_arr_of_char_drawer  = drawer(st_arr_of_char);
			st_arr_of_int_drawer   = drawer(st_arr_of_int);
			aa_str_str_drawer      = drawer(aa_str_str);
			aa_int_int_drawer      = drawer(aa_int_int);
			empty_int_arr_drawer   = drawer(empty_int_arr);
		}

		// user defined types
		{
			test_enum   = TestEnum.middle;
			test_struct = TestStruct(111, 1.23, "Test structure", Nested([3, 9, 11], "nested struct"));

			test_struct_drawer = drawer(test_struct);
		}

		{
			tagged_algebraic1 = test_struct.str;
			tagged_algebraic2 = test_struct.nested;

			tagged_algebraic1_drawer = drawer(tagged_algebraic1);
			tagged_algebraic2_drawer = drawer(tagged_algebraic2);
		}

		{
			nullable_int1.nullify;
			nullable_int2 = 123456789;

			nullable_int1_drawer = drawer(nullable_int1);
			nullable_int2_drawer = drawer(nullable_int2);

			nullable_test_struct1.nullify;
			nullable_test_struct2 = test_struct;

			nullable_test_struct1_drawer = drawer(nullable_test_struct1);
			nullable_test_struct2_drawer = drawer(nullable_test_struct2);
		}

		{
			ta_wrapper = test_struct.nested;
			ta_wrapper_drawer = drawer(ta_wrapper);

			int_wrapper = 456;
			int_wrapper_drawer = drawer(int_wrapper);

			import beholder.drawer : Description, Kind;
			static assert(Description!(typeof(int_wrapper)).kind == Kind.oneliner,
				"Aggregate with one member that is `alias thised` is oneliner");
		}

		{
			struct_with_uda = StructWithUDA(100, 'D');
			struct_with_uda_drawer = drawer(struct_with_uda);
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

			ta_array_wrapper = drawer(ta_array);
		}
	}

	~this()
	{
		nk_sdl_shutdown();
	}

	override void draw()
	{
		super.draw();

		if (nk_begin(ctx, "Basic data types values", nk_rect(25, 50, 230, 270),
			NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
			NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
		{
			static foreach(T; SupportedBasicTypeSequence)
			{
				// generate code like:
				// float_drawer.draw(ctx, `float value`, float_value);
				mixin(T.stringof ~ "_drawer.draw(ctx, `" ~ T.stringof ~ "`, " ~ T.stringof ~ "_value);");
			}
		}
		nk_end(ctx);

		if (nk_begin(ctx, "Derived data types", nk_rect(25+230+25, 50, 250, 270),
			NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
			NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
		{
			import std.conv : text;
			double_ptr_drawer     .draw(ctx, `Pointer to double`, double_ptr);
			dyn_arr_of_char_drawer.draw(ctx, `char[]`, dyn_arr_of_char);
			st_arr_of_char_drawer .draw(ctx, `char[` ~ st_arr_of_char.length.text ~ `]`, st_arr_of_char);
			aa_str_str_drawer     .draw(ctx, `string[string]`, aa_str_str);
			aa_int_int_drawer     .draw(ctx, `int[int]`, aa_int_int);
			dyn_arr_of_int_drawer .draw(ctx, `int[]`, dyn_arr_of_int);
			st_arr_of_int_drawer  .draw(ctx, `int[` ~ st_arr_of_int.length.text ~ `]`, st_arr_of_int);
			empty_int_arr_drawer  .draw(ctx, `int[` ~ empty_int_arr.length.text ~ `]`, empty_int_arr);
		}
		nk_end(ctx);

		if (nk_begin(ctx, "User defined types", nk_rect(25+230+25+250+25, 50, 300, 600),
			NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
			NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
		{
			test_enum_drawer  .draw(ctx, `test enum`,   test_enum);
			test_struct_drawer.draw(ctx, `test struct`, test_struct);

			tagged_algebraic1_drawer.draw(ctx, "TaggedAlgebraic #1", tagged_algebraic1);
			tagged_algebraic2_drawer.draw(ctx, "TaggedAlgebraic #2", tagged_algebraic2);

			nullable_int1_drawer.draw(ctx, "Nullable!int w/o value", nullable_int1);
			nullable_int2_drawer.draw(ctx, "Nullable!int with value", nullable_int2);

			nullable_test_struct1_drawer.draw(ctx, "Nullable!test_struct w/o value", nullable_test_struct1);
			nullable_test_struct2_drawer.draw(ctx, "Nullable!test_struct with value", nullable_test_struct2);

			ta_wrapper_drawer.draw(ctx, "TaggedAlgebraic", ta_wrapper);

			int_wrapper_drawer.draw(ctx, "Int wrapper", int_wrapper);

			struct_with_uda_drawer.draw(ctx, "Struct with UDA + renderedAs", struct_with_uda);

			ta_array_wrapper.draw(ctx, "TaWrapper[]", ta_array);
		}
		nk_end(ctx);

		if (nk_begin(ctx, "Debug", nk_rect(25+230+25+250+25+300+25, 50, 290, 450),
			NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
			NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
		{
			import core.stdc.stdio;

			enum height = 11;
			int selected;
			char[256] buffer;

			snprintf(buffer.ptr, buffer.length, "height: %f", tagged_algebraic2_drawer.wrapper.state_farr.height);

			nk_layout_row_dynamic(ctx, height, 1);
			nk_selectable_label(ctx, buffer.ptr, NK_TEXT_LEFT, &selected);
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
	import bindbc.nuklear;
	version(BindNuklear_Static) {}
	else
	{
		NuklearSupport nuksup = loadNuklear();
		if(nuksup != NuklearSupport.Nuklear4)
		{
			import core.stdc.stdio;
			printf("Error: Nuklear library is not found.");
			return -1;
		}
	}

	auto app = new NuklearApplication("Demo gui application", 1200, 768, Application.FullScreen.no);
	scope(exit) app.destroy();

	app.run();

	return 0;
}
