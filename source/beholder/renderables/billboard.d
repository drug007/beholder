module beholder.renderables.billboard;

import gfm.math : vec2f;

import beholder.render_state.render_state : RenderState;
import beholder.vertex_data.vertex_data : VertexData;
import beholder.renderables.renderable : Renderable;
import beholder.scene.scene_state : SceneState;
import beholder.draw_state : DrawState;
import beholder.context : Context, PrimitiveType, Program;


struct Vertex
{
    vec2f position;
}

class Billboard : Renderable
{
    import std.datetime : Duration;
    import gfm.opengl : GLTexture2D;

    Duration deltaTime;
	Duration updatePeriod;
    GLTexture2D frontTex, backTex, srcTex, currTex;
    DrawState drawState, _internalDrawState;
    private uint _fboId;
    bool visible;

    this(RenderState renderState, Program program, ref VertexData vertexData)
    {
        drawState = DrawState(renderState, program, vertexData);

		import beholder.vertex_data.vertex_data;
		import beholder.vertex_data.vertex_spec;

        auto internalProgram = createInternalProgram();
        auto vs = new VertexSpec!Vertex(internalProgram);

        auto internalVertexData = new VertexData(
			vs,
			[
                Vertex(vec2f( 1.0, -1.0)),
				Vertex(vec2f(-1.0, -1.0)),
				Vertex(vec2f( 1.0,  1.0)),
				Vertex(vec2f(-1.0,  1.0))
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
                srcTex = new GLTexture2D();
                srcTex.setMinFilter(GL_NEAREST);
                srcTex.setMagFilter(GL_NEAREST);
                srcTex.setWrapS(GL_REPEAT);
                srcTex.setWrapT(GL_REPEAT);
                srcTex.setImage(0, GL_RGB, surface.w, surface.h, 0, GL_RED, GL_UNSIGNED_BYTE, surface.pixels);
                srcTex.generateMipmap();
            }

            ubyte[] tmp;
            tmp.length = surface.w * surface.h;
            tmp[] = 0;
            
			{
                backTex = new GLTexture2D();
                backTex.setMinFilter(GL_NEAREST);
                backTex.setMagFilter(GL_NEAREST);
                backTex.setWrapS(GL_REPEAT);
                backTex.setWrapT(GL_REPEAT);
                backTex.setImage(0, GL_RGB, surface.w, surface.h, 0, GL_RED, GL_UNSIGNED_BYTE, tmp.ptr);
                backTex.generateMipmap();
            }
			{
                frontTex = new GLTexture2D();
                frontTex.setMinFilter(GL_NEAREST);
                frontTex.setMagFilter(GL_NEAREST);
                frontTex.setWrapS(GL_REPEAT);
                frontTex.setWrapT(GL_REPEAT);
                frontTex.setImage(0, GL_RGB, surface.w, surface.h, 0, GL_RED, GL_UNSIGNED_BYTE, tmp.ptr);
                frontTex.generateMipmap();
            }

            glGenFramebuffers(1, &_fboId);
            glBindFramebuffer(GL_FRAMEBUFFER, _fboId);
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                GL_TEXTURE_2D, frontTex.handle, 0);
            GLenum[1] DrawBuffers = [GL_COLOR_ATTACHMENT0];
            glDrawBuffers(1, DrawBuffers.ptr);
            glBindFramebuffer(GL_FRAMEBUFFER, 0);

            currTex = frontTex;

            //Проверим статус, чтоб убедиться что нет никаких ошибок
            auto status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            assert(status == GL_FRAMEBUFFER_COMPLETE, "FBOError " ~ text(status));
		}
    }

    ~this()
    {
        currTex = null;
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
        if (srcTex)
        {
            destroy(srcTex);
            srcTex = null;
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
        import gfm.math : mat4f, vec2f;
        import gfm.opengl : glBindFramebuffer, GL_FRAMEBUFFER;

        if (!visible)
            return;

        import gfm.opengl;
        int[4] viewport;
        glGetIntegerv(GL_VIEWPORT, viewport.ptr);
        const texWidth =  2048;
        const texHeight = 2048;

        static float dt;
        static int frontTexUnit;
        int backTexUnit, srcTexUnit = 2;
        auto newDt = cast(float)deltaTime.total!"hnsecs"/(updatePeriod.total!"hnsecs");
        backTexUnit = (frontTexUnit + 1) % 2;
        if (newDt < dt)
        {
            backTexUnit = frontTexUnit;
            frontTexUnit = (frontTexUnit + 1) % 2;
            currTex = (currTex is frontTex) ? backTex : frontTex;
        }
        dt = newDt;

        frontTex.use(0);
        backTex.use(1);
        srcTex.use(2);

// #1
        _internalDrawState.program.uniform("tex").set(srcTexUnit);
        _internalDrawState.program.use();

        glBindFramebuffer(GL_FRAMEBUFFER, _fboId);   // Активируем FBO
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
            GL_TEXTURE_2D, currTex.handle, 0);
        glViewport(0, 0, texWidth, texHeight);
        glClear(GL_COLOR_BUFFER_BIT);

        ctx.draw(PrimitiveType.Triangles, 0, cast(int) (_internalDrawState.vertexData.ibo.size/int.sizeof), _internalDrawState, sceneState);
        glBindFramebuffer(GL_FRAMEBUFFER, 0);//Деактивируем FBO
        _internalDrawState.program.unuse();
        glViewport(viewport[0],viewport[1],viewport[2],viewport[3]);

        glBindTexture(GL_TEXTURE_2D, frontTex.handle);
        glGenerateMipmap(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, 0);
        glViewport(viewport[0],viewport[1],viewport[2],viewport[3]);

// #2
        // _internalDrawState.program.uniform("tex").set(backTexUnit);
        // _internalDrawState.program.use();
        // ctx.draw(PrimitiveType.Triangles, 0, cast(int) (_internalDrawState.vertexData.ibo.size/int.sizeof), _internalDrawState, sceneState);
        // _internalDrawState.program.unuse();
// #3

        // _internalDrawState.program.uniform("tex").set(frontTexUnit);
        // _internalDrawState.program.use();
        // ctx.draw(PrimitiveType.Triangles, 0, cast(int) (_internalDrawState.vertexData.ibo.size/int.sizeof), _internalDrawState, sceneState);
        // _internalDrawState.program.unuse();

// # 4
        mat4f mvp = sceneState.camera.modelViewProjection;
        drawState.program.uniform("mvp_matrix").set(mvp);
        drawState.program.uniform("frontTex").set(frontTexUnit);
        drawState.program.uniform("backTex").set(backTexUnit);
        drawState.program.uniform("deltaTime").set(dt);
        drawState.program.use();

        ctx.draw(PrimitiveType.Triangles, 0, cast(int) drawState.vertexData.ibo.size, drawState, sceneState);
        drawState.program.unuse();
    }

    private final auto createInternalProgram() @trusted
	{
		import beholder.context : Context;

        const program_source =
				"#version 330 core

				#if VERTEX_SHADER
                layout(location = 0) in vec2 position;
                out vec2 vTexCoord;
                void main()
                {
                    gl_Position = vec4(position.xy, 0.0, 1.0);
                    vTexCoord = position.xy/2 - 0.5;
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
