module beholder.beholder;

import nanogui.sdlbackend : SdlBackend;

import beholder.common;
import beholder.draw_state;
import beholder.scene.scene_state : SceneState;
import beholder.scene.camera;
import beholder.vertex_data.vertex_data;
import beholder.vertex_data.vertex_spec;

import gfm.math : vec3f, vec4f, vec2i;

struct Vertex
{
	vec3f position;
	vec4f color;
}

auto points = [
	Vertex(vec3f(2500.0,  25000.0, 0), vec4f(1.0, 0.0, 1.0, 1.0)),
	Vertex(vec3f(2500.0,  35000.0, 0), vec4f(1.0, 0.0, 1.0, 1.0)),
	Vertex(vec3f(5000.0,  35000.0, 0), vec4f(1.0, 0.0, 1.0, 1.0)),
	Vertex(vec3f(5000.0,  25000.0, 0), vec4f(1.0, 0.0, 1.0, 1.0)),
	Vertex(vec3f(2500.0,  25000.0, 0), vec4f(1.0, 0.0, 1.0, 1.0)),

	Vertex(vec3f(7500.0,  23000.0, 0), vec4f(0.0, 1.0, 1.0, 1.0)),
	Vertex(vec3f(7500.0,  33000.0, 0), vec4f(0.0, 1.0, 1.0, 1.0)),
	Vertex(vec3f(9000.0,  33000.0, 0), vec4f(0.0, 1.0, 1.0, 1.0)),
	Vertex(vec3f(9000.0,  23000.0, 0), vec4f(0.0, 1.0, 1.0, 1.0)),
	Vertex(vec3f(7500.0,  23000.0, 0), vec4f(0.0, 1.0, 1.0, 1.0)),
];

private class Window : SdlBackend
{
	this(int w, int h, string title)
	{
		super(w, h, title);
        sceneState = new SceneState(w, h);
        sceneState.camera.halfWorldWidth = 40_000;
		sceneState.camera.position = vec3f(0, 0, 0);
		sceneState.camera.viewport(vec2i(1, 1));
		sceneState.camera.updateMatrices();
	}

    ~this()
    {
        foreach(ref e; drawStateBuf)
            destroy(e);
        drawStateBuf = null;
    }

	override void onVisibleForTheFirstTime()
	{
        import gfm.opengl;
        import beholder.render_state.render_state : RenderState;

        auto renderState = RenderState();

        const program_source =
				"#version 330 core

				#if VERTEX_SHADER
				layout(location = 0) in vec3 position;
				layout(location = 1) in vec4 color;
				out vec4 vColor;
				uniform mat4 mvp_matrix;
				void main()
				{
					gl_Position = mvp_matrix * vec4(position.xyz, 1.0);
					vColor = color;
				}
				#endif

				#if FRAGMENT_SHADER
				in vec4 vColor;
				out vec4 color_out;

				void main()
				{
					color_out = vColor;
				}
				#endif
			";

		auto program = new GLProgram(program_source);

        auto vertexSpec = new VertexSpec!Vertex(program);
		import std.range : iota;
		auto indices = iota(0, cast(uint) points.length);
        auto vertexData = new VertexData(vertexSpec, points, indices);

        drawStateBuf ~= DrawState(renderState, program, vertexData);
        _sdlApp.onDraw = ()
        {
            import std;
            import gfm.math, gfm.opengl;
            
            glClearColor(0, 0, 0, 1);
		    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            mat4f mvp = sceneState.camera.modelViewProjection;
            foreach(ref drawState; drawStateBuf)
            {
                drawState.program.uniform("mvp_matrix").set(mvp);
                drawState.program.use();
                scope(exit) drawState.program.unuse();

                with(drawState.vertexData)
                {
                    import gfm.opengl : glDrawElements, GL_UNSIGNED_INT;

                    vao.bind();
                    runtimeCheck();
                    auto mode = GL_LINE_STRIP;
                    auto length = points.length*indexSize();
                    auto start = 0;
                    glDrawElements(mode, cast(int) length, GL_UNSIGNED_INT, cast(void *)(start * indexSize()));
                    vao.unbind();
                }

                runtimeCheck();
            }
        };
    }

private:

    import beholder.context;

    Context ctx;
    SceneState sceneState;
    DrawState[] drawStateBuf;

    import gfm.opengl;
    
    void runtimeCheck()
    {
        GLint r = glGetError();
        if (r != GL_NO_ERROR)
        {
            string errorString = getErrorString(r);
            version(none) flushGLErrors(); // flush other errors if any
            throw new OpenGLException(errorString);
        }
    }

    string getErrorString(GLint r) pure nothrow
    {
        switch(r)
        {
            case GL_NO_ERROR:          return "GL_NO_ERROR";
            case GL_INVALID_ENUM:      return "GL_INVALID_ENUM";
            case GL_INVALID_VALUE:     return "GL_INVALID_VALUE";
            case GL_INVALID_OPERATION: return "GL_INVALID_OPERATION";
            case GL_OUT_OF_MEMORY:     return "GL_OUT_OF_MEMORY";
            case GL_STACK_OVERFLOW:    return "GL_STACK_OVERFLOW";
            case GL_STACK_UNDERFLOW:   return "GL_STACK_UNDERFLOW";
            default:                   return "Unknown OpenGL error";
        }
    }
}

struct Beholder
{
@safe:

    @disable this();

	this(int w, int h, string title) @trusted
	{
        _window = new Window(w, h, title);
    }

    ~this() @trusted
    {
        destroy(_window);
    }

    void addData(PointC2f[] data)
    {
        _data ~= data;
    }

    void run() @trusted
    {
        _window.run();
    }

private:
    PointC2f[] _data;
    SdlBackend _window;
}