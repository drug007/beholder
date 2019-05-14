module beholder.actor;

import gfm.opengl;
import beholder.renderer : GLData;

struct DataSlice
{
	enum Kind { Triangles, Points, LineStrip, }

	private GLenum _kind = GL_TRIANGLES;
	GLData data;
	int start;
	int length;

	auto glKind() const
	{
		return _kind;
	}

	auto kind() const
	{
		switch(_kind)
		{
			case GL_TRIANGLES:
				return Kind.Triangles;
			case GL_POINTS:
				return Kind.Points;
			case GL_LINE_STRIP:
				return Kind.LineStrip;
			default:
				assert(0);
		}
	}

	auto kind(Kind kind)
	{
		final switch(kind)
		{
			case Kind.Triangles:
				_kind = GL_TRIANGLES;
			break;
			case Kind.Points:
				_kind = GL_POINTS;
			break;
			case Kind.LineStrip:
				_kind = GL_LINE_STRIP;
			break;
		}
	}
}

class Actor(R, I)
{
	alias Kind = DataSlice.Kind;

	this(GLData gl_data, R domain_data, I indices)
	{
		_gl_data     = gl_data;
		_domain_data = domain_data;
		_indices     = indices;
		_data_slice  = DataSlice(GL_TRIANGLES, _gl_data, 0, _gl_data.length);
	}

	ref dataSlice()
	{
		return _data_slice;
	}

	auto kind()
	{
		return _data_slice.kind;
	}

	void kind(Kind kind)
	{
		_data_slice.kind = kind;
	}

protected:
	R _domain_data;
	I _indices;
	GLData _gl_data;
	DataSlice _data_slice;
}