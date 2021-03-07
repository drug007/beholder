module sharikirenderer;

import gfm.math;

import common : Renderer;
import beholder.gldata : GLData;

/// Value of index that indicating primitive restart
enum PrimitiveRestartIndex = 0xFFFF;

struct Vertex
{
	vec3f position;
	vec4f color;
	float radius;
}

class SharikiRenderer : Renderer
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
				layout(location = 1) in vec4  color;
				layout(location = 2) in float radius;

				out vec4 vColor;
				out float vRadius;

				uniform mat4 mv_matrix;
				uniform mat4 p_matrix;

				const float M_SQRT_2 = 1.4142135623730951;
				
				void main()
				{
					gl_Position = mv_matrix * vec4(position.xyz, 1.0);
					vRadius = radius;
					vColor = color;
				}
				#endif

				#if GEOMETRY_SHADER
				layout (points) in;
				layout (triangle_strip, max_vertices = 4) out;

				in vec4 vColor[]; // Output from vertex shader for each vertex
				in float vRadius[];
				out vec4 fColor;  // Output to fragment shader
				out vec2 distance; // Distance from center of line

				uniform mat4 mv_matrix;
				uniform mat4 p_matrix;

				void main()
				{
					/*

					3----1
					|   /|
					|  / |
					| /  |
					2----0

					two triangles {0, 1, 2} and {1, 2, 3}

					*/
					gl_Position = p_matrix * ((gl_in[0].gl_Position) + vec4(+vRadius[0], -vRadius[0], 0, 0));
					fColor = vColor[0];
					distance = vec2(+1, -1);
					EmitVertex();

					gl_Position = p_matrix * ((gl_in[0].gl_Position) + vec4(+vRadius[0], +vRadius[0], 0, 0));
					fColor = vColor[0];
					distance = vec2(+1, +1);
					EmitVertex();

					gl_Position = p_matrix * ((gl_in[0].gl_Position) + vec4(-vRadius[0], -vRadius[0], 0, 0));
					fColor = vColor[0];
					distance = vec2(-1, -1);
					EmitVertex();

					gl_Position = p_matrix * ((gl_in[0].gl_Position) + vec4(-vRadius[0], +vRadius[0], 0, 0));
					fColor = vColor[0];
					distance = vec2(-1, +1);
					EmitVertex();

					EndPrimitive();
				}
				#endif

				#if FRAGMENT_SHADER
				in vec4 fColor;
				in vec2 distance;
				out vec4 color_out;

				uniform vec3 lightDir = vec3(0.577, 0.577, 0.577);

				void main()
				{
					vec3 N;
					N.xy = distance;
					float r2 = dot(N.xy, N.xy);
					if (r2 > 1.0) discard;
					N.z = sqrt(1.0-r2);

					float diffuse = 0.8*max(0.0, dot(N, lightDir));
					vec4 ambient = vec4(0.2, 0.2, 0.2, fColor.a);
					color_out = diffuse * fColor + ambient;
				}
				#endif
			";

			_program = new GLProgram(program_source);
		}

		_gldata = new GLData!Vertex(_program);
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
		_program.uniform("mv_matrix").set(_camera.modelView);
		_program.uniform("p_matrix").set(_camera.projection);

		import gfm.opengl : glEnable;

		glEnable(GL_DEPTH_TEST);
		
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
