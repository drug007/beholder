module beholder.drawer;

import std.traits : isStaticArray, isDynamicArray, isAggregateType, isArray, isSomeString;

enum textBufferSize = 256;
enum itemHeight = 25;
enum ident = 20;
enum fieldWidth = 80;

struct Drawer(T) if (!isAggregateType!T && (!isArray!T || isSomeString!T))
{
	import std.typecons : Flag;
	int selected;

	@disable this();
	this(ref T t) {
		// by default do nothing
	}

	void draw(Context, T)(Context ctx, const(char)[] header, ref T t)
	{
		import nuklear_sdl_gl3;
		import std.format : sformat;
		char[textBufferSize] buffer;
		if (header.length)
			sformat(buffer, "%s: %s\0", header, t);
		else
			sformat(buffer, "%s\0", t);
		nk_selectable_label(ctx, buffer.ptr, NK_TEXT_LEFT, &selected);
	}
}

struct Drawer(T) if (!isSomeString!T && isStaticArray!T)
{
	import std.range : ElementType;
	import std.typecons : Flag;

	import nuklear_sdl_gl3 : nk_collapse_states;

	nk_collapse_states collapsed;
	int selected;
	Drawer!(ElementType!T)[T.length] state;

	@disable this();
	this(T a)
	{
		static foreach(i; 0..a.length)
			state[i] = Drawer!(ElementType!T)(a[i]);
	}

	void draw(Context, T)(Context ctx, const(char)[] header, ref T a)
	{
		import std.format : sformat;
		import nuklear_sdl_gl3;

		char[textBufferSize] buffer;

		auto formatted_output = sformat(buffer, "%s (%d)\0", header, a.length);
		if (nk_tree_state_push(ctx, NK_TREE_NODE, formatted_output.ptr, &collapsed))
		{
			assert(state.length == a.length);
			static foreach(i; 0..a.length)
			{
				state[i].draw(ctx, "", a[i]);
			}
			nk_tree_pop(ctx);
		}
	}
}

struct Drawer(A) if (!isSomeString!A && isDynamicArray!A)
{
	import std.array : uninitializedArray;
	import std.range : ElementType;

	import nuklear_sdl_gl3 : nk_collapse_states;

	nk_collapse_states collapsed;
	Drawer!(ElementType!A)[] state;

	@disable this();
	this(A a)
	{
		state = uninitializedArray!(typeof(state))(a.length);
		foreach(i; 0..a.length)
			state[i] = Drawer!(ElementType!A)(a[i]);
	}

	void update(A a)
	{
		state = uninitializedArray!(typeof(state))(a.length);
		foreach(i; 0..a.length)
			state[i] = Drawer!(ElementType!A)(a[i]);
	}

	/// draws all elements
	void draw(Context)(Context ctx, const(char)[] header, A a)
	{
		import std.format : sformat;
		import nuklear_sdl_gl3;

		char[textBufferSize] buffer;

		auto formatted_output = sformat(buffer, "%s (%d)\0", header, a.length);
		if (nk_tree_state_push(ctx, NK_TREE_NODE, formatted_output.ptr, &collapsed))
		{
			assert(state.length == a.length);
			foreach(i; 0..a.length)
			{
				formatted_output = sformat(buffer, "%s[%d]\0", header, i);
				state[i].draw(ctx, formatted_output, a[i]);
			}
			nk_tree_pop(ctx);
		}
	}
}

struct Drawer(T) if (isAggregateType!T)
{
	import std.traits : isArray;
	import nuklear_sdl_gl3 : nk_collapse_states;

	nk_collapse_states collapsed;
	int selected;

	static foreach(i; 0..T.tupleof.length)
	{
		mixin("Drawer!(typeof(T." ~ T.tupleof[i].stringof ~ ")) state_" ~ T.tupleof[i].stringof ~ ";");
	}

	@disable this();

	this(ref T t)
	{
		static foreach(i; 0..T.tupleof.length)
		{
			// generates string like
			//     state_field_name = Drawer!(typeof(T.field_name))(t.field_name);
			mixin("state_" ~ T.tupleof[i].stringof ~ " = Drawer!(typeof(T." ~ T.tupleof[i].stringof ~ "))(t." ~ T.tupleof[i].stringof ~ ");");
		}
	}

	/// updates size of underlying data
	void update(ref T t)
	{
		static foreach(i; 0..T.tupleof.length)
		{
			// generates string like
			//     state_field_name = Drawer!(typeof(T.field_name))(t.field_name);
			mixin("state_" ~ T.tupleof[i].stringof ~ " = Drawer!(typeof(T." ~ T.tupleof[i].stringof ~ "))(t." ~ T.tupleof[i].stringof ~ ");");
		}
	}

	/// draws all fields
	void draw(Context)(Context ctx, const(char)[] header, ref T t)
	{
		import std.traits : FieldNameTuple;
		import nuklear_sdl_gl3;

		char[textBufferSize] buffer;

		if (nk_tree_state_push(ctx, NK_TREE_NODE, header.ptr, &collapsed))
		{
			// first two elements of tupleof is `collapsed` and `selected` so skip them
			static foreach(i; 2..this.tupleof.length) 
			{
				this.tupleof[i].draw(ctx, FieldNameTuple!T[i-2], t.tupleof[i-2]);
			}
			nk_tree_pop(ctx);
		}
	}
}