module beholder.renderables.billboard;

import beholder.render_state.render_state : RenderState;
import beholder.vertex_data.vertex_data : VertexData;
import beholder.renderables.renderable : Renderable;
import beholder.scene.scene_state : SceneState;
import beholder.draw_state : DrawState;
import beholder.context : Context, PrimitiveType, Program;

class Billboard : Renderable
{
    import std.datetime : Duration;
    import gfm.opengl : GLTexture2D;

    Duration deltaTime;
	Duration updatePeriod;
    GLTexture2D texture;
    DrawState drawState;
    bool visible;

    this(RenderState renderState, Program program, ref VertexData vertexData)
    {
        drawState = DrawState(renderState, program, vertexData);

        // TODO wrong place for initialization
        {
            import bindbc.sdl;

            const ret = loadSDLImage();
            if(ret < sdlImageSupport)
            {
                if(ret == SDLImageSupport.noLibrary)
                    throw new Exception("SDL Image shared library failed to load");
                else if(SDLImageSupport.badLibrary)
                    // One or more symbols failed to load. The likely cause is that the
                    // shared library is for a lower version than bindbc-sdl was configured
                    // to load (via SDL_201, SDL_202, etc.)
                    throw new Exception("One or more symbols of SDL Image shared library failed to load");
            }

            int inited = IMG_Init(IMG_INIT_PNG);
        }

        // 
		{
            import gfm.opengl;
            import gfm.sdl2.sdlimage;
            import gfm.sdl2.surface;
            import std.string : toStringz;
            import gfm.sdl2.sdl;
            import bindbc.sdl;

            const path = "data/scans/2022-03-01T14:32:20.000000_scan.png";
            immutable(char)* pathz = toStringz(path);
            SDL_Surface* surface = IMG_Load(pathz);
            if (surface is null)
                throw new Exception("IMG_Load");
            scope(exit)
                SDL_FreeSurface(surface);

			texture = new GLTexture2D();

			texture.setMinFilter(GL_NEAREST);
			texture.setMagFilter(GL_NEAREST);
			texture.setWrapS(GL_REPEAT);
			texture.setWrapT(GL_REPEAT);
			texture.setImage(0, GL_RGB, surface.w, surface.h, 0, GL_RED, GL_UNSIGNED_BYTE, surface.pixels);
			texture.generateMipmap();
		}
    }

    ~this()
    {
        if (texture)
        {
            destroy(texture);
            texture = null;
        }
    }

    override void render(Context ctx, ref SceneState sceneState)
    {
        import gfm.math : mat4f;

        if (!visible)
            return;

        int texUnit = 0;
        texture.use(texUnit);

        auto dt = cast(float)deltaTime.total!"hnsecs"/updatePeriod.total!"hnsecs";

        mat4f mvp = sceneState.camera.modelViewProjection;
        drawState.program.uniform("mvp_matrix").set(mvp);
        drawState.program.uniform("testTexture").set(texUnit);
        drawState.program.uniform("deltaTime").set(dt);
        drawState.program.use();
        scope(exit) drawState.program.unuse();

        ctx.draw(PrimitiveType.Triangles, 0, cast(int) drawState.vertexData.ibo.size, drawState, sceneState);
    }
}
