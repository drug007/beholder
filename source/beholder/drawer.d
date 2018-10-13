module beholder.drawer;

import std.traits : isStaticArray, isDynamicArray, isAggregateType, isArray, 
	isSomeString, isPointer, isSomeChar;
import std.range : ElementType;

enum textBufferSize = 1024;
enum itemHeight = 21;
enum fieldWidth = 80;

struct Drawer(T) if (
	!isAggregateType!T && 
	!isPointer!T &&
	(!isArray!T || isSomeString!T)
)
{
	int selected;

	this(const(T) t) {
		// by default do nothing
	}

	float draw(Context, T)(Context ctx, const(char)[] header, T t)
	{
		import nuklear_sdl_gl3;
		import std.format : sformat;
		char[textBufferSize] buffer;
		if (header.length)
			sformat(buffer[], "%s: %s\0", header, t);
		else
			sformat(buffer[], "%s\0", t);
		nk_selectable_label(ctx, buffer.ptr, NK_TEXT_LEFT, &selected);

		return ctx.current.layout.row.height;
	}
}

struct Drawer(T) if (isPointer!T && !isAggregateType!T)
{
	int selected;

	this(T t) {
		// by default do nothing
	}

	float draw(Context, T)(Context ctx, const(char)[] header, T t)
	{
		import nuklear_sdl_gl3;
		import std.format : sformat;
		char[textBufferSize] buffer;
		if (header.length)
			sformat(buffer, "%s: %x\0", header, t);
		else
			sformat(buffer, "%x\0", t);
		nk_selectable_label(ctx, buffer.ptr, NK_TEXT_LEFT, &selected);
		return ctx.current.layout.row.height;
	}
}

struct Drawer(T) if (isStaticArray!T && !isSomeChar!(ElementType!T))
{
	import std.range : ElementType;

	import nuklear_sdl_gl3 : nk_collapse_states;

	nk_collapse_states collapsed;
	int selected;
	Drawer!(ElementType!T)[T.length] state;

	this(const T a)
	{
		static foreach(i; 0..a.length)
			state[i] = Drawer!(ElementType!T)(a[i]);
	}

	float draw(Context, T)(Context ctx, const(char)[] header, ref T a)
	{
		import std.format : sformat;
		import nuklear_sdl_gl3;

		char[textBufferSize] buffer;
		float height = 0;

		auto formatted_output = sformat(buffer[], "%s (%d)\0", header, a.length);
		if (nk_tree_state_push(ctx, NK_TREE_NODE, formatted_output.ptr, &collapsed))
		{
			assert(state.length == a.length);
			nk_list_view view;
			// set layout height for the whole list view
			// it lets nk_list_view calculates its parameters
			nk_layout_row_dynamic(ctx, itemHeight*(a.length+1), 1);
			if (nk_list_view_begin(ctx, &view, "statarr", NK_WINDOW_BORDER, itemHeight, a.length)) 
			{
				// set layout for list view elements to draw them properly
				nk_layout_row_dynamic(ctx, itemHeight, 1);
				foreach(i; 0..view.count)
				{
					height += state[view.begin + i].draw(ctx, "", a[view.begin + i]);
				}
				nk_list_view_end(&view);
			}
			nk_tree_pop(ctx);
			// restore layout height
			nk_layout_row_dynamic(ctx, itemHeight, 1);
		}
		return height;
	}
}

struct Drawer(T) if (isStaticArray!T && isSomeChar!(ElementType!T))
{
	int selected;

	this(ref const(T) t) {
		// by default do nothing
	}

	float draw(Context)(Context ctx, const(char)[] header, ref const(T) t)
	{
		import nuklear_sdl_gl3;
		import std.format : sformat;
		char[textBufferSize] buffer;
		if (header.length)
			sformat(buffer[], "%s: %s\0", header, t[]);
		else
			sformat(buffer[], "%s\0", t[]);
		nk_selectable_label(ctx, buffer.ptr, NK_TEXT_LEFT, &selected);
		return ctx.current.layout.row.height;
	}
}

struct Drawer(A) if (!isSomeString!A && isDynamicArray!A)
{
	import std.array : uninitializedArray;
	import std.range : ElementType;

