module axis;

import gfm.math;

import common : Renderer;
import beholder.gldata : GLData;

struct Vertex
{
	vec3f position;
	vec4f color;
}

class AxisRenderer : Renderer
{
	import beholder.camera : Camera;

	this(Camera camera)
	{
		_camera = camera;
		{
			const program_source =
				"#version 330 core

				#if VERTEX_SHADER
				layout(location = 0) in vec3 position;
				layout(location = 1) in vec4 color;

				out vec4 fColor;

				uniform mat4 mvp_matrix;
				uniform float size;
				
				void main()
				{
					gl_Position = mvp_matrix * vec4(size*position.xyz, 1.0);
					fColor = color;
				}
				#endif

				#if FRAGMENT_SHADER
				in vec4 fColor;
				out vec4 color_out;

				void main()
				{
					color_out = fColor;
				}
				#endif
			";

			_program = new GLProgram(program_source);
		}

		_gldata = new GLData!Vertex(_program);
		update([
			Vertex(vec3f(0, 0, 0), vec4f(1, 1, 1, 1)),
			Vertex(vec3f(1, 0, 0), vec4f(1, 0, 0, 1)),
			Vertex(vec3f(0, 1, 0), vec4f(0, 1, 0, 1)),
			Vertex(vec3f(0, 0, 1), vec4f(0, 0, 1, 1)),
		], [0u, 1, 0, 2, 0, 3]);
	}

	~this()
	{
		if (_gldata !is null)
		{
			_gldata.destroy;
			_gldata = null;
		}
		if (_program !is null)
		{
			_program.destroy;
			_program = null;
		}
	}

	import std.range : isInputRange;
	void update(V, I)(V vertices, I indices)
		if (isInputRange!V && isInputRange!I)
	{
		_gldata.setData(vertices, indices);
	}

	void onRender()
	{
		_program.uniform("mvp_matrix").set(_camera.mvpMatrix);
		_program.uniform("size").set(cast()_camera.size);

		import gfm.opengl : glEnable;

		glEnable(GL_DEPTH_TEST);
		
		glEnable (GL_BLEND);
		glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		{
			_program.use();
			scope(exit) _program.unuse();

			_gldata.bind();
			long start = 0;
			glDrawElements(GL_LINES, cast(int) _gldata.length, GL_UNSIGNED_INT, cast(void *)(start * _gldata.indexSize()));
			glPointSize(10);
			glDrawElements(GL_POINTS, cast(int) _gldata.length, GL_UNSIGNED_INT, cast(void *)(start * _gldata.indexSize()));
			_gldata.unbind();

			runtimeCheck();
		}
	}

private:
	import gfm.opengl;
	GLProgram _program;
	GLData!Vertex _gldata;
	Camera    _camera;
}
