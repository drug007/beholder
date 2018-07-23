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

    void bind()
    {
        _vao.bind;
    }

    void unbind()
    {
        _vao.unbind;
    }

    auto destroy()
    {
        _vbo.destroy;
        _ibo.destroy;
        _vao.destroy();
    }

    @disable this();

    auto length()
    {
        return cast(int) _indices.length;
    }

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
            "#version 330 core

            #if VERTEX_SHADER
            layout(location = 0) in vec3 position;
            layout(location = 1) in vec4 color;
            out vec4 fragment;
            uniform mat4 mvp_matrix;
            void main()
            {
                gl_Position = mvp_matrix * vec4(position.xyz, 1.0);
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
            #endif";

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

    void draw(ref mat4f mvp_matrix)
    {
        _program.uniform("mvp_matrix").set(mvp_matrix);
        _program.use();
        scope(exit) _program.unuse();
        
        foreach(ref ds; _slices)
        {
            import gfm.opengl;
            ds.data.bind();
            glDrawElements(ds.glKind, ds.length, GL_UNSIGNED_INT, cast(void *)(ds.start));
            ds.data.unbind();
        }
    }

    auto addDataSlice()(auto ref DataSlice ds)
    {
        _slices ~= ds;
    }

    auto clearDataSlices()
    {
        _slices.length = 0;
    }

    auto make(alias A, V, I)(V vertices, I indices)
    {
        import std.array : array;
        import std.range : ElementType;

        static assert (is(ElementType!I : int), "Index should be a type that can be implicitly converted to int");
        auto indices_array = indices.array;
        auto gldata = new GLData(_gl, _vert_spec, vertices.array, indices_array);
        _gldata ~= gldata;
        return new A!(V, int[])(gldata, vertices, indices_array);
    }

    auto make(alias A, V)(V vertices)
    {
        import std.array : array;
        import std.range : iota, walkLength;

        auto indices_array = iota(cast(int) vertices.walkLength).array;
        return make!(A, V, int[])(vertices, indices_array);
    }

protected:
    import std.typecons : scoped;
    import gfm.opengl : GLProgram, OpenGL, VertexSpecification;
    import gfm.math : mat4f;
    import beholder.actor : DataSlice;

    alias ScopedVertexSpecification = typeof(scoped!(VertexSpecification!Vertex)(_program));

    OpenGL      _gl;
    GLProgram   _program;
    GLData[]    _gldata;
    DataSlice[] _slices;
    ScopedVertexSpecification _vert_spec;
}