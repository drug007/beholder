module beholder.render_state.depth_test;

import gfm.opengl;

enum DepthTestFunction
{
    Never              = GL_NEVER,
    Less               = GL_LESS,
    Equal              = GL_EQUAL,
    LessThanOrEqual    = GL_LEQUAL,
    Greater            = GL_GREATER,
    NotEqual           = GL_NOTEQUAL,
    GreaterThanOrEqual = GL_GEQUAL,
    Always             = GL_ALWAYS,
}

struct DepthTest
{
    bool enabled = true;
    DepthTestFunction func = DepthTestFunction.Less;
}
