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
    import beholder.context;

    PointC2f[] _data;

    Context ctx;
    SceneState sceneState;
}