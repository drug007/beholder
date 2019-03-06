module auxinforenderer;

import common : Renderer;
import gldata : GLData;

struct Vertex
{
	import gfm.math : vec3f, vec4f;
	vec3f position;
	vec4f color;
}

class AuxInfoRenderer : Renderer
{
	import beholder.camera : Camera;
	import demo : DemoApplication;

	this(OpenGL gl, Camera camera)
	{
		_gl = gl;
		_camera = camera;
		{
			const program_source =
				"#version 330 core

				#if VERTEX_SHADER
				layout(location = 0) in vec3  position;
				layout(location = 1) in vec4  color;

				out vec4 vColor;

				uniform mat4 mvp_matrix;

				const float M_SQRT_2 = 1.4142135623730951;
				
				void main()
				{
					gl_Position = mvp_matrix * vec4(position.xyz, 1.0);
					gl_PointSize = 3.0;
					vColor = color;
				}
				#endif

				#if FRAGMENT_SHADER
				in vec4 vColor;
				out vec4 color_out;

				void main()
				{
					color_out = vColor;
				}
				#endif
			";

			_program = new GLProgram(_gl, program_source);
		}

		_gldata = new GLData!Vertex(_gl, _program);
	}

	~this()
	{
		if (_gldata !is null)
		{
			_gldata.destroy;
			_gldata = null;
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

		import gfm.opengl : glEnable, GL_PROGRAM_POINT_SIZE;
		glEnable(GL_PROGRAM_POINT_SIZE);
		
		glEnable (GL_BLEND);
		glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		{
			_program.use();
			scope(exit) _program.unuse();

			_gldata.bind();
			long start = 0;
			glDrawElements(GL_LINES, cast(int) _gldata.length, GL_UNSIGNED_INT, cast(void *)(start * _gldata.indexSize()));
			glDrawElements(GL_POINTS, cast(int) _gldata.length, GL_UNSIGNED_INT, cast(void *)(start * _gldata.indexSize()));
			_gldata.unbind();

			_gl.runtimeCheck();
		}
	}

private:
	import gfm.opengl;
	OpenGL    _gl;
	GLProgram _program;
	GLData!Vertex    _gldata;
	Camera    _camera;
}
