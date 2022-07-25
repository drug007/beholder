module beholder.renderables.polyline.polyline;

import gfm.opengl : GLProgram;

import beholder.render_state.render_state;
import beholder.vertex_data.vertex_data;
import beholder.renderables.renderable;
import beholder.scene.scene_state : SceneState;
import beholder.draw_state : DrawState;
import beholder.common;
import beholder.context : Context, PrimitiveType;

class Polyline : Renderable
{
    PointC2f[][] data;
    DrawState drawState;

    this(RenderState renderState, GLProgram program, ref VertexData vertexData)
    {
        drawState = DrawState(renderState, program, vertexData);
    }

    override void render(Context ctx, ref SceneState sceneState)
    {
        import gfm.math : mat4f;

        mat4f mvp = sceneState.camera.modelViewProjection;
        drawState.program.uniform("mvp_matrix").set(mvp);
        drawState.program.use();
        scope(exit) drawState.program.unuse();

        ctx.draw(PrimitiveType.LineStrip, 0, cast(int) drawState.vertexData.ibo.size, drawState, sceneState);
    }
}
