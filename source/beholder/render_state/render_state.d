module beholder.render_state.render_state;

import beholder.render_state.depth_test;
import beholder.render_state.color_mask;

struct RenderState
{
    // RasterizationMode rasterizationMode;
    // PrimitiveRestart  primitiveRestart;
    // FacetCulling      facetCulling;
    // ScissorTest       scissorTest;
    // StencilTest       stencilTest;
    // DepthRange        depthRange;
    DepthTest         depthTest;
    ColorMask         colorMask = ColorMask(true, true, true, true);
    // Blending          blending;
    bool              depthMask;
}
