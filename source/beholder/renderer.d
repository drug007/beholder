module beholder.renderer;

import beholder.actor : Actor;

class GLData
{
    import gfm.opengl;

    this(Vertex, VertexSpecification)(OpenGL gl, ref VertexSpecification vert_spec, Vertex[] vertices, int[] indices)
    {
        _indices = indices;
        _vbo = scoped!GLBuffer(gl, GL_ARRAY_BUFFER, GL_STATIC_DRAW, vertices);
        _ibo = scoped!GLBuffer(gl, GL_ELEMENT_ARRAY_BUFFER, GL_STATIC_DRAW, _indices);

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
    import gfm.opengl : GLBuffer, GLVAO;

    alias ScopedGLBuffer = typeof(scoped!GLBuffer(OpenGL.init, GL_ARRAY_BUFFER, GL_STATIC_DRAW, (ubyte[]).init));
    alias ScopedGLVAO = typeof(scoped!GLVAO(OpenGL.init));
    ScopedGLBuffer _vbo, _ibo;
    ScopedGLVAO    _vao;
    int[]          _indices;
}

class Renderer(Vertex)
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
        _vert_spec = scoped!(VertexSpecification!Vertex)(_program);
    }

    auto destroy()
    {
        foreach(ref data; _gldata)
        {
            if (data)
            {
                data.destroy;
                data = null;
                assert(data is null);
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
        
        foreach(data; _gldata)
            data.draw();
    }

    auto add(A)(A actor)
    {
        import std.array : array;
        _gldata ~= new GLData(_gl, _vert_spec, actor.data.array, actor.indices.array);
    }

    auto make(alias A, Args...)(Args args)
    {
        return new A!(Args)(_gl, _program, args);
    }

protected:
    import std.typecons : scoped;
    import gfm.opengl : GLProgram, OpenGL, VertexSpecification;

    alias ScopedVertexSpecification = typeof(scoped!(VertexSpecification!Vertex)(_program));

    OpenGL    _gl;
    GLProgram _program;
    GLData[]  _gldata;
    ScopedVertexSpecification _vert_spec;
}