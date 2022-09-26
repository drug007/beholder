module beholder.renderables.billboard;

import beholder.render_state.render_state : RenderState;
import beholder.vertex_data.vertex_data : VertexData;
import beholder.renderables.renderable : Renderable;
import beholder.scene.scene_state : SceneState;
import beholder.draw_state : DrawState;
import beholder.context : Context, PrimitiveType, Program;

// Textured vertex
struct TVertex
{
	import gfm.math : vec2f, vec3f, vec4f;

	vec3f position;
	vec4f color;
	vec2f texCoord;
}

class Billboard : Renderable
{
    import std.datetime : Duration;
    import gfm.opengl : GLTexture2D;

    Duration deltaTime;
	Duration updatePeriod;
    GLTexture2D frontTex, backTex;
    DrawState drawState, _internalDrawState;
    private uint _fboId;
    bool visible;

    this(RenderState renderState, Program program, ref VertexData vertexData)
    {
        drawState = DrawState(renderState, program, vertexData);

		import beholder.vertex_data.vertex_data;
		import beholder.vertex_data.vertex_spec;
        import gfm.math : vec2f, vec3f, vec4f;

        auto internalProgram = createInternalProgram();
        auto vs = new VertexSpec!TVertex(internalProgram);

		auto internalVertexData = new VertexData(
			vs,
			[
				TVertex(vec3f(12048,    0, 0), vec4f(0, 1, 0, 1), vec2f(1, 0)),
				TVertex(vec3f(10000,    0, 0), vec4f(0, 0, 1, 1), vec2f(0, 0)),
				TVertex(vec3f(12048, 2048, 0), vec4f(1, 0, 0, 1), vec2f(1, 1)),
				TVertex(vec3f(10000, 2048, 0), vec4f(0, 1, 1, 1), vec2f(0, 1))
			],
			[0u, 1u, 3u, 0u, 3u, 2u]
		);

        _internalDrawState = DrawState(renderState, internalProgram, internalVertexData);

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
            import std.conv : text;
            import std.string : toStringz;
            import gfm.opengl;
            import gfm.sdl2.sdlimage;
            import gfm.sdl2.surface;
            import gfm.sdl2.sdl;
            import bindbc.sdl;

            const path = "data/scans/2022-03-01T14:32:20.000000_scan.png";
            immutable(char)* pathz = toStringz(path);
            SDL_Surface* surface = IMG_Load(pathz);
            if (surface is null)
                throw new Exception("IMG_Load");
            scope(exit)
                SDL_FreeSurface(surface);

			{
                backTex = new GLTexture2D();
                backTex.setMinFilter(GL_NEAREST);
                backTex.setMagFilter(GL_NEAREST);
                backTex.setWrapS(GL_REPEAT);
                backTex.setWrapT(GL_REPEAT);
                backTex.setImage(0, GL_RGB, surface.w, surface.h, 0, GL_RED, GL_UNSIGNED_BYTE, surface.pixels);
                backTex.generateMipmap();
            }
			{
                frontTex = new GLTexture2D();
                frontTex.setMinFilter(GL_NEAREST);
                frontTex.setMagFilter(GL_NEAREST);
                frontTex.setWrapS(GL_REPEAT);
                frontTex.setWrapT(GL_REPEAT);
                ubyte[] tmp;
                tmp.length = surface.w * surface.h;
                tmp[] = 0;
                frontTex.setImage(0, GL_RGB, surface.w, surface.h, 0, GL_RED, GL_UNSIGNED_BYTE, tmp.ptr);
                frontTex.generateMipmap();
            }

            glGenFramebuffers(1, &_fboId);
            glBindFramebuffer(GL_FRAMEBUFFER, _fboId);
            scope(exit) glBindFramebuffer(GL_FRAMEBUFFER, 0);

            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                GL_TEXTURE_2D, frontTex.handle, 0);

            glBindFramebuffer(GL_FRAMEBUFFER, 0);

            //Проверим статус, чтоб убедиться что нет никаких ошибок
            auto status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            assert(status == GL_FRAMEBUFFER_COMPLETE, "FBOError " ~ text(status));
		}
    }

    ~this()
    {
        if (backTex)
        {
            destroy(backTex);
            backTex = null;
        }
        if (frontTex)
        {
            destroy(frontTex);
            frontTex = null;
        }
        if (_fboId)
        {
            import gfm.opengl;
            glDeleteFramebuffers(1, &_fboId);
            _fboId = 0;
        }
    }

    override void render(Context ctx, ref SceneState sceneState)
    {
        import gfm.math : mat4f;
        import gfm.opengl : glBindFramebuffer, GL_FRAMEBUFFER;

        if (!visible)
            return;

        import gfm.opengl;
        int[4] viewport;
        glGetIntegerv(GL_VIEWPORT, viewport.ptr);
        const texWidth = 2048/1;
        const texHeight = 2048/1;
        glViewport(0, 0, texWidth, texHeight);

        static float dt;
        static int frontTexUnit;
        int backTexUnit;
        auto newDt = cast(float)deltaTime.total!"hnsecs"/(updatePeriod.total!"hnsecs");
        backTexUnit = (frontTexUnit + 1) % 2;
        dt = newDt;

        frontTex.use(frontTexUnit);
        backTex.use(backTexUnit);

        mat4f mvp = sceneState.camera.modelViewProjection;

        _internalDrawState.program.uniform("tex").set(frontTexUnit);
        _internalDrawState.program.uniform("mvp_matrix").set(mvp);
        _internalDrawState.program.use();

        glBindFramebuffer(GL_FRAMEBUFFER, _fboId);   // Активируем FBO
        ctx.draw(PrimitiveType.Triangles, 0, cast(int) _internalDrawState.vertexData.ibo.size, _internalDrawState, sceneState);
        _internalDrawState.program.unuse();

        drawState.program.uniform("mvp_matrix").set(mvp);
        drawState.program.uniform("frontTex").set(frontTexUnit);
        drawState.program.uniform("backTex").set(backTexUnit);
        drawState.program.uniform("deltaTime").set(dt);
        drawState.program.use();

        glBindFramebuffer(GL_FRAMEBUFFER, 0);//Деактивируем FBO

        glViewport(viewport[0],viewport[1],viewport[2],viewport[3]);
        ctx.draw(PrimitiveType.Triangles, 0, cast(int) drawState.vertexData.ibo.size, drawState, sceneState);
        drawState.program.unuse();
    }

    private final auto createInternalProgram() @trusted
	{
		import beholder.context : Context;

        const program_source =
				"#version 330 core

				#if VERTEX_SHADER
                layout(location = 0) in vec3 position;
				layout(location = 1) in vec4 color;
				layout(location = 2) in vec2 texCoord;
                out vec2 vTexCoord;
                uniform mat4 mvp_matrix;
                void main()
                {
                    gl_Position = mvp_matrix * vec4(position.xyz, 1.0);
                    vTexCoord = texCoord;
                }
				#endif

				#if FRAGMENT_SHADER
				in vec2 vTexCoord;
                out vec4 FragOut;
                uniform sampler2D tex;
                void main()
                {
                    FragOut = texture(tex, vTexCoord);
                }
				#endif
			";

		return Context.makeProgram(program_source);
	}
}
