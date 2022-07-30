module beholder.renderables.polylines;

import beholder.render_state.render_state;
import beholder.vertex_data.vertex_data;
import beholder.renderables.renderable;
import beholder.scene.scene_state : SceneState;
import beholder.draw_state : DrawState;
import beholder.common;
import beholder.context : Context, PrimitiveType, Program;

class Polylines : Renderable
{
    PointC2f[][] data;
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
