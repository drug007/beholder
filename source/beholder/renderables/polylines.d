module beholder.renderables.polylines;

import beholder.render_state.render_state : RenderState;
import beholder.vertex_data.vertex_data : VertexData;
import beholder.renderables.renderable : Renderable;
import beholder.scene.scene_state : SceneState;
import beholder.draw_state : DrawState;
import beholder.context : Context, PrimitiveType, Program;

class Polylines : Renderable
{
    DrawState drawState;
    bool visible;

    this(RenderState renderState, Program program, ref VertexData vertexData)
    {
        drawState = DrawState(renderState, program, vertexData);
    }

    override void render(Context ctx, ref SceneState sceneState)
    {
        import gfm.math : mat4f;

        if (!visible)
            return;

        mat4f mvp = sceneState.camera.modelViewProjection;
        drawState.program.uniform("mvp_matrix").set(mvp);
        drawState.program.use();
        scope(exit) drawState.program.unuse();

        ctx.draw(PrimitiveType.LineStrip, 0, cast(int) drawState.vertexData.ibo.size, drawState, sceneState);
    }
}
