module beholder.context;

import std.experimental.color : Color = RGBA8;

import gfm.opengl;
public import gfm.opengl : Program = GLProgram, VertexSpecification,
    Buffer = GLBuffer, VAO = GLVAO;

import beholder.clear_state;
import beholder.render_state.render_state;
import beholder.render_state.color_mask;
import beholder.render_state.depth_test;
import beholder.render_state.primitive_restart;
import beholder.draw_state;
import beholder.scene.scene_state;

enum CullFace { front, back, frontAndBack, }

enum WindingOrder { clockwise, counterclockwise, }

enum EnableCap { depthTest = GL_DEPTH_TEST, primitiveRestart = GL_PRIMITIVE_RESTART, }

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

enum PrimitiveType
{
    Points                 = GL_POINTS,
    Lines                  = GL_LINES,
    LineLoop               = GL_LINE_LOOP,
    LineStrip              = GL_LINE_STRIP,
    Triangles              = GL_TRIANGLES,
    TriangleStrip          = GL_TRIANGLE_STRIP,
    TriangleFan            = GL_TRIANGLE_FAN,
    LinesAdjacency         = GL_LINES_ADJACENCY,
    LineStripAdjacency     = GL_LINE_STRIP_ADJACENCY,
    TrianglesAdjacency     = GL_TRIANGLES_ADJACENCY,
    TriangleStripAdjacency = GL_TRIANGLE_STRIP_ADJACENCY,
}

class Context
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
        ref DrawState drawState, SceneState sceneState)
    {
        applyPrimitiveRestart(drawState.renderState.primitiveRestart);

        with(drawState.vertexData)
        {
            import gfm.opengl : glDrawElements, GL_UNSIGNED_INT;

            vao.bind();
            runtimeCheck();

            glDrawElements(primitiveType, cast(int) count, indexKind(), cast(void *) offset);
            vao.unbind();
        }

        runtimeCheck();
    }

    static auto makeProgram(string source)
    {
        return new GLProgram(source);
    }

    static auto makeVertexSpecification(Vertex)(Program program)
    {
        return new VertexSpecification!Vertex(program);
    }

    static auto makeBuffer(GLuint target, GLuint usage)
    {
        return new GLBuffer(target, usage);
    }

    static auto makeBuffer(T)(GLuint target, GLuint usage, T[] buffer)
    {
        return new GLBuffer(target, usage, buffer);
    }

    static auto makeVAO()
    {
        return new GLVAO();
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

    void applyPrimitiveRestart(ref const(PrimitiveRestart) primitiveRestart)
    {
        if (_renderState.primitiveRestart.enabled != primitiveRestart.enabled)
        {
            enable(EnableCap.primitiveRestart, primitiveRestart.enabled);
            _renderState.primitiveRestart.enabled = primitiveRestart.enabled;
        }

        if (primitiveRestart.enabled)
        {
            if (_renderState.primitiveRestart.index != primitiveRestart.index)
            {
                glPrimitiveRestartIndex(primitiveRestart.index);
                _renderState.primitiveRestart.index = primitiveRestart.index;
            }
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
    
void runtimeCheck() @trusted
{
    GLint r = glGetError();
    if (r != GL_NO_ERROR)
    {
        string errorString = getErrorString(r);
        version(none) flushGLErrors(); // flush other errors if any
        throw new OpenGLException(errorString);
    }
}

string getErrorString(GLint r) pure nothrow
{
    switch(r)
    {
        case GL_NO_ERROR:          return "GL_NO_ERROR";
        case GL_INVALID_ENUM:      return "GL_INVALID_ENUM";
        case GL_INVALID_VALUE:     return "GL_INVALID_VALUE";
        case GL_INVALID_OPERATION: return "GL_INVALID_OPERATION";
        case GL_OUT_OF_MEMORY:     return "GL_OUT_OF_MEMORY";
        case GL_STACK_OVERFLOW:    return "GL_STACK_OVERFLOW";
        case GL_STACK_UNDERFLOW:   return "GL_STACK_UNDERFLOW";
        default:                   return "Unknown OpenGL error";
    }
}
