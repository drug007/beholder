module sourcerenderer;

import common : Renderer;
import gldata : GLData;

/// Value of index that indicating primitive restart
enum PrimitiveRestartIndex = 0xFFFF;

struct Vertex
{
	import gfm.math : vec3f, vec4f;
	vec3f position;
	vec4f color;
	float heading;
	float range;
}

class RDataSourceRenderer : Renderer
{
	import beholder.camera : Camera;
	import demo : DemoApplication;

	this(Camera camera)
	{
		_camera = camera;
		{
			const program_source =
				"#version 330 core

				#if VERTEX_SHADER
				layout(location = 0) in vec3  position;
				layout(location = 1) in vec4  color;
				layout(location = 2) in float heading;
				layout(location = 3) in float range;

				out vec4 vColor;
				out float vHeading;
				out float vRange;
				out float v_size;

				uniform mat4 mvp_matrix;
				uniform float size;
				uniform float linewidth;
				uniform float antialias;

				const float M_SQRT_2 = 1.4142135623730951;
				
				void main()
				{
					gl_Position = vec4(position.xyz, 1.0);
					v_size = M_SQRT_2 * size + 2.0*(linewidth + 1.5*antialias);
					gl_PointSize = v_size;
					vColor = color;
					vHeading = heading;
					vRange = range;
				}
				#endif

				#if GEOMETRY_SHADER
				layout(points) in;
				layout(line_strip, max_vertices = 2) out;

				uniform mat4 mvp_matrix;
				
				in vec4 vColor[]; // Output from vertex shader for each vertex
				in float vHeading[];
				in float vRange[];
				out vec4 fColor;  // Output to fragment shader

				const float PI = 3.1415926;

				void main()
				{
					fColor = vColor[0]; // Point has only one vertex
					float fHeading = vHeading[0];

					gl_Position = mvp_matrix * vec4(gl_in[0].gl_Position.xyz, 1.0);
					EmitVertex();

					vec4 offset = vec4(cos(vHeading[0]) * vRange[0], -sin(vHeading[0]) * vRange[0], 0.0, 0.0);
					gl_Position = mvp_matrix * vec4((gl_in[0].gl_Position+offset).xyz, 1.0);
					EmitVertex();

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
		_program.uniform("size").set(20.0f);
		_program.uniform("linewidth").set(2.0f);
		_program.uniform("antialias").set(1.0f);

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
	GLData!Vertex    _gldata;
	Camera    _camera;
}