	import nuklear_sdl_gl3 : nk_collapse_states;

	nk_collapse_states collapsed;
	Drawer!(ElementType!A)[] state;

	this(const A a)
	{
		update(a);
	}

	void update(const A a)
	{
		state = uninitializedArray!(typeof(state))(a.length);
		foreach(i; 0..a.length)
			state[i] = Drawer!(ElementType!A)(a[i]);
	}

	/// draws all elements
	float draw(Context)(Context ctx, const(char)[] header, const(A) a)
	{
		import std.format : sformat;
		import nuklear_sdl_gl3;

		char[textBufferSize] buffer;
		float height = 0;

		auto formatted_output = sformat(buffer[], "%s (%d)\0", header, a.length);
		if (nk_tree_state_push(ctx, NK_TREE_NODE, formatted_output.ptr, &collapsed))
		{
			assert(state.length == a.length);
			nk_list_view view;
			nk_layout_row_dynamic(ctx, itemHeight * 25, 1);
			if (nk_list_view_begin(ctx, &view, "dynarr", NK_WINDOW_BORDER, itemHeight, cast(int)a.length)) 
			{
				foreach(i; 0..view.count)
				{
					formatted_output = sformat!"%s[%d]\0"(buffer[], header, view.begin + i);
					height += state[view.begin + i].draw(ctx, formatted_output, a[view.begin + i]);
				}
				nk_list_view_end(&view);
			}
			nk_tree_pop(ctx);
		}

		return height;
	}

	/// draws part of elements
	float draw(Context)(Context ctx, A a, Drawer!(ElementType!A)[] state)
	{
		import std.format : sformat;
		import nuklear_sdl_gl3;

		char[textBufferSize] buffer;
		float height = 0;

		assert(state.length == a.length);
		foreach(i; 0..a.length)
		{
			height += state[i].draw(ctx, "\0", a[i]);
		}
		return height;
	}
}

import std.traits : isInstanceOf;
import taggedalgebraic : TaggedAlgebraic;

// non Nullable TaggedAlgebraic aggregate type
struct Drawer(T) if (isInstanceOf!(TaggedAlgebraic, T) && !isNullable!T)
{
	struct Payload
	{
		static foreach(i; 0..T.Union.tupleof.length)
		{
			mixin("Drawer!(typeof(T.Union." ~ T.Union.tupleof[i].stringof ~ ")) state_" ~ T.Union.tupleof[i].stringof ~ ";");
		}
	}

	import nuklear_sdl_gl3 : nk_collapse_states;

	nk_collapse_states collapsed;
	int selected;
	TaggedAlgebraic!Payload state;

	this(ref const(T) t)
	{
		update(t);
	}

	/// updates size of underlying data
	void update()(auto ref inout(T) t)
	{
		Lexit:
		final switch (t.kind)
		{
			static foreach(i; 0..t.Union.tupleof.length)
			{
		mixin("case T.Kind." ~ t.Union.tupleof[i].stringof ~ ":");
				{
					import taggedalgebraic : TypeOf, get;
					alias PayloadType = TypeOf!(mixin("T.Kind." ~ t.Union.tupleof[i].stringof));
					state = Drawer!PayloadType(t.get!PayloadType);
					break Lexit;
				}
			}
		}
	}

	/// draws current value
	float draw(Context)(Context ctx, const(char)[] header, auto ref const(T) t)
	{
		import nuklear_sdl_gl3;

		char[textBufferSize] buffer;
		float height = 0;

		if (nk_tree_state_push(ctx, NK_TREE_NODE, header.ptr, &collapsed))
		{
			Lexit:
			final switch (t.kind)
			{
				static foreach(i; 0..t.Union.tupleof.length)
				{
			mixin("case T.Kind." ~ t.Union.tupleof[i].stringof ~ ":");
					{
						import taggedalgebraic : TypeOf, get;
						enum FieldName = t.Union.tupleof[i].stringof;
						alias FieldType = TypeOf!(mixin("T.Kind." ~ FieldName));
						alias DrawerType = Drawer!FieldType;
						if (cast(int)state.kind != cast(int)t.kind)
						{
							auto old_collapsed = state.collapsed;
							auto old_selected  = state.selected;
							state = Drawer!FieldType(t.get!FieldType);
							with(state.get!DrawerType)
							{
								collapsed = old_collapsed;
								selected  = old_selected;
							}
						}
						height += state.get!DrawerType.draw(ctx, FieldName, t.get!FieldType);
						break Lexit;
					}
				}
			}
			nk_tree_pop(ctx);
		}

		return height;
	}
}

