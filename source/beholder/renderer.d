module beholder.renderer;

import beholder.actor : Actor;

class GLActor
{
    import gfm.opengl;

    this(Vertex)(OpenGL gl, GLProgram program, Vertex[] vertices, int[] indices)
    {
        _indices = indices;
        _vbo = scoped!GLBuffer(gl, GL_ARRAY_BUFFER, GL_STATIC_DRAW, vertices);
        _ibo = scoped!GLBuffer(gl, GL_ELEMENT_ARRAY_BUFFER, GL_STATIC_DRAW, _indices);

        auto vert_spec = scoped!(VertexSpecification!Vertex)(program);
        scope(exit) vert_spec.destroy;

        _vao = scoped!GLVAO(gl);
        // prepare VAO
        {
            _vao.bind();
            _vbo.bind();
            _ibo.bind();
            vert_spec.use();
            _vao.unbind();
        }
    }

    auto draw()
    {
        _vao.bind();
        auto length = cast(int) _indices.length;
        auto start  = cast(int) 0;
        glDrawElements(GL_TRIANGLES, length, GL_UNSIGNED_INT, cast(void *)(start * 4));
        _vao.unbind();
    }

    auto destroy()
    {
        _vbo.destroy;
        _ibo.destroy;
        _vao.destroy();
    }

    @disable this();

protected:
    import std.typecons : scoped;
    import gfm.opengl : GLBuffer, GLVAO, VertexSpecification;

    alias ScopedGLBuffer = typeof(scoped!GLBuffer(OpenGL.init, GL_ARRAY_BUFFER, GL_STATIC_DRAW, (ubyte[]).init));
    alias ScopedGLVAO = typeof(scoped!GLVAO(OpenGL.init));
    ScopedGLBuffer _vbo, _ibo;
    ScopedGLVAO    _vao;
    int[]          _indices;
}

class Renderer
{
    this(OpenGL gl)
    {
        _gl = gl;
        const program_source =
            q{#version 330 core

            #if VERTEX_SHADER
            layout(location = 0) in vec3 position;
            layout(location = 1) in vec4 color;
            out vec4 fragment;
            void main()
            {
                gl_Position = vec4(position.xyz, 1.0);
                gl_PointSize = 3.0;                
                fragment = color;
            }
            #endif

            #if FRAGMENT_SHADER
            in vec4 fragment;
            out vec4 color_out;

            void main()
            {
                color_out = fragment;
            }
            #endif
        };

        _program = new GLProgram(_gl, program_source);
        assert(_program);
    }

    auto destroy()
    {
        foreach(ref actor_gl; _gl_actors)
        {
            if (actor_gl)
            {
                actor_gl.destroy;
                actor_gl = null;
                assert(actor_gl is null);
            }
        }

        if (_program)
        {
            _program.destroy();
            _program = null;
        }
    }

    void draw()
    {
        _program.use();
        scope(exit) _program.unuse();
        
        foreach(actor; _gl_actors)
            actor.draw();
    }

    auto add(A)(A actor)
    {
        import std.array : array;
        _gl_actors ~= new GLActor(_gl, _program, actor.data.array, actor.indices.array);
    }

protected:
    import gfm.opengl : GLProgram, OpenGL;

    OpenGL    _gl;
    GLProgram _program;
    GLActor[] _gl_actors;
}