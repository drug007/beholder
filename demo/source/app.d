module demo;

import gfm.math : vec3f, vec4f;
import taggedalgebraic : TaggedAlgebraic;

import beholder.application : Application;
import beholder.renderer : Renderer;
import beholder.actor : Actor;
import beholder.drawer : Drawer;

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

struct DataPoint
{
    int source;
    int dataset;
    vec3f position;
    long timestamp;
}

struct Types
{
    Foo f;
    Bar b;
    DataPoint dp;
}

alias Value = TaggedAlgebraic!Types;

struct Vertex
{
    vec3f position;
    vec4f color;
}

Value[] data;

static this()
{
    // dmd 2.081 can't initialize data in compile time so do it in static ctor
    data = [
        Value(DataPoint( 1, 156, vec3f( 3728.77,  329.70, 0),  10_000_000)),
        Value(DataPoint( 2, 314, vec3f( 3186.35, 63.7292, 0),  10_000_001)),
        Value(DataPoint(16, 273, vec3f( 7169.63, 1527.21, 0),  10_000_002)),
        Value(DataPoint(14, 707, vec3f( 3728.77, 329.709, 0),  10_000_003)),
        Value(DataPoint( 1, 156, vec3f( 4944.02,  821.47, 0),  20_000_000)),
        Value(DataPoint( 2, 314, vec3f( 5363.81, 1155.18, 0),  20_000_001)),
        Value(DataPoint(16, 273, vec3f( 8977.46, 1922.87, 0),  20_000_002)),
        Value(DataPoint(14, 707, vec3f( 3728.77, 329.709, 0),  20_000_003)),
        Value(DataPoint( 1, 156, vec3f( 6921.45, 1376.91, 0),  30_000_000)),
        Value(DataPoint( 2, 314, vec3f( 7169.63, 1527.21, 0),  30_000_001)),
        Value(DataPoint(16, 273, vec3f(10843.50, 2626.37, 0),  30_000_002)),
        Value(DataPoint(14, 707, vec3f( 4968.36, 890.916, 0),  30_000_003)),
        Value(DataPoint( 1, 156, vec3f( 9409.09, 2222.93, 0),  40_000_000)),
        Value(DataPoint( 2, 314, vec3f( 8930.38, 2090.40, 0),  40_000_001)),
        Value(DataPoint(16, 273, vec3f(12577.60, 3350.80, 0),  40_000_002)),
        Value(DataPoint(14, 707, vec3f( 4968.36, 890.916, 0),  40_000_003)),
        Value(DataPoint( 1, 156, vec3f(10665.90, 3075.69, 0),  50_000_000)),
        Value(DataPoint( 2, 314, vec3f(11582.80, 2778.91, 0),  50_000_001)),
        Value(DataPoint(16, 273, vec3f(14407.50, 4031.15, 0),  50_000_002)),
        Value(DataPoint(14, 707, vec3f( 6456.38, 1379.53, 0),  50_000_003)),
        Value(DataPoint( 1, 156, vec3f(13598.90, 3505.53, 0),  60_000_000)),
        Value(DataPoint( 2, 314, vec3f(12576.40, 3420.10, 0),  60_000_001)),
        Value(DataPoint(16, 273, vec3f(16220.90, 4701.82, 0),  60_000_002)),
        Value(DataPoint(14, 707, vec3f( 7870.78, 1929.72, 0),  60_000_003)),
        Value(DataPoint( 1, 156, vec3f(14822.20, 4070.14, 0),  70_000_000)),
        Value(DataPoint( 2, 314, vec3f(14588.10, 4082.61, 0),  70_000_001)),
        Value(DataPoint(16, 273, vec3f(18071.50, 5355.53, 0),  70_000_002)),
        Value(DataPoint(14, 707, vec3f(10554.20, 2488.52, 0),  70_000_003)),
        Value(DataPoint( 1, 156, vec3f(17315.80, 4884.46, 0),  80_000_000)),
        Value(DataPoint( 2, 314, vec3f(17712.00, 4738.55, 0),  80_000_001)),
        Value(DataPoint(16, 273, vec3f(20021.90, 5996.21, 0),  80_000_002)),
        Value(DataPoint(14, 707, vec3f(12301.40, 3156.38, 0),  80_000_003)),
        Value(DataPoint( 1, 156, vec3f(18690.50, 5426.98, 0),  90_000_000)),
        Value(DataPoint( 2, 314, vec3f(18530.30, 5358.36, 0),  90_000_001)),
        Value(DataPoint(16, 273, vec3f(21993.70, 6664.07, 0),  90_000_002)),
        Value(DataPoint(14, 707, vec3f(14064.80, 3966.86, 0),  90_000_003)),
        Value(DataPoint( 1, 156, vec3f(20577.90, 6155.25, 0), 100_000_000)),
        Value(DataPoint( 2, 314, vec3f(20291.30, 6310.44, 0), 100_000_001)),
        Value(DataPoint(16, 273, vec3f(23879.30, 7334.30, 0), 100_000_002)),
        Value(DataPoint(14, 707, vec3f(15821.20, 4604.34, 0), 100_000_003)),
        Value(DataPoint( 1, 156, vec3f(23452.60, 7084.00, 0), 110_000_000)),
        Value(DataPoint( 2, 314, vec3f(22164.70, 6703.36, 0), 110_000_001)),
        Value(DataPoint(16, 273, vec3f(25747.10, 7980.57, 0), 110_000_002)),
        Value(DataPoint(14, 707, vec3f(17608.10, 5300.57, 0), 110_000_003)),
        Value(DataPoint( 1, 156, vec3f(24255.90, 7631.27, 0), 120_000_000)),
        Value(DataPoint( 2, 314, vec3f(24219.60, 7334.34, 0), 120_000_001)),
        Value(DataPoint(14, 707, vec3f(19418.10, 5960.86, 0), 120_000_003)),
        Value(DataPoint( 1, 156, vec3f(25931.00, 8209.82, 0), 130_000_000)),
        Value(DataPoint( 2, 314, vec3f(26691.80, 8111.35, 0), 130_000_001)),
        Value(DataPoint(14, 707, vec3f(21191.80, 6602.49, 0), 130_000_003)),
        Value(DataPoint( 1, 156, vec3f(28623.30, 8690.79, 0), 140_000_000)),
        Value(DataPoint( 2, 314, vec3f(27933.80, 8970.20, 0), 140_000_001)),
        Value(DataPoint(14, 707, vec3f(23128.40, 7256.20, 0), 140_000_003)),
        Value(DataPoint(14, 707, vec3f(25759.90, 7929.04, 0), 150_000_003)),
    ];
}

alias CoordType = float;
enum NumberOfDimensions = 3;

struct Payload
{
	long index;
	int source;
	int subset;

	this(int source, int subset, long idx)
	{
		this.index  = idx;
		this.source = source;
		this.subset = subset;
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

        value = data.dup;
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
                        value[0] = data[0];
                    break;
                    case Value.Kind.dp:
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

alias LookupTable = vec4f[int];

enum LookupTable lut = [
     1 : vec4f(1.0, 0.0, 0.0, 1.0),
     2 : vec4f(1.0, 0.5, 0.5, 1.0),
    14 : vec4f(0.6, 0.8, 0.3, 1.0),
    16 : vec4f(0.7, 0.9, 1.0, 1.0),
];

int main(string[] args)
{
    auto app = new NuklearApplication("Demo gui application", 1800, 768, Application.FullScreen.no);
    scope(exit) app.destroy();
	app.camera.size = 30_000;
	app.camera.position = vec3f(0, 15_000, 0);

    auto renderer = new Renderer!Vertex(app.gl);
	scope(exit) renderer.destroy();
    
	enum displace = vec3f(0.01, 0.01, 0.01);
	size_t i;
    int[int][int] ids;
    foreach(p; data)
    {
		import std.math : isNaN;
        if (p.kind == Value.Kind.dp)
        {
            auto payload = Payload(p.source, p.dataset, i);
            app.index.insert((p.position-displace).ptr[0..NumberOfDimensions], (p.position+displace).ptr[0..NumberOfDimensions], payload);

            i++;
        }
        ids[p.source][p.dataset]++;
    }

    import std.algorithm : filter, map;
    foreach(source_id; ids.byKey)
    {
        foreach(dataset_id; ids[source_id].byKey)
        {
            auto dataset = data
                .filter!((ref a) { return a.source == source_id && a.dataset == dataset_id; })
                .map!(a=>Vertex(a.position, lut[a.source]));
            auto actor = renderer.make!Actor(dataset);
            auto ds = actor.dataSlice;
            ds.kind = actor.Kind.LineStrip;
            renderer.addDataSlice(ds);
            ds.kind = actor.Kind.Points;
            renderer.addDataSlice(ds);
        }
    }

    app.add(renderer);
    
    app.run();

    return 0;
}