// Nullable, non TaggedAlgebraic aggregate type
struct Drawer(T) if (isAggregateType!T && !isInstanceOf!(TaggedAlgebraic, T) && isNullable!T)
{
	import std.traits : isSomeFunction, ReturnType, isArray, hasMember;
	import nuklear_sdl_gl3 : nk_collapse_states;

	nk_collapse_states collapsed;
	int selected;

	static if (hasMember!(T, "get"))
	{
		enum memberTypeIsGet = true;
		alias State = Drawer!(ReturnType!(T.get));
	}
	else static if (hasMember!(T, "value"))
	{
		enum memberTypeIsGet = false;
		alias State = Drawer!(ReturnType!(T.value));
	}
	else
		static assert(0);

	State state;

	this()(auto ref const(T) t)
	{
		update(t);
	}

	/// updates size of underlying data
	void update()(auto ref inout(T) t)
	{
		static if(memberTypeIsGet)
			state = t.isNull ? State() : State(t.get);
		else
			state = t.isNull ? State() : State(t.value);
	}

	/// draws all fields
	float draw(Context)(Context ctx, const(char)[] header, auto ref const(T) t)
	{
		import std.format : sformat;
		import nuklear_sdl_gl3;

		char[textBufferSize] buffer;
		auto title = sformat(buffer[], "%s\0", header);

		import std.string : fromStringz;
		
		if (t.isNull)
		{
			if (header.length)
				title = sformat(buffer[], "%s: null\0", header.ptr.fromStringz);
			else
				title = sformat(buffer[], "null\0", t);

			nk_layout_row_dynamic(ctx, itemHeight, 1);
			nk_selectable_label(ctx, title.ptr, NK_TEXT_LEFT, &selected);
			return itemHeight;
		}

		static if(memberTypeIsGet)
			return state.draw(ctx, title, t.get);
		else
			return state.draw(ctx, title, t.value);
	}
}

// Non Nullable, non TagggedAlgebraic aggregate type
struct Drawer(T) if (isAggregateType!T && !isInstanceOf!(TaggedAlgebraic, T) && !isNullable!T)
{
	import std.traits : isSomeFunction, ReturnType, isArray;
	import nuklear_sdl_gl3 : nk_collapse_states;

	nk_collapse_states collapsed;
	int selected;

	static foreach(member; DrawableMembers!T) 
	{
		static if (isSomeFunction!(mixin("typeof(T." ~ member ~ ")")))
			mixin("Drawer!(ReturnType!(T." ~ member ~ ")) state_" ~ member ~ ";");
		else
			mixin("Drawer!(typeof(T." ~ member ~ ")) state_" ~ member ~ ";");
	}

	this()(auto ref const(T) t)
	{
		update(t);
	}

	/// updates size of underlying data
	void update()(auto ref const(T) t)
	{
		static foreach(member; DrawableMembers!T)
		{{
			static if (isSomeFunction!(mixin("typeof(t." ~ member ~ ")")))
				mixin("state_" ~ member ~ " = Drawer!(ReturnType!(T." ~ member ~ "))(t." ~ member ~ ");");
			else
			{
				alias Field = typeof(mixin("state_" ~ member));
				mixin("state_" ~ member) = Field(mixin("t." ~ member ));
			}
		}}
	}

