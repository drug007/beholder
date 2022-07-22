module beholder.context;

import std.experimental.color : Color = RGBA8;

import gfm.opengl;

import beholder.clear_state;
import beholder.render_state.render_state;
import beholder.render_state.color_mask;
import beholder.render_state.depth_test;
import beholder.draw_state;

enum CullFace { front, back, frontAndBack, }

enum WindingOrder { clockwise, counterclockwise, }

enum EnableCap { depthTest, }

struct FacetCulling
{
    bool enabled = true;
    CullFace face = CullFace.back;
    WindingOrder frontFaceWindingOrder = WindingOrder.counterclockwise;
}

enum SourceBlendingFactor
{
    zero,
    one,
    sourceAlpha,
    oneMinusSourceAlpha,
    destinationAlpha,
    oneMinusDestinationAlpha,
    destinationColor,
    oneMinusDestinationColor,
    sourceAlphaSaturate,
    constantColor,
    oneMinusConstantColor,
    constantAlpha,
    oneMinusConstantAlpha,
}

enum DestinationBlendingFactor
{
    zero,
    one,
    sourceColor,
    oneMinusSourceColor,
    sourceAlpha,
    OneMinusSourceAlpha,
    destinationAlpha,
    oneMinusDestinationAlpha,
    destinationColor,
    oneMinusDestinationColor,
    constantColor,
    oneMinusConstantColor,
    constantAlpha,
    oneMinusConstantAlpha,
}

enum BlendEquation
{
    add,
    minimum,
    maximum,
    subtract,
    reverseSubtract,
}

struct Blending
{
    bool enabled = false;
    SourceBlendingFactor sourceRGBFactor = SourceBlendingFactor.one;
    SourceBlendingFactor sourceAlphaFactor = SourceBlendingFactor.one;
    DestinationBlendingFactor destinationRGBFactor = DestinationBlendingFactor.zero;
    DestinationBlendingFactor destinationAlphaFactor = DestinationBlendingFactor.zero;
    BlendEquation rGBEquation = BlendEquation.add;
    BlendEquation alphaEquation = BlendEquation.add;
    Color color = Color("#00000000");
}

struct SceneState
{

}

enum PrimitiveType { one, two, }

struct Context
{
    void clear(ref const(ClearState) clearState)
    {
        version(none) applyFBO();
        version(none) applyScissorTest(clearState.scissorTest);
        applyColorMask(clearState.colorMask);
        applyDepthMask(clearState.depthMask);

        // if (_clearColor != clearState.color)
        // {
        //     GL.ClearColor(clearState.color);
        //     _clearColor = clearState.color;
        // }

        // if (_clearDepth != clearState.depth)
        // {
        //     GL.ClearDepth(cast(double) clearState.depth);
        //     _clearDepth = clearState.depth;
        // }

        // if (_clearStencil != clearState.stencil)
        // {
        //     GL.ClearStencil(clearState.stencil);
        //     _clearStencil = clearState.stencil;
        // }

        glClear(clearState.buffers);
    }

    void draw(PrimitiveType primitiveType, int offset, int count, 
        ref const(DrawState) drawState, ref const(SceneState) sceneState)
    {
        assert(0);
    }

private:

    version(none) void applyFBO()
    {
        if (_boundFBO !is _setFBO)
        {
            if (_setFBO !is null)
                _setFBO.use();
            else
                _setFBO.unuse();

            _boundFBO = _setFBO;
        }

        if (_setFBO !is null)
        {
            _setFBO.clean();
            version(none)
            {
                FBOErrorCode errorCode = GL.CheckFBOStatus(FBOTarget.FBO);
                if (errorCode != FBOErrorCode.FBOComplete)
                {
                    throw new InvalidOperationException("Frame buffer is incomplete.  Error code: " +
                        errorCode.ToString());
                }
            }
        }
    }

    void applyColorMask(ColorMask colorMask)
    {
        if (_renderState.colorMask != colorMask)
        {
            glColorMask(colorMask.r, colorMask.g, colorMask.b, colorMask.a);
            _renderState.colorMask = colorMask;
        }
    }

    void applyDepthMask(bool depthMask)
    {
        if (_renderState.depthMask != depthMask)
        {
            glDepthMask(depthMask);
            _renderState.depthMask = depthMask;
        }
    }

    void applyDepthTest(DepthTest depthTest)
    {
        if (_renderState.depthTest.enabled != depthTest.enabled)
        {
            enable(EnableCap.depthTest, depthTest.enabled);
            _renderState.depthTest.enabled = depthTest.enabled;
        }

        if (depthTest.enabled)
        {
            if (_renderState.depthTest.func != depthTest.func)
                glDepthFunc(depthTest.func);
            _renderState.depthTest.func = depthTest.func;
        }
    }

    void enable(EnableCap enableCap, bool enable)
    {
        if (enable)
            glEnable(enableCap);
        else
            glDisable(enableCap);
    }

    RenderState _renderState = RenderState();
    version(none) GLFBO _boundFBO, _setFBO;
}