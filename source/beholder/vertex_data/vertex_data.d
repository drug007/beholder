module beholder.vertex_data.vertex_data;

import beholder.vertex_data.vertex_spec;

class VertexData
{
	import std.range : isInputRange;
	import beholder.context : Context, Buffer, VAO;

    @disable this();
	
	this(IVertexSpec vertSpec)
	{
		import gfm.opengl : GL_UNSIGNED_INT, GL_ARRAY_BUFFER, GL_STATIC_DRAW,
			GL_ELEMENT_ARRAY_BUFFER;

		_indexKind = GL_UNSIGNED_INT;
		_indexTypeSize = 4;

		this.vertSpec = vertSpec;
		this.vbo = Context.makeBuffer(GL_ARRAY_BUFFER, GL_STATIC_DRAW);
		this.ibo = Context.makeBuffer(GL_ELEMENT_ARRAY_BUFFER, GL_STATIC_DRAW);
		this.vao = Context.makeVAO();
	}

	this(V, I)(IVertexSpec vertSpec, V vertices, I indices)
	{
		this(vertSpec);
		setData(vertices, indices);
	}

	void setData(V, I)(V vertices, I indices)
		if (isInputRange!V && isInputRange!I)
	{
		import std.range : ElementType;
        import std.traits : Unqual;
        import std.meta : AliasSeq;
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

		import gfm.opengl : GL_UNSIGNED_BYTE, GL_UNSIGNED_SHORT, GL_UNSIGNED_INT;
		_indexKind = AliasSeq!(GL_UNSIGNED_BYTE, GL_UNSIGNED_SHORT, GL_UNSIGNED_INT)[IndexElementKind];
		_indexTypeSize = AliasSeq!(1, 2, 4)[IndexElementKind];

		import std.array : array;

		assert(vertices.length);
        assert(vbo);
        assert(ibo);
		assert(vao);

        vbo.setData(vertices.array);
        ibo.setData(indices.array);

		// prepare VAO
        vao.bind();
        vbo.bind();
        ibo.bind();
        vertSpec.use();
        vao.unbind();
	}

	~this()
	{
		if(vbo)
		{
			vbo.destroy();
			vbo = null;
		}
		if(ibo)
		{
			ibo.destroy();
			ibo = null;
		}
		if(vertSpec)
		{
			vertSpec.destroy();
			vertSpec = null;
		}
		if(vao)
		{
			vao.destroy();
			vao = null;
		}
	}

	/// Тип, используемый для хранения индексов
	auto indexKind() { return _indexKind; }
	auto indexSize() { return _indexTypeSize; }

	import gfm.opengl : GLenum;

	private GLenum _indexKind;
	private ubyte  _indexTypeSize;

	Buffer vbo, ibo;
	VAO    vao;
	IVertexSpec vertSpec;
}