	/// draws all fields
	float draw(Context)(Context ctx, const(char)[] header, auto ref const(T) t)
	{
		import std.format : sformat;
		import nuklear_sdl_gl3;

		char[textBufferSize] buffer;
		float height = 0;

		sformat(buffer[], "%s\0", header);

		static if (DrawableMembers!t.length == 1)
		{
			nk_layout_row_dynamic(ctx, itemHeight, 1);
			static foreach(member; DrawableMembers!t)
				mixin("state_" ~ member ~ ".draw(ctx, \"" ~ member ~"\", t." ~ member ~ ");");
		}
		else
		{
			if (nk_tree_state_push(ctx, NK_TREE_NODE, buffer.ptr, &collapsed))
			{
				scope(exit)
					nk_tree_pop(ctx);
				
				static foreach(member; DrawableMembers!t) 
				{
					mixin("height += state_" ~ member ~ ".draw(ctx, \"" ~ member ~"\", t." ~ member ~ ");");
				}
			}
		}
		return height;
	}
}

//*****************************************************************************
// helpers
//*****************************************************************************

import std.traits : isTypeTuple;

private template isNullable(T)
{
	import std.traits : hasMember;

	static if (
		hasMember!(T, "isNull") &&
		is(typeof(__traits(getMember, T, "isNull")) == bool) &&
		(
			(hasMember!(T, "get") && !is(typeof(__traits(getMember, T, "get")) == void)) ||
			(hasMember!(T, "value") && !is(typeof(__traits(getMember, T, "value")) == void))
		) &&
		hasMember!(T, "nullify") &&
		is(typeof(__traits(getMember, T, "nullify")) == void)
	)
	{
		enum isNullable = true;
	}
	else
	{
		enum isNullable = false;
	}
}

private bool privateOrPackage()(string protection)
{
	return protection == "private" || protection == "package";
}

// check if the member is readable/writeble?
private enum isReadableAndWritable(alias aggregate, string member) = __traits(compiles, __traits(getMember, aggregate, member) = __traits(getMember, aggregate, member));
private enum isPublic(alias aggregate, string member) = !__traits(getProtection, __traits(getMember, aggregate, member)).privateOrPackage;

// check if the member is property with const qualifier
private template isConstProperty(alias aggregate, string member)
{
	import std.traits : isSomeFunction, hasFunctionAttributes;

	static if(isSomeFunction!(__traits(getMember, aggregate, member)))
		enum isConstProperty = hasFunctionAttributes!(__traits(getMember, aggregate, member), "const", "@property");
	else
		enum isConstProperty = false;
}

// check if the member is readable
private enum isReadable(alias aggregate, string member) = __traits(compiles, { auto _val = __traits(getMember, aggregate, member); });

private template isItSequence(T...)
{
	static if (T.length < 2)
		enum isItSequence = false;
	else
		enum isItSequence = true;
}

private template hasProtection(alias aggregate, string member)
{
	enum hasProtection = __traits(compiles, { enum pl = __traits(getProtection, __traits(getMember, aggregate, member)); });
}

// This trait defines what members should be drawn -
// public members that are either readable and writable or getter properties
private template Drawable(alias value, string member)
{
	import std.algorithm : among;
	import std.traits : isTypeTuple, isSomeFunction;

	static if (isItSequence!value)
		enum Drawable = false;
	else
	static if (hasProtection!(value, member) && !isPublic!(value, member))
			enum Drawable = false;
	else
	static if (is(typeof(__traits(getMember, value, member)) == enum))
		enum Drawable = false;
	else
	static if (isItSequence!(__traits(getMember, value, member)))
		enum Drawable = false;
	else
	static if(member.among("__ctor", "__dtor"))
		enum Drawable = false;
	else
	static if (isReadableAndWritable!(value, member) && !isSomeFunction!(__traits(getMember, value, member)))
		enum Drawable = true;
	else
	static if (isReadable!(value, member))
		enum Drawable = isConstProperty!(value, member); // a readable property is getter
	else
		enum Drawable = false;
}

/// returns alias sequence, members of which are members of value
/// that should be drawn
private template DrawableMembers(alias A)
{
	import std.meta : ApplyLeft, Filter, AliasSeq;
	import std.traits : isType, Unqual;

	static if (isType!A)
	{
		alias Type = Unqual!A;
	}
	else
	{
		alias Type = Unqual!(typeof(A));
	}

	Type symbol;

	alias AllMembers = AliasSeq!(__traits(allMembers, Type));
	alias isProper = ApplyLeft!(Drawable, symbol);
	alias DrawableMembers = Filter!(isProper, AllMembers);
}
