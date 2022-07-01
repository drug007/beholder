module beholder.clear_state;

import std.experimental.color : Color = RGBA8;

import gfm.opengl : GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT, GL_STENCIL_BUFFER_BIT;

import beholder.render_state.color_mask;


enum ClearBuffers
{
    colorBuffer = GL_COLOR_BUFFER_BIT,
    depthBuffer = GL_DEPTH_BUFFER_BIT,
    stencilBuffer = GL_STENCIL_BUFFER_BIT,
    colorAndDepthBuffer = colorBuffer | depthBuffer, 
    all = colorBuffer | depthBuffer | stencilBuffer,
}

struct ClearState
{
    // ScissorTest scissorTest = new ScissorTest();
    ColorMask colorMask = ColorMask(true, true, true, true);
    bool depthMask = true;
    int frontStencilMask = ~0;
    int backStencilMask = ~0;
    
    ClearBuffers buffers = ClearBuffers.all;
    Color color = Color("#FFFFFFFF");
    float depth = 1;
    int stencil = 0;
}