module beholder.actor;

import gfm.opengl : OpenGL, GLProgram;

class Actor(R, I)
{
    this(OpenGL gl, GLProgram program, R data, I indices)
    {
        this.data    = data;
        this.indices = indices;
    }

    R data;
    I indices;
}