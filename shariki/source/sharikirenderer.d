module sharikirenderer;

import common : Renderer;
import beholder.gldata : GLData;

/// Value of index that indicating primitive restart
enum PrimitiveRestartIndex = 0xFFFF;

struct Vertex
{
	import gfm.math : vec3f;
	vec3f position;
	float radius;
	int kind;
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
				layout(location = 1) in float radius;
				layout(location = 2) in int   kind;

				out vec4 vColor;
				out float vSize;

				uniform mat4 mvp_matrix;
				uniform float size;

				const float M_SQRT_2 = 1.4142135623730951;
				
				void main()
				{
					gl_Position = mvp_matrix * vec4(position.xyz, 1.0);
					vSize = M_SQRT_2 * size;// + 2.0*(linewidth + 1.5*antialias);
					gl_PointSize = vSize;
					vColor = vec4(0, 1, 0, 1);
				}
				#endif

				#if FRAGMENT_SHADER
				in vec4 vColor;
				in float vSize;
				out vec4 color_out;

				uniform float size;

				const float PI = 3.14159265358979323846264;
				const float M_SQRT_2 = 1.4142135623730951;

				vec4 filled(float distance, // Signed distance to line
					float linewidth,        // Stroke line width
					float antialias,        // Stroke antialiased area
					vec4 fill)              // Fill color
				{
					float t = linewidth / 2.0 - antialias;
					float signed_distance = distance;
					float border_distance = abs(signed_distance) - t;
					float alpha = border_distance / antialias;
					alpha = exp(-alpha * alpha);
					if( border_distance < 0.0 )
						return fill;
					else if( signed_distance < 0.0 )
						return fill;
					else
						return vec4(fill.rgb, alpha * fill.a);
				}

				float disc(vec2 P, float size)
				{
					return length(P) - size/2;
				}
				
				void main()
				{
					vec2 p = gl_PointCoord.xy - vec2(0.5,0.5);
					float distance = disc(p*vSize, size);
					float linewidth = 1.0;
					float antialias = 1.0;
					color_out = filled(distance, linewidth, antialias, vColor);
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
		_program.uniform("mvp_matrix").set(_camera.mvpMatrix);
		_program.uniform("size").set(10.0f);

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
