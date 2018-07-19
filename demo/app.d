module demo;

import beholder.application : GuiApplication;
import beholder.renderer : Renderer;
import beholder.actor : makeActor;

import gfm.math : vec3f, vec4f;

struct Vertex
{
    vec3f position;
    vec4f color;
}

Vertex[] data = [
    Vertex(vec3f(0.0, 0, 0), vec4f(1, 0, 0, 1)),
    Vertex(vec3f(1.0, 0, 0), vec4f(1, 0, 0, 1)),
    Vertex(vec3f(0.5, 1, 0), vec4f(1, 0, 0, 1)),
    Vertex(vec3f(0.0, -1, 0.5), vec4f(1, 0, 0, 1)),
];

int main(string[] args)
{
    auto app = new GuiApplication("Demo gui application", 1800, 768, GuiApplication.FullScreen.no);
    auto renderer = new Renderer(app.gl);
    
    {
        auto actor = makeActor(data, [0, 1, 2, ]);
        renderer.add(actor);
    }

    {
        import std.algorithm : map;
        auto actor = makeActor(data.map!(a=>Vertex(a.position, vec4f(0, 1, 0, 1))), [1, 0, 3, ]);
        renderer.add(actor);
    }

    app.add(renderer);
    
    app.run();

    renderer.destroy();
    app.destroy();

    return 0;
}
