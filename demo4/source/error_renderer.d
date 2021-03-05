module error_renderer;

import common : Renderer;
import beholder.gldata : GLData;

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

class ErrorRenderer : Renderer
{
	import beholder.camera : Camera;

	this(Camera camera)
	{
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
					v_pos_error = pos_error;
				}
				#endif

				#if GEOMETRY_SHADER
				layout(points) in;
				layout(triangle_strip, max_vertices = 40) out;

				uniform mat4 mvp_matrix;
				in vec4 v_pos_error[];
				varying float sigma;

				void main()
				{
					const float M_PI = 3.141592654;

					vec4 t = vec4(v_pos_error[0].xy, 0, 0);
					vec4 r = vec4(v_pos_error[0].zw, 0, 0);

					float a = length(t.xy);
					float b = length(r.xy);

					vec4 pos = gl_in[0].gl_Position;
					vec4 center = mvp_matrix * pos;
					
					float c = dot(normalize(t.xy), vec2(0, 1));
					float s = sin(acos(c));
					mat2 rot = mat2(c, -s, s, c);

					gl_Position = mvp_matrix * (pos+vec4(rot*vec2(a, 0), 0, 0));
					sigma = 1;
					EmitVertex();

					int count = 10;
					for(int i = 1; i < 3*count; i++)
					{
						vec2 offset = rot * vec2(a * cos(i*M_PI/count), b * sin(i*M_PI/count));
						gl_Position = mvp_matrix * (pos+vec4(offset, 0, 0));
						sigma = 1;
						EmitVertex();

						gl_Position = center;
						sigma = 0;
						EmitVertex();
					}

					EndPrimitive();
				}
				#endif

				#if FRAGMENT_SHADER
				out vec4 color_out;
				varying float sigma;

				void main()
				{
					if (sigma > 0.66)
					{
						float a = smoothstep(0.8, 0.999, sigma);
						color_out = vec4(0, 0, 1, a);
					}
					else if (sigma > 0.33)
					{
						float a = smoothstep(0.5, 0.666, sigma);
						color_out = vec4(0, 0.5, 0.5, a);
					}
					else
					{
						color_out = vec4(0, 0.8, 0, 1);
					}
				}
				#endif
			";

			_program = new GLProgram(program_source);
		}

		_gldata = new GLData!Vertex(_program);
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
		_gldata = new GLData!Vertex(_program);
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

			runtimeCheck();
		}
	}

private:
	import gfm.opengl;
	GLProgram _program;
	GLData!Vertex _gldata;
	Camera    _camera;
}
