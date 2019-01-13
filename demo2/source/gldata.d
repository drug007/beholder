module gldata;

struct Vertex
{
	import gfm.math : vec3f, vec4f;
	vec3f position;
	vec4f color;
	float heading;
	uint  source;
	uint  number;
	uint  timestamp_hi;
	uint  timestamp_lo;
}

class GLData
{
	this(OpenGL gl, GLProgram program)
	{
		_indexKind = GL_UNSIGNED_INT;
		_indexTypeSize = 4;

		_vbo = new GLBuffer(gl, GL_ARRAY_BUFFER, GL_DYNAMIC_DRAW);
		_ibo = new GLBuffer(gl, GL_ELEMENT_ARRAY_BUFFER, GL_DYNAMIC_DRAW);

		// Create an OpenGL vertex description from the Vertex structure.
		_vs = new VertexSpecification!Vertex(program);

		_vao = new GLVAO(gl);
	}

	this(V, I)(OpenGL gl, GLProgram program, V vertices, I indices)
	{
		this(gl, program);
		setData(vertices, indices);
	}

	void setData(V, I)(V vertices, I indices)
		if (isInputRange!V && isInputRange!I)
	{
		import std.range : ElementType;
		import std.typecons : Unqual, AliasSeq;
		import std.meta : staticIndexOf;

		// Unqualified element type of the index range
		alias IndexElementType = Unqual!(ElementType!I);
		// Only unsigned byte, short and int are permitted to be used as element type
		// IndexElementKind is equal to 0 if element type is unsigned byte, 1 in case of
		// unsigned short, 2 in case of unsigned int and -1 in case of some other type
		enum IndexElementKind = staticIndexOf!(IndexElementType, AliasSeq!(ubyte, ushort, uint));
		// Check if element type of the index range is permitted one
		static assert (IndexElementKind >= 0 && IndexElementKind < 3, "Index has wrong type: `" ~ IndexElementType.stringof ~
			"`. Possible types are ubyte, ushort and uint.");

		_indexKind = AliasSeq!(GL_UNSIGNED_BYTE, GL_UNSIGNED_SHORT, GL_UNSIGNED_INT)[IndexElementKind];
		_indexTypeSize = AliasSeq!(1, 2, 4)[IndexElementKind];
		
		import std.array : array;

		assert(vertices.length);
		if (vertices.length == 0)
			return;
		{
			assert(_vbo);
			_vbo.setData(vertices.array);
		}
		{
			assert(_ibo);
			auto arr = indices.array;
			_ibo.setData(arr);
			_length = arr.length;
		}

		// prepare VAO
		{
			assert(_vao);
			_vao.bind();
			_vbo.bind();
			_ibo.bind();
			_vs.use();
			_vao.unbind();
		}
	}

	auto   bind() { _vao.bind;   }
	auto unbind() { _vao.unbind; }
	auto length() const { return _length; }


	/// Тип, используемый для хранения индексов
	auto indexKind() { return _indexKind; }
	auto indexSize() { return _indexTypeSize; }
	
	~this()
	{
		if(_vbo)
		{
			_vbo.destroy();
			_vbo = null;
		}
		if(_ibo)
		{
			_ibo.destroy();
			_ibo = null;
		}
		if(_vs)
		{
			_vs.destroy();
			_vs = null;
		}
		if(_vao)
		{
			_vao.destroy();
			_vao = null;
		}
	}

private:
	import std.range : isInputRange;
	import gfm.opengl;

	GLBuffer      _vbo, _ibo;
	GLVAO         _vao;
	VertexSpecification!Vertex _vs;
	size_t        _length;
	
	GLenum _indexKind;
	ubyte  _indexTypeSize;
}