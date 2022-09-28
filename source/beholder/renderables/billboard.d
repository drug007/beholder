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
    GLTexture2D[2] bufferTex;
    int frontTexUnit;
    DrawState drawState, _internalDrawState;
    private uint _fboId;
    bool visible;
    int counter = 1;
    ubyte[] currentData, sourceData, signal;

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

            sourceData.length = surface.w * surface.h;
            sourceData[] = (cast(ubyte*)surface.pixels)[0..sourceData.length];

            currentData.length = surface.w * surface.h;
            currentData[] = 0;

            signal.length = 16*2048;
            signal[] = 0;

            foreach(i; 0..bufferTex.length)
            {
                bufferTex[i] = new GLTexture2D();
                bufferTex[i].setMinFilter(GL_NEAREST);
                bufferTex[i].setMagFilter(GL_NEAREST);
                bufferTex[i].setWrapS(GL_REPEAT);
                bufferTex[i].setWrapT(GL_REPEAT);
                bufferTex[i].setImage(0, GL_RGB, surface.w, surface.h, 0, GL_RED, GL_UNSIGNED_BYTE, currentData.ptr);
                bufferTex[i].generateMipmap();
            }

            glGenFramebuffers(1, &_fboId);
            glBindFramebuffer(GL_FRAMEBUFFER, _fboId);
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                GL_TEXTURE_2D, bufferTex[frontTexUnit].handle, 0);
            GLenum[1] DrawBuffers = [GL_COLOR_ATTACHMENT0];
            glDrawBuffers(1, DrawBuffers.ptr);
            glBindFramebuffer(GL_FRAMEBUFFER, 0);

            //Проверим статус, чтоб убедиться что нет никаких ошибок
            auto status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            assert(status == GL_FRAMEBUFFER_COMPLETE, "FBOError " ~ text(status));
		}
    }

    ~this()
    {
        foreach(i; 0..bufferTex.length)
        {
            if (bufferTex[i])
            {
                destroy(bufferTex[i]);
                bufferTex[i] = null;
            }
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
        auto newDt = cast(float)deltaTime.total!"hnsecs"/(updatePeriod.total!"hnsecs");
        int backTexUnit = (frontTexUnit + 1) % 2;
        if (newDt < dt)
        {
            backTexUnit = frontTexUnit;
            frontTexUnit = (frontTexUnit + 1) % 2;
        }
        dt = newDt;

        bufferTex[0].use(0);
        bufferTex[1].use(1);

// #1
        // _internalDrawState.program.uniform("tex").set(backTexUnit);
        // _internalDrawState.program.use();

        // glBindFramebuffer(GL_FRAMEBUFFER, _fboId);   // Активируем FBO
        // glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
        //     GL_TEXTURE_2D, currTex.handle, 0);
        // glViewport(0, 0, texWidth, texHeight);
        // glClear(GL_COLOR_BUFFER_BIT);

        // ctx.draw(PrimitiveType.Triangles, 0, cast(int) (_internalDrawState.vertexData.ibo.size/int.sizeof), _internalDrawState, sceneState);
        // glBindFramebuffer(GL_FRAMEBUFFER, 0);//Деактивируем FBO
        // _internalDrawState.program.unuse();
        // glViewport(viewport[0],viewport[1],viewport[2],viewport[3]);

        // glBindTexture(GL_TEXTURE_2D, frontTex.handle);
        // glGenerateMipmap(GL_TEXTURE_2D);
        // glBindTexture(GL_TEXTURE_2D, 0);
        // glViewport(viewport[0],viewport[1],viewport[2],viewport[3]);

// #2
        // _internalDrawState.program.uniform("tex").set(backTexUnit);
        // _internalDrawState.program.use();
        // ctx.draw(PrimitiveType.Triangles, 0, cast(int) (_internalDrawState.vertexData.ibo.size/int.sizeof), _internalDrawState, sceneState);
        // _internalDrawState.program.unuse();
// #3

        const totalWidth = 2048;
        const totalHeight = 2048;
        const pitch = 2048;
        const subWidth = totalWidth;
        const subHeight = 16;
        const level = 0;
        const xoffset = 0;
        const format = GL_RED;
        const type = GL_UNSIGNED_BYTE;

        const yoffset = subHeight*(counter-1);

        signal.length = subHeight*totalWidth;

        foreach(y; 0..16)
        {
            foreach(x; 0..subWidth)
            {
                signal[x+y*pitch] = sourceData[x+(y+yoffset)*pitch];
            }
        }

        if (counter+1 < totalHeight/subHeight)
            counter++;
        else
            counter = 1;

        bufferTex[frontTexUnit].use;
        glTexSubImage2D(GL_TEXTURE_2D, level, xoffset, yoffset, subWidth, subHeight, format, type, signal.ptr);

		_internalDrawState.program.uniform("tex").set(frontTexUnit);
        _internalDrawState.program.use();
        ctx.draw(PrimitiveType.Triangles, 0, cast(int) (_internalDrawState.vertexData.ibo.size/int.sizeof), _internalDrawState, sceneState);
        _internalDrawState.program.unuse();

// # 4
        // mat4f mvp = sceneState.camera.modelViewProjection;
        // drawState.program.uniform("mvp_matrix").set(mvp);
        // drawState.program.uniform("frontTex").set(frontTexUnit);
        // drawState.program.uniform("backTex").set(backTexUnit);
        // drawState.program.uniform("deltaTime").set(dt);
        // drawState.program.use();

        // ctx.draw(PrimitiveType.Triangles, 0, cast(int) (drawState.vertexData.ibo.size/int.sizeof), drawState, sceneState);
        // drawState.program.unuse();
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
