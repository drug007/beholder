module beholder.draw_state;

import beholder.context : Program;
import beholder.render_state.render_state;
import beholder.vertex_data.vertex_data;

struct DrawState
{
    @disable this();

    this(ref const(RenderState) renderState, Program program, VertexData vertexData)
    {
        this.renderState = renderState;
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

    RenderState renderState;
    Program     program;
    VertexData  vertexData;
}
