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
		sceneState.camera.viewport(vec2i(w, h));
		sceneState.camera.updateMatrices();

        ctx = new Context();
	}

    ~this() @trusted
    {
        foreach(ref e; renderable)
            destroy(e);
        renderable = null;
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

        _sdlApp.addHandler!(_sdlApp.onMouseMotion)((ref const(_sdlApp.Event) event)
        {
            import gfm.sdl2 : SDL_BUTTON_RMASK;
            if (event.motion.state & SDL_BUTTON_RMASK)
            {
                auto xmove = event.motion.xrel*sceneState.camera.halfWorldWidth*2/sceneState.camera.viewport.x;
                auto ymove = event.motion.yrel*sceneState.camera.halfWorldWidth*2*sceneState.camera.aspectRatio/sceneState.camera.viewport.x;
                sceneState.camera.position.x -= xmove;
                sceneState.camera.position.y += ymove;
                sceneState.camera.updateMatrices;
                _sdlApp.invalidate;
            }
        });

        _sdlApp.addHandler!(_sdlApp.onMouseWheel)((ref const(_sdlApp.Event) event)
        {
            enum Sensitivity = 40;
            auto scaling = event.wheel.y/cast(float)sceneState.camera.viewport.y;
            sceneState.camera.halfWorldWidth *= 1 - scaling*Sensitivity;
            sceneState.camera.updateMatrices;
            _sdlApp.invalidate;
        });
    }

    public Renderable[] renderable;

private:
    import beholder.context;

    Context ctx;
    SceneState sceneState;
}