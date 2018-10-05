module demo;

import beholder.application : Application;
import beholder.renderer : Renderer;
import beholder.actor : Actor;

import gfm.math : vec3f, vec4f;

struct Vertex
{
    vec3f position;
    vec4f color;
}





Vertex[][] data = [
    [
        Vertex(vec3f(3728.77, 329.709, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(4944.02, 821.47, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(6921.45, 1376.91, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(9409.09, 2222.93, 0), vec4f(1, 0,0, 1)),
        Vertex(vec3f(10665.9, 3075.69, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(13598.9, 3505.53, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(14822.2, 4070.14, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(17315.8, 4884.46, 0), vec4f(1, 0, 0, 1)), 
        Vertex(vec3f(18690.5, 5426.98, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(20577.9, 6155.25, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(23452.6, 7084, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(24255.9, 7631.27,0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(25931, 8209.82, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(28623.3, 8690.79, 0), vec4f(1, 0, 0, 1)),
    ], 




    [
        Vertex(vec3f(3186.35, 63.7292, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(5363.81, 1155.18, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(7169.63, 1527.21, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(8930.38, 2090.4, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(11582.8, 2778.91, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(12576.4, 3420.1, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(14588.1, 4082.61, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(17712, 4738.55, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(18530.3, 5358.36, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(20291.3, 6310.44, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(22164.7, 6703.36, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(24219.6, 7334.34, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(26691.8, 8111.35, 0), vec4f(1, 0, 0, 1)),
        Vertex(vec3f(27933.8, 8970.2, 0), vec4f(1, 0, 0, 1)),
    ], 




    [
        Vertex(vec3f(7169.63, 1527.21, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(8977.46, 1922.87, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(10843.5, 2626.37, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(12577.6, 3350.8, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(14407.5, 4031.15, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(16220.9, 4701.82, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(18071.5, 5355.53, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(20021.9, 5996.21, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(21993.7, 6664.07, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(23879.3, 7334.3, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(25747.1, 7980.57, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(float.nan, float.nan, float.nan), vec4f(0.7585, 0.223, 0.937, 1)),
    ], 






    [
        Vertex(vec3f(3728.77, 329.709, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(3728.77, 329.709, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(4968.36, 890.916, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(4968.36, 890.916, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(6456.38, 1379.53, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(7870.78, 1929.72, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(10554.2, 2488.52, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(12301.4, 3156.38, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(14064.8, 3966.86, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(15821.2, 4604.34, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(17608.1, 5300.57, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(19418.1, 5960.86, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(21191.8, 6602.49, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(23128.4, 7256.2, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(25759.9, 7929.04, 0), vec4f(0.7585, 0.223, 0.937, 1)),
        Vertex(vec3f(float.nan, float.nan, float.nan), vec4f(0.7585, 0.223, 0.937, 1)),
    ]
];

struct Foo
{
	int i;
	float f;
	string str;
	int[2] i2 = [ 101, 112 ];
}

struct Bar
{
	Foo foo1;
	Foo foo2;
	int i;
	string[] string_array;
}

import beholder.drawer;
import taggedalgebraic : TaggedAlgebraic;

struct Types
{
    Foo f;
    Bar b;
    Vertex v;
}

alias Value = TaggedAlgebraic!Types;

alias CoordType = float;
enum NumberOfDimensions = 3;

union Payload
{
	long l;
	struct
	{
		int source;
		int subset;
	}

	this(long l)
	{
		this.l = l;
	}

	this(int source, int subset)
	{
		this.source = source;
		this.subset = subset;
	}

	void toString(scope void delegate(const(char)[]) sink) const
	{
		import std.format : sformat;
		char[512] buffer = '\0';
		auto formatted_output = sformat(buffer[], "%s(long: %s, source: %s, subset: %s)", typeof(this).stringof, l, source, subset);
		sink(formatted_output);
	}
}

import rtree;
alias RTreeIndex = RTree!(Payload, CoordType, NumberOfDimensions, CoordType);

class NuklearApplication : Application
{
	import gfm.math : vec2f;
    import nuklear_sdl_gl3;

    enum MAX_VERTEX_MEMORY = 512 * 1024;
    enum MAX_ELEMENT_MEMORY = 128 * 1024;

    nk_context* ctx;
	RTreeIndex index;

	Foo foo;
	Bar[] bar;
	Drawer!(Bar[]) bar_drawer;

    Value[] value;
    Drawer!(typeof(value)) value_drawer;

    this(string title, int w, int h, Application.FullScreen flag)
    {
        super(title, w, h, flag);

        ctx = nk_sdl_init(&window());
        nk_font_atlas *atlas;
        nk_sdl_font_stash_begin(&atlas);
        nk_sdl_font_stash_end();

		index = new RTreeIndex();

		bar_drawer = Drawer!(typeof(bar))(bar);
		
		auto b = Bar();
		b.string_array ~= "First line";
		b.string_array ~= "Second line";
		bar ~= b;
		bar ~= Bar();
		bar_drawer.update(bar);

        import std.range, std.array;
        value = [ Value(Foo()), Value(b), Value(data[0][0]), Value(data[0][1]), ].repeat(10_000).join.array;
        value_drawer = Drawer!(typeof(value))(value);
        value_drawer.update(value);
    }

    ~this()
    {
        nk_sdl_shutdown();
	}

	/// Projection of world coordinates to plane z = 0
    private vec3f projectWindowToPlane0(in vec2f winCoords)
    {
        double x = void, y = void;
        const aspect_ratio = _width/cast(double)_height;
        if(_width > _height) 
        {
            auto factor_x = 2.0f * _camera.size / _width * aspect_ratio;
            auto factor_y = 2.0f * _camera.size / _height;

            x = winCoords.x * factor_x + _camera.position.x - _camera.size * aspect_ratio;
            y = winCoords.y * factor_y + _camera.position.y - _camera.size;
        }
        else
        {
            auto factor_x = 2.0f * _camera.size / _width;
            auto factor_y = 2.0f * _camera.size / _height * aspect_ratio;

            x = winCoords.x * factor_x + _camera.position.x - _camera.size;
            y = winCoords.y * factor_y + _camera.position.y - _camera.size * aspect_ratio;
        }

        return vec3f(x, y, 0.0f);
    }

	override void draw()
	{
		super.draw();

		if (nk_input_mouse_clicked(&ctx.input, NK_BUTTON_LEFT, nk_rect(0, 0, _width, _height)))
		{
			const span = vec3f(1, 1, 1)*2*camera.size/_width*10; // 10 pixels around mouse pointer
			auto mouse = vec2f(_mouse_x, _mouse_y);
			auto ray = projectWindowToPlane0(mouse);
			auto min = ray - span;
			auto max = ray + span;
			auto result = index.search(min.ptr[0..NumberOfDimensions], max.ptr[0..NumberOfDimensions]);
			import std.stdio;
			writeln(result[]); 
		}

        static nk_colorf bg;
        bg.r = 0.10f, bg.g = 0.18f, bg.b = 0.24f, bg.a = 1.0f;

        if (nk_begin(ctx, "Demo", nk_rect(50, 50, 230, 450),
            NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE|
            NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))
        {
            enum {EASY, HARD}
            static int op = EASY;
            static int property = 20;

            nk_layout_row_static(ctx, 30, 80, 1);
            if (nk_button_label(ctx, "button"))
            {
                printf("button pressed!\n");
                final switch(value[0].kind)
                {
                    case Value.Kind.f:
                        value[0] = Bar();
                    break;
                    case Value.Kind.b:
                        value[0] = data[0][0];
                    break;
                    case Value.Kind.v:
                        value[0] = Foo();
                    break;
                }
            }
            nk_layout_row_dynamic(ctx, 30, 2);
            if (nk_option_label(ctx, "easy", op == EASY)) op = EASY;
            if (nk_option_label(ctx, "hard", op == HARD)) op = HARD;
            nk_layout_row_dynamic(ctx, 22, 1);
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
		bar_drawer.draw(ctx, "bar", bar);
        value_drawer.draw(ctx, "value", value);
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
            scope(exit) nk_input_end(ctx);
            while(_sdl2.pollEvent(&event))
            {
                nk_sdl_handle_event(&event);
                if (nk_window_is_any_hovered(ctx))
                    continue;
                defaultProcessEvent(event);
            }

            draw();

            _window.swapBuffers();
        }
    }
}

int main(string[] args)
{
    auto app = new NuklearApplication("Demo gui application", 1800, 768, Application.FullScreen.no);
    scope(exit) app.destroy();
	app.camera.size = 30_000;
	app.camera.position = vec3f(0, 15_000, 0);

    auto renderer = new Renderer!Vertex(app.gl);
	scope(exit) renderer.destroy();
    
	enum displace = vec3f(0.01, 0.01, 0.01);
	int i, j;
    foreach(e; data)
    {
		j = 0;
		foreach(ref p; e)
		{
			import std.math : isNaN;
			if (p.position.x.isNaN)
				continue;
			auto payload = Payload(i, j);
			app.index.insert((p.position-displace).ptr[0..NumberOfDimensions], (p.position+displace).ptr[0..NumberOfDimensions], payload);
			j++;
		}
        auto actor = renderer.make!Actor(e);
        auto ds = actor.dataSlice;
        ds.kind = actor.Kind.LineStrip;
        renderer.addDataSlice(ds);
        ds.kind = actor.Kind.Points;
        renderer.addDataSlice(ds);

		i++;
    }

    app.add(renderer);
    
    app.run();

    return 0;
}
