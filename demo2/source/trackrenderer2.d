module trackrenderer2;

import common : Renderer;
import gldata : GLData;

/// Value of index that indicating primitive restart
enum PrimitiveRestartIndex = 0xFFFF;

struct Vertex
{
	import gfm.math : vec3f, vec4f;
	vec3f position;
	vec4f pos_error;
	vec4f color;
	vec3f velocity;
}

class TrackRenderer : Renderer
{
	import beholder.camera : Camera;

	this(OpenGL gl, Camera camera)
	{
		_gl = gl;
		_camera = camera;
		{
			const program_source =
				"#version 330 core

				#if VERTEX_SHADER
				layout(location = 0) in vec3  position;
				layout(location = 1) in vec4  pos_error;
				layout(location = 2) in vec4  color;
				layout(location = 3) in vec3  velocity;

				out vec4  vColor;
				out vec3  vVelocity;
				out vec4  v_pos_error;
				out float v_size;

				const float M_SQRT_2 = 1.4142135623730951;
				
				void main()
				{
					gl_Position = vec4(position.xyz, 1.0);
					vColor = color;
					v_pos_error = pos_error;
				}
				#endif

				#if GEOMETRY_SHADER
				layout(points) in;
				layout(triangle_strip, max_vertices = 40) out;

				uniform mat4 mvp_matrix;
				
				in vec4 vColor[]; // Output from vertex shader for each vertex
				in vec4 v_pos_error[];
				out vec4 fColor;  // Output to fragment shader

				const float M_PI = 3.141592654;

				void main()
				{
					fColor = vColor[0];

					vec4 t = vec4(v_pos_error[0].xy, 0, 0);
					vec4 r = vec4(v_pos_error[0].zw, 0, 0);

					float a = length(t.xy);
					float b = length(r.xy);

					vec4 pos = gl_in[0].gl_Position;
					vec4 center = mvp_matrix * pos;

					gl_Position = mvp_matrix * (pos+vec4(a, 0, 0, 0));
					fColor = vec4(0, 0, 1, 1);
					EmitVertex();

					int count = 10;
					for(int i = 1; i < 3*count; i++)
					{
						vec4 offset = vec4(a * cos(i*M_PI/count), b * sin(i*M_PI/count), 0, 0);
						gl_Position = mvp_matrix * (pos+offset);
						fColor = vec4(0, 0, 1, 1);
						EmitVertex();

						gl_Position = center;
						fColor = vec4(1, 0, 0, 1);
						EmitVertex();
					}

					EndPrimitive();
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

			_program = new GLProgram(_gl, program_source);
		}

		_gldata = new GLData!Vertex(_gl, _program);
	}

	~this()
	{
		clear;
	}

	import std.range : isInputRange;
	void update(V, I)(V vertices, I indices)
		if (isInputRange!V && isInputRange!I)
	{
		_gldata.setData(vertices, indices);
	}

	protected void clear()
	{
		if (_gldata !is null)
		{
			_gldata.destroy;
			_gldata = null;
		}
	}

	void reset()
	{
		clear;
		_gldata = new GLData!Vertex(_gl, _program);
	}

	void onRender()
	{
		_program.uniform("mvp_matrix").set(_camera.mvpMatrix);

		import gfm.opengl : glEnable, GL_PROGRAM_POINT_SIZE;
		glEnable(GL_PROGRAM_POINT_SIZE);
		
		glEnable (GL_BLEND);
		glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

		glEnable(GL_PRIMITIVE_RESTART);
		glPrimitiveRestartIndex(PrimitiveRestartIndex);
		{
			_program.use();
			scope(exit) _program.unuse();

			_gldata.bind();
			long start = 0;
			glDrawElements(GL_POINTS, cast(int) _gldata.length, GL_UNSIGNED_INT, cast(void *)(start * _gldata.indexSize()));
			_gldata.unbind();

			_gl.runtimeCheck();
		}
	}

private:
	import gfm.opengl;
	OpenGL    _gl;
	GLProgram _program;
	GLData!Vertex _gldata;
	Camera    _camera;
}
