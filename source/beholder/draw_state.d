module beholder.draw_state;

import gfm.opengl : GLProgram, GLVAO;
import beholder.render_state.render_state;
import beholder.vertex_data.vertex_data;

struct DrawState
{
    @disable this();

    this(ref const(RenderState) renderState, GLProgram program, VertexData vertexData)
    {
        this.renderState = &renderState;
        this.program = program;
        this.vertexData = vertexData;
    }

    ~this()
    {
        if (program !is null)
        {
            destroy(program);
            program = null;
        }
        if (vertexData !is null)
        {
            destroy(vertexData);
            vertexData = null;
        }
    }

    const(RenderState)* renderState;
    GLProgram           program;
    VertexData          vertexData;
}
