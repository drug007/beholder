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

	@disable this();

	this(ref T t)
	{
		static foreach(member; DrawableMembers!T)
		{
			// generates string like
			//     state_field_name = Drawer!(ReturnType!(T.field_name))(t.field_name);
			// or
			//     state_field_name = Drawer!(typeof(T.field_name))(t.field_name);
			static if (isSomeFunction!(mixin("typeof(T." ~ member ~ ")")))
				mixin("state_" ~ member ~ " = Drawer!(ReturnType!(T." ~ member ~ "))(t." ~ member ~ ");");
			else
				mixin("state_" ~ member ~ " = Drawer!(typeof(T." ~ member ~ "))(t." ~ member ~ ");");
		}
	}

	/// updates size of underlying data
	void update(ref T t)
	{
		static foreach(member; DrawableMembers!T)
		{
			// generates string like
			//     state_field_name = Drawer!(ReturnType!(T.field_name))(t.field_name);
			// or
			//     state_field_name = Drawer!(typeof(T.field_name))(t.field_name);
			static if (isSomeFunction!(mixin("typeof(T." ~ member ~ ")")))
				mixin("state_" ~ member ~ " = Drawer!(ReturnType!(T." ~ member ~ "))(t." ~ member ~ ");");
			else
				mixin("state_" ~ member ~ " = Drawer!(typeof(T." ~ member ~ "))(t." ~ member ~ ");");
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
			static foreach(member; DrawableMembers!t) 
			{
				mixin("state_" ~ member ~ ".draw(ctx, \"" ~ member ~"\", t." ~ member ~ ");");
			}

			nk_tree_pop(ctx);
		}
	}
}

//*****************************************************************************
// helpers
//*****************************************************************************

import std.traits : isTypeTuple;

private bool privateOrPackage()(string protection)
{
	return protection == "private" || protection == "package";
}

// check if the member is readable/writeble?
private enum isReadableAndWritable(alias aggregate, string member) = __traits(compiles, __traits(getMember, aggregate, member) = __traits(getMember, aggregate, member));
private enum isPublic(alias aggregate, string member) = !__traits(getProtection, __traits(getMember, aggregate, member)).privateOrPackage;

// check if the member is property
private template isProperty(alias aggregate, string member)
{
	import std.traits : isSomeFunction, functionAttributes, FunctionAttribute;

	static if(isSomeFunction!(__traits(getMember, aggregate, member)))
		enum isProperty = (functionAttributes!(__traits(getMember, aggregate, member)) & FunctionAttribute.property);
	else
		enum isProperty = false;
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

private template isFieldName(alias aggregate, string member) if (!isTypeTuple!aggregate)
{
	import std.traits, std.algorithm;
	enum isFieldName = member.among(FieldNameTuple!(typeof(aggregate))) != 0;
}

// This trait defines what members should be drawn -
// public members that are either readable and writable or getter properties
private template Drawable(alias value, string member)
{
	import std.traits : isTypeTuple;

	static if (isItSequence!value)
		enum Drawable = false;
	else
	static if (isFieldName!(value, member) && !isPublic!(value, member))
			enum Drawable = false;
	else
	static if (isTypeTuple!(__traits(getMember, value, member)))
		enum Drawable = false;
	else
	static if (is(typeof(__traits(getMember, value, member)) == enum))
		enum Drawable = false;
	else
	static if (isItSequence!(__traits(getMember, value, member)))
		enum Drawable = false;
	else
	static if (isReadableAndWritable!(value, member))
		enum Drawable = true;
	else
	static if (isReadable!(value, member))
		enum Drawable = isProperty!(value, member); // a readable property is getter
	else
		enum Drawable = false;
}

/// returns alias sequence, members of which are members of value
/// that should be drawn
private template DrawableMembers(alias value)
{
	import std.meta : ApplyLeft, Filter, AliasSeq;

	alias AllMembers = AliasSeq!(__traits(allMembers, typeof(value)));
	alias isProper = ApplyLeft!(Drawable, value);
	alias DrawableMembers = Filter!(isProper, AllMembers);
}

private template DrawableMembers(T)
{
	T t;
	alias DrawableMembers = DrawableMembers!t;
}