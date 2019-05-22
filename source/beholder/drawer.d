module beholder.drawer;

import std.traits : isStaticArray, isDynamicArray, isAggregateType, isArray, 
	isSomeString, isPointer, isSomeChar, isAssociativeArray, isBoolean,
	isInstanceOf;
import std.range : ElementType;
import taggedalgebraic : TaggedAlgebraic;

enum textBufferSize = 1024;

auto drawer(Args...)(Args args)
{
	return Drawer!Args(args);
}

template DrawerOf(alias A)
{
	import std.traits : isSomeFunction, ReturnType, Unqual;

	static if (is(A))
		alias DrawerOf = Drawer!A;
	else static if (isSomeFunction!A)
		alias DrawerOf = Drawer!(Unqual!(ReturnType!A)); // to get rid of inout qualifier
	else
		alias DrawerOf = Drawer!(typeof(A));
}

template Drawer(T)
{
	static if (Description!T.kind == Kind.oneliner)
	{
		static if (isInstanceOf!(TaggedAlgebraic, T))
			alias Drawer = DrawerOnelinerTaggedAlgebraic!T;
		else static if (isNullableLike!T)
			alias Drawer = DrawerOnelinerNullableLike!T;
		else static if (isAliasThised!T)
		{
			// get type of the first alias thised member
			alias U = typeof(mixin("T." ~ __traits(getAliasThis, T)[0]));
			alias Drawer = Drawer!U;
		}
		else
			alias Drawer = DrawerOneliner!T;
	}
	else static if (Description!T.kind == Kind.compiletimeList)
	{
		alias Drawer = DrawerCtList!T;
	}
	else static if (Description!T.kind == Kind.runtimeList)
	{
		alias Drawer = DrawerRtList!T;
	}
	else static if (Description!T.kind == Kind.assocArray)
	{
		alias Drawer = DrawerAssocArray!T;
	}
	else static if (Description!T.kind == Kind.aggregate)
	{
		alias Drawer = DrawerAggregate!T;
	}
	else
		static assert(0, "Unsupported type: " ~ T.stringof);
}

mixin template ImplementHeight()
{
	private float _height;

	@property
	auto height() inout { return _height; }

	@property
	auto height(float v) { _height = v; }
}

// TODO: Not thread safe solution!
private static int __list_drawer_char_id_counter;

mixin template ImplementDrawList()
{
	/// let every instance be unique
	private char[8] _char_id;

	void draw(Context)(Context ctx, const(char)[] header, ref const(T) a)
	{
		import core.stdc.stdio : snprintf;
		import nuklear_sdl_gl3;

		char[textBufferSize] buffer;

		// I'm pretty sure that a drawing method is not
		// a good place to initialize id (like ctor is).
		// The problem is absense of ability to define
		// default ctor for structs so generating of id
		// in struct ctor demands explicit ctor call and
		// that complicates code generation.
		// At least it allows to have id only for part of
		// structures, not for all like it would be in case
		// of classes

		// init id if needed
		if (_char_id == _char_id.init)
		{
			import core.stdc.stdio : snprintf;
			typeof(_char_id) buf;
			// hope we won't have 10 millions of instances
			snprintf(buf.ptr, buf.length, "%07d", __list_drawer_char_id_counter++);
			// reverse char id to place more rapidly changing char
			// in start of line to accelerate its comparing
			import std.algorithm : reverse;
			_char_id[0..$-1] = buf[0..$-1].reverse;
			_char_id[$-1] = 0;
		}

		snprintf(buffer.ptr, buffer.length, "%s (%ld)", header.ptr, a.length);
		if (nk_tree_state_push(ctx, NK_TREE_NODE, buffer.ptr, &collapsed))
		{
			assert(wrapper.length == a.length);

			foreach(i; 0..wrapper.length)
			{
				static if (isInstanceOf!(.DrawerAssocArray, typeof(this)))
				{
					snprintfValue(buffer[], a.keys[i]);
					wrapper[i].draw(ctx, buffer, a[a.keys[i]]);
				}
				else
					wrapper[i].draw(ctx, "", a[i]);
			}
			nk_tree_pop(ctx);
		}
	}
}

mixin template ImplementLayout()
{
	auto measure(Context)(Context ctx) inout
	{
		float h = ctx.style.font.height + ctx.style.window.spacing.y*2;
		if (collapsed != nk_collapse_states.NK_MINIMIZED)
		{
			foreach(ref e; wrapper)
				h += e.measure(ctx) + ctx.style.window.spacing.y;
		}

		return h;
	}

	auto makeLayout(Context)(Context ctx)
	{
		float h = ctx.style.font.height + ctx.style.window.spacing.y*2;
		if (collapsed != nk_collapse_states.NK_MINIMIZED)
		{
			foreach(ref e; wrapper)
			{
				e.height = e.measure(ctx);
				h += e.height + ctx.style.window.spacing.y;
				e.makeLayout(ctx);
			}
		}
		height = h;
	}
}

struct DrawerOneliner(Base) if (Description!Base.kind == Kind.oneliner)
{
	int selected;

	this(const(Base) t)
	{
		// do nothing
	}

	mixin ImplementHeight;

	float measure(Context)(Context ctx) inout
	{
		return ctx.style.font.height + ctx.style.window.spacing.y*2;
	}

	auto makeLayout(Context)(Context ctx)
	{
		height = measure(ctx);
	}

	void draw(Context, Derived : Base)(Context ctx, const(char)[] header, Derived t)
	{
		import nuklear_sdl_gl3;

		char[textBufferSize] buffer;
		int l;
		if (header.length)
			l = snprintf(buffer.ptr, buffer.length, "%s: ", header.ptr);
		
		l += snprintfValue!Base(buffer[l..$], t);

		nk_layout_row_dynamic(ctx, height,  1);

		auto canvas = nk_window_get_canvas(ctx);

		nk_rect space;
		auto state = nk_widget(&space, ctx);
		if (!state) return;

		version(none) if (state != NK_WIDGET_ROM)
			update_your_widget_by_user_input();

		nk_fill_rect(canvas, space, 0, nk_rgb(40,40,40));
		nk_stroke_rect(canvas, space, 0, ctx.current.layout.border, nk_rgb(64,64,64));
		space.y += ctx.style.window.spacing.y;
		space.x += ctx.style.window.spacing.x;
		nk_draw_text(canvas, space, buffer.ptr, l, ctx.style.font, ctx.style.window.background, ctx.style.text.color);
	}
}

// non Nullable TaggedAlgebraic aggregate type
struct DrawerOnelinerTaggedAlgebraic(T : TaggedAlgebraic!U, U) if (Description!T.kind == Kind.oneliner && isInstanceOf!(TaggedAlgebraic, T) && !isNullableLike!T)
{
	struct Payload
	{
		static foreach(i; 0..T.Union.tupleof.length)
		{
			mixin("Drawer!(typeof(T.Union." ~ T.Union.tupleof[i].stringof ~ ")) state_" ~ T.Union.tupleof[i].stringof ~ ";");
		}
	}

	TaggedAlgebraic!Payload wrapper;

	this()(auto ref const(TaggedAlgebraic!U) t)
	{
		update(t);
	}

	// Useful if TaggedAlgebraic contains another TarggedAlgeraic
	private auto selected(int v) { wrapper.selected = v; }

	mixin ImplementHeight;

	auto measure(Context)(Context ctx) inout
	{
		return wrapper.measure(ctx);
	}

	auto makeLayout(Context)(Context ctx)
	{
		wrapper.makeLayout(ctx);
	}

	/// updates size of underlying data
	void update()(auto ref inout(TaggedAlgebraic!U) t)
	{
		alias TU = TaggedAlgebraic!U;
		Lexit:
		final switch (t.kind)
		{
			static foreach(i; 0..t.Union.tupleof.length)
			{
		mixin("case TU.Kind." ~ t.Union.tupleof[i].stringof ~ ":");
				{
					import taggedalgebraic : TypeOf, get;
					alias PayloadType = TypeOf!(mixin("TU.Kind." ~ t.Union.tupleof[i].stringof));
					wrapper = Drawer!PayloadType(t.get!PayloadType);
					break Lexit;
				}
			}
		}
	}

	/// draws current value
	void draw(Context)(Context ctx, const(char)[] header, auto ref const(TaggedAlgebraic!U) t)
	{
		alias TU = TaggedAlgebraic!U;
		Lexit:
		final switch (t.kind)
		{
			static foreach(i; 0..t.Union.tupleof.length)
			{
		mixin("case TU.Kind." ~ t.Union.tupleof[i].stringof ~ ":");
				{
					import taggedalgebraic : TypeOf, get;
					enum FieldName = t.Union.tupleof[i].stringof;
					alias FieldType = TypeOf!(mixin("TU.Kind." ~ FieldName));
					alias DrawerType = Drawer!FieldType;
					if (cast(int)wrapper.kind != cast(int)t.kind)
					{
						auto old_selected  = wrapper.selected;
						wrapper = Drawer!FieldType(t.get!FieldType);
						wrapper.get!DrawerType.selected  = old_selected;
					}
					static if (__traits(compiles, { string s = t.get!FieldType.header; }))
						wrapper.get!DrawerType.draw(ctx, t.get!FieldType.header, t.get!FieldType);
					else
						wrapper.get!DrawerType.draw(ctx,              FieldName, t.get!FieldType);
					break Lexit;
				}
			}
		}
	}
}

// Nullable, non TaggedAlgebraic aggregate type
struct DrawerOnelinerNullableLike(T)  if (Description!T.kind == Kind.oneliner && !isInstanceOf!(TaggedAlgebraic, T) && isNullableLike!T)
{
	import std.traits : isSomeFunction, ReturnType, isArray, hasMember;
	import nuklear_sdl_gl3 : nk_collapse_states;

	int selected;

	static if (hasMember!(T, "get"))
	{
		enum memberTypeIsGet = true;
		alias Wrapper = DrawerOf!(T.get);
	}
	else static if (hasMember!(T, "value"))
	{
		enum memberTypeIsGet = false;
		alias Wrapper = DrawerOf!(T.value);
	}
	else
		static assert(0);

	Wrapper wrapper;

	this()(auto ref const(T) t)
	{
		update(t);
	}

	mixin ImplementHeight;

	auto measure(Context)(Context ctx) inout
	{
		return wrapper.measure(ctx);
	}

	auto makeLayout(Context)(Context ctx)
	{
		wrapper.makeLayout(ctx);
	}

	/// updates size of underlying data
	void update()(auto ref inout(T) t)
	{
		static if(memberTypeIsGet)
			wrapper = t.isNull ? Wrapper() : Wrapper(t.get);
		else
			wrapper = t.isNull ? Wrapper() : Wrapper(t.value);
	}

	/// draws all fields
	void draw(Context)(Context ctx, const(char)[] header, auto ref const(T) t)
	{
		import core.stdc.stdio : snprintf;
		import nuklear_sdl_gl3;

		char[textBufferSize] buffer;
		auto l = snprintf(buffer.ptr, buffer.length, "%s", header.ptr);

		import std.string : fromStringz;
		
		if (t.isNull)
		{
			if (header.length)
				l = snprintf(buffer.ptr, buffer.length, "%s: null", header.ptr);
			else
				l = snprintf(buffer.ptr, buffer.length, "null");

			nk_layout_row_dynamic(ctx, ctx.style.font.height, 1);
			nk_selectable_label(ctx, buffer.ptr, NK_TEXT_LEFT, &selected);
			return;
		}

		static if(memberTypeIsGet)
			wrapper.draw(ctx, buffer[0..l], t.get);
		else
			wrapper.draw(ctx, buffer[0..l], t.value);
	}
}

struct DrawerCtList(T) if (Description!T.kind == Kind.compiletimeList)
{
	import std.range : ElementType;

	import nuklear_sdl_gl3 : nk_collapse_states;

	nk_collapse_states collapsed;
	int selected;
	Drawer!(ElementType!T)[T.length] wrapper;

	this(const T a)
	{
		static foreach(i; 0..a.length)
			wrapper[i] = Drawer!(ElementType!T)(a[i]);
	}

	mixin ImplementDrawList;
	mixin ImplementHeight;
	mixin ImplementLayout;
}

struct DrawerRtList(T) if (Description!T.kind == Kind.runtimeList)
{
	import std.array : uninitializedArray;
	import std.range : ElementType;

	import nuklear_sdl_gl3 : nk_collapse_states;

	nk_collapse_states collapsed;
	Drawer!(ElementType!T)[] wrapper;

	this(const T a)
	{
		update(a);
	}

	mixin ImplementDrawList;
	mixin ImplementHeight;
	mixin ImplementLayout;

	void update(const T a)
	{
		wrapper = uninitializedArray!(typeof(wrapper))(a.length);
		foreach(i; 0..a.length)
			wrapper[i] = Drawer!(ElementType!T)(a[i]);
	}

	/// draws part of elements
	version (none) void draw(Context)(Context ctx, T a, Drawer!(ElementType!A)[] wrapper)
	{
		import nuklear_sdl_gl3;

		char[textBufferSize] buffer;

		assert(wrapper.length == a.length);
		foreach(i; 0..a.length)
		{
			wrapper[i].draw(ctx, "", a[i]);
		}
	}
}

struct DrawerAssocArray(T) if (Description!T.kind == Kind.assocArray)
{
	import std.array : uninitializedArray;
	import std.range : ElementType;

	import nuklear_sdl_gl3 : nk_collapse_states;

	nk_collapse_states collapsed;
	alias Value = typeof(T.init.values[0]);
	alias Key   = typeof(T.init.keys[0]);
	Drawer!Value[] wrapper;

	this(const T a)
	{
		update(a);
	}

	void update(const T a)
	{
		wrapper = uninitializedArray!(typeof(wrapper))(a.length);
		foreach(i; 0..a.length)
			wrapper[i] = Drawer!Value(a[a.keys[i]]);
	}

	mixin ImplementDrawList;
	mixin ImplementHeight;
	mixin ImplementLayout;
}

// Non Nullable, non TagggedAlgebraic aggregate type
struct DrawerAggregate(T) if (Description!T.kind == Kind.aggregate && RenderedAsAvailable!T)
{
	import std.traits : isSomeFunction, ReturnType, isArray;
	import nuklear_sdl_gl3 : nk_collapse_states;

	nk_collapse_states collapsed;
	int selected;

	DrawerOf!(T.renderedAs) state_rendered_as;
	enum Cached = is(RenderedAsType : string);
	static if(Cached)
		RenderedAsType cached;

	this()(auto ref const(T) t)
	{
		update(t);
	}

	mixin ImplementHeight;

	auto measure(Context)(Context ctx) inout
	{
		return state_rendered_as.measure(ctx);
	}

	auto makeLayout(Context)(Context ctx)
	{
		state_rendered_as.makeLayout(ctx);
		height = measure(ctx);
	}

	/// updates size of underlying data
	void update()(auto ref const(T) t)
	{
		state_rendered_as = drawer(t.renderedAs);
		static if (Cached)
			cached = t.renderedAs;
	}

	/// draws all fields
	void draw(Context)(Context ctx, const(char)[] header, auto ref const(T) t)
	{
		import nuklear_sdl_gl3;

		static if (Cached)
			state_rendered_as.draw(ctx, header, cached);
		else
			state_rendered_as.draw(ctx, "", t.renderedAs);
	}
}

// Non Nullable, non TagggedAlgebraic aggregate type
struct DrawerAggregate(T) if (Description!T.kind == Kind.aggregate && !RenderedAsAvailable!T)
{
	import std.traits : isSomeFunction, ReturnType, isArray;
	import nuklear_sdl_gl3 : nk_collapse_states;

	nk_collapse_states collapsed;
	int selected;

	static foreach(member; DrawableMembers!T) 
	{
		static if (hasRenderedAs!(__traits(getMember, T, member)))
		{
			mixin("Drawer!(getRenderedAs!(__traits(getMember, T, member))) state_" ~ member ~ ";");
		}
		else
		{
			mixin("DrawerOf!(T." ~ member ~ ") state_" ~ member ~ ";");
		}
	}

	this()(auto ref const(T) t)
	{
		update(t);
	}

	mixin ImplementHeight;

	auto measure(Context)(Context ctx) inout
	{
		float h = ctx.style.font.height + ctx.style.window.spacing.y*2;
		if (collapsed != nk_collapse_states.NK_MINIMIZED)
		{
			foreach(member; DrawableMembers!T)
			{
				h += mixin("state_" ~ member).measure(ctx) + ctx.style.window.spacing.y*2;
			}
		}
		return h;
	}

	auto makeLayout(Context)(Context ctx)
	{
		float h = ctx.style.font.height + ctx.style.window.spacing.y*2;
		if (collapsed != nk_collapse_states.NK_MINIMIZED)
		{
			static foreach(member; DrawableMembers!T)
			{
				mixin("state_" ~ member ~ ".height") = mixin("state_" ~ member ~ ".measure(ctx)");
				h += mixin("state_" ~ member ~ ".height");
				mixin("state_" ~ member ~ ".makeLayout(ctx);");
			}
		}
		height = h;
	}

	/// updates size of underlying data
	void update()(auto ref const(T) t)
	{
		static foreach(member; DrawableMembers!T)
		{{
			alias DrawerType = typeof(mixin("state_" ~ member));

			static if (hasRenderedAs!(__traits(getMember, T, member)))
			{
				alias Proxy = getRenderedAs!(__traits(getMember, T, member));
				mixin(`state_` ~ member) = DrawerType(Proxy(mixin(`t.` ~ member )));
			}
			else
			{
				mixin(`state_` ~ member) = DrawerType(mixin(`t.` ~ member ));
			}
		}}
	}

	void draw(Context)(Context ctx, const(char)[] header, auto ref const(T) t) if (DrawableMembers!t.length <= 1) 
	{
		drawFields(ctx, header, t);
	}

	void draw(Context)(Context ctx, const(char)[] header, auto ref const(T) t) if (DrawableMembers!t.length > 1) 
	{
		import nuklear_sdl_gl3;		
		import core.stdc.stdio : snprintf;
		
		char[textBufferSize] buffer;
		snprintf(buffer.ptr, buffer.length, "%s", header.ptr);

		if (nk_tree_state_push(ctx, NK_TREE_NODE, buffer.ptr, &collapsed))
		{
			drawFields(ctx, header, t);
			nk_tree_pop(ctx);
		}
	}

	private void drawFields(Context)(Context ctx, const(char)[] header, auto ref const(T) t)
	{
		static foreach(member; DrawableMembers!t)
		{
			static if (hasRenderedAs!(__traits(getMember, T, member)))
			{
				alias Proxy = getRenderedAs!(__traits(getMember, T, member));
				mixin(`state_` ~ member).draw(ctx, member, Proxy(mixin(`t.` ~ member )));
			}
			else
				mixin("state_" ~ member).draw(ctx, member,       mixin(`t.` ~ member));
		}
	}
}

/// Main rendering attribute type
struct Rendering
{
	/// arguments
	string[] args;
}

enum renderingIgnore = Rendering(["ignore"]);

struct RenderedAs(T){}
struct RenderedAs(alias string member, T)
{
	enum memberName = member;
}

//*****************************************************************************
// helpers
//*****************************************************************************

enum Kind : byte { oneliner, runtimeList, compiletimeList, aggregate, assocArray, }

import std.meta : AliasSeq;

alias SupportedBasicTypeSequence = AliasSeq!(
	bool, byte, ubyte, short, ushort, int, uint, long, ulong, float, 
	double, char, wchar, dchar, );

template Description(T)
{
	import std.meta : anySatisfy;
	import std.traits : Unqual;

	private enum UnqualifiedEquality(T1) = is(Unqual!T == T1);

	static if (is(T == enum) || anySatisfy!(UnqualifiedEquality, SupportedBasicTypeSequence))
	{
		enum kind = Kind.oneliner;
	}
	else static if (isAssociativeArray!T)
	{
		enum kind = Kind.assocArray;
	}
	else static if (isAliasThised!T)
	{
		static if (DrawableMembers!T.length > 1)
			enum kind = Kind.aggregate;
		else
			enum kind = Kind.oneliner;
	}
	else static if (isInstanceOf!(TaggedAlgebraic, T))
	{
		enum kind = Kind.oneliner;
	}
	else static if (isNullableLike!T || isPointer!T)
	{
		enum kind = Kind.oneliner;
	}
	else static if (isSomeString!T)
	{
		enum kind = Kind.oneliner;
	}
	else static if (isArray!T && isSomeChar!(ElementType!T))
	{
		enum kind = Kind.oneliner;
	}
	else static if (isStaticArray!T)
	{
		enum kind = Kind.compiletimeList;
	}
	else static if (isDynamicArray!T || isAssociativeArray!T)
	{
		enum kind = Kind.runtimeList;
	}
	else static if (isAggregateType!T)
	{
		enum kind = Kind.aggregate;
	}
	else
		static assert(0, "Unhandled case: " ~ T.stringof);
}

unittest
{
	static assert( Description!int.kind == Kind.oneliner);
	static assert( Description!(int[]).kind == Kind.runtimeList);

	import std.typecons : Nullable;
	static assert( Description!(Nullable!int).kind == Kind.oneliner);

	static assert( Description!(char[6]).kind == Kind.oneliner);
	static assert( Description!(bool[6]).kind == Kind.compiletimeList);

	struct Payload
	{
		string str;
	}
	
	static assert( Description!(Payload).kind == Kind.aggregate);
	static assert( Description!(TaggedAlgebraic!Payload).kind == Kind.oneliner);
}

@nogc @safe nothrow
private string enumToString(E)(E e) if (is(E == enum))
{
	import std.traits : Unqual;

	// using `if` instead of `final switch` is simple
	// workaround of duplicated enum members
	static foreach(v; __traits(allMembers, E))
		mixin("if (e == E." ~ v ~ ") return `" ~ v ~ "`;");
	return "Unrepresentable by " ~ Unqual!E.stringof ~ " value";
}

@nogc nothrow
private auto snprintfValue(T)(char[] buffer, auto ref const(T) t)
{
	/** TODO Known drawback
	It would be better if the function takes `t` as `inout` instead
	of `const` qualifier. But now it's possible that T is `inout` but 
	passed argument has `const` qualifier and compilation fails.
	*/
	import core.stdc.stdio : snprintf;
	import std.traits : isIntegral, isFloatingPoint;
		
	// format specifier depends on type, also string should be
	// passed using `.ptr` member
	static if (is(T == enum))
		return snprintf(&buffer[0], buffer.length, "%s", t.enumToString.ptr);
	else static if (isIntegral!T)
		return snprintf(&buffer[0], buffer.length, "%d", t);
	else static if (isFloatingPoint!T)
		return snprintf(&buffer[0], buffer.length, "%f", t);
	else static if (isBoolean!T)
		return snprintf(&buffer[0], buffer.length, t ? "true" : "false");
	else static if (isSomeString!T)
		return snprintf(&buffer[0], buffer.length, "%s", t.ptr);
	else static if (isSomeChar!T)
		return snprintf(&buffer[0], buffer.length, "%c", t);
	else static if (isPointer!T)
		return snprintf(&buffer[0], buffer.length, "%x", t);
	else static if (isStaticArray!T && isSomeChar!(ElementType!T))
		return snprintf(&buffer[0], buffer.length, "%s", t.ptr);
	else static if (isSomeChar!T)
		return snprintf(&buffer[0], buffer.length, "%c", t);
	else
		static assert(0, "Type `" ~ T.stringof ~ "` is not supported");
}

@nogc nothrow
private auto snprintfValue(T, U)(char[] buffer, auto ref const(U) u) if (isAggregateType!U)
{
	auto t = mixin("u." ~ __traits(getAliasThis, U)[0]);
	return snprintfValue!T(buffer, t);
}

private template isIgnored(alias aggregate, string member)
{
	import std.traits : getUDAs, isType;
	static if (isType!(__traits(getMember, aggregate, member)))
	{
		enum isIgnored = false;
	}
	else
	{
		enum udas = [getUDAs!(__traits(getMember, aggregate, member), Rendering)];
		enum isIgnored = ignore(udas);
	}
}

private bool ignore(Rendering[] attrs)
{
	import std.algorithm.searching: canFind;
	return attrs.canFind!(a => a.args == ["ignore"]);
}

private enum bool isRenderedAs(A) = is(A : RenderedAs!T, T);
private enum bool isRenderedAs(alias a) = false;

import std.meta : staticMap, Filter;

private alias ProxyList(alias value) = staticMap!(getRenderedAs, Filter!(isRenderedAs, __traits(getAttributes, value)));

private template hasRenderedAs(alias value)
{
	private enum _listLength = ProxyList!(value).length;
	static assert(_listLength <= 1, `Only single serialization proxy is allowed`);
	enum bool hasRenderedAs = _listLength == 1;
}

private alias getRenderedAs(T : RenderedAs!Proxy, Proxy) = Proxy;

private template getRenderedAs(alias value)
{
	private alias _list = ProxyList!value;
	static assert(_list.length <= 1, `Only single serialization proxy is allowed`);
	alias getRenderedAs = _list[0];
}

private template isAliasThised(T)
{
	static if (isAggregateType!T)
		enum isAliasThised = __traits(getAliasThis, T).length;
	else
		enum isAliasThised = false;
}

private template RenderedAsAvailable(T)
{
	import std.algorithm : among;
	
	// Unfortunately `hasMember` does not work 
	// with opDispatch, so brute force it
	enum RenderedAsAvailable = "renderedAs".among(__traits(allMembers, T));
}

private template isNullableLike(T)
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
		enum isNullableLike = true;
	}
	else
	{
		enum isNullableLike = false;
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

// This trait defines what members should be rendered -
// public members that are either readable and writable or getter properties
private template Drawable(alias value, string member)
{
	import std.algorithm : among;
	import std.traits : isSomeFunction;

	static if (isItSequence!value)
	{
		enum Drawable = false;
	}
	else static if (hasProtection!(value, member) && !isPublic!(value, member))
	{
		enum Drawable = false;
	}
	else static if (isItSequence!(__traits(getMember, value, member)))
	{
		enum Drawable = false;
	}
	else static if(member.among("__ctor", "__dtor"))
	{
		enum Drawable = false;
	}
	else static if(isIgnored!(value, member))
	{
		enum Drawable = false;
	}
	else static if (isReadableAndWritable!(value, member) && !isSomeFunction!(__traits(getMember, value, member)))
	{
		enum Drawable = true;
	}
	else static if (isReadable!(value, member))
	{
		enum Drawable = isConstProperty!(value, member); // a readable property is getter
	}
	else
		enum Drawable = false;
}

/// returns alias sequence, members of which are members of value
/// that should be rendered
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
