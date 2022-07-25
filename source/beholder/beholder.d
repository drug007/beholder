module beholder.beholder;

import nanogui.sdlbackend : SdlBackend;

import beholder.common;
import beholder.draw_state;
import beholder.scene.scene_state : SceneState;
import beholder.scene.camera;
import beholder.vertex_data.vertex_data;
import beholder.vertex_data.vertex_spec;
import beholder.renderables.renderable;

class Beholder : SdlBackend
{
@safe:

    @disable this();

	this(int w, int h, string title) @trusted
	{
	    import gfm.math : vec3f, vec2i;

		super(w, h, title);
        sceneState = new SceneState(w, h);
        sceneState.camera.halfWorldWidth = 40_000;
		sceneState.camera.position = vec3f(0, 0, 0);
		sceneState.camera.viewport(vec2i(1, 1));
		sceneState.camera.updateMatrices();

        ctx = new Context();
	}

    ~this() @trusted
    {
        foreach(ref e; renderable)
            destroy(e);
        renderable = null;
    }

    void addData(PointC2f[] data)
    {
        _data ~= data;
    }

    override void run() @trusted
    {
        super.run();
    }

	override void onVisibleForTheFirstTime() @trusted
	{
        _sdlApp.onDraw = ()
        {
            import gfm.opengl;
            
            glClearColor(0.5, 0.5, 0.5, 1);
		    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            foreach(ref r; renderable)
            {
                r.render(ctx, sceneState);
            }
        };
    }

    public Renderable[] renderable;

private:
    import gfm.opengl;
    import beholder.context;

    PointC2f[] _data;

    Context ctx;
    SceneState sceneState;
    
    void runtimeCheck() @trusted
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