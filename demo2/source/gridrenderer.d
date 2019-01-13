module gridrenderer;

import common : Parent, Renderer;
import gldata : GLData;

import gldata : Vertex;
import gfm.math : vec2f, vec3f, vec4f;
import std.math : PI;

/// Value of index that indicating primitive restart
enum PrimitiveRestartIndex = 0xFFFF;

class GridRenderer : Renderer
{
	import beholder.camera : Camera;
	import demo : DemoApplication;

	this(DemoApplication app)
	{
		_gl = app.gl;
		_camera = app.camera;
		{
			const program_source =
				"#version 330 core

				#if VERTEX_SHADER
				layout(location = 0) in vec3 position;
				layout(location = 1) in vec4 color;
				out vec4 vColor;
				uniform mat4 mv_matrix;
				uniform mat4 p_matrix;
				void main()
				{
					gl_Position = mv_matrix * vec4(position.xyz, 1.0);
					vColor = color;
				}
				#endif

				#if GEOMETRY_SHADER
				// 4 vertices per-primitive -- 2 for the line (1,2) and 2 for adjacency (0,3)
				layout (lines_adjacency) in;
				layout (triangle_strip, max_vertices = 4) out;

				in vec4 vColor[]; // Output from vertex shader for each vertex
				out vec4 fColor;  // Output to fragment shader
				out float distance; // Distance from center of line

				uniform mat4 mv_matrix;
				uniform mat4 p_matrix;

				uniform ivec2 resolution;
				uniform float linewidth;

				void main()
				{
					float lw = linewidth / resolution.x;
					vec3 diff = gl_in[2].gl_Position.xyz - gl_in[1].gl_Position.xyz;
					vec3 a_normal = normalize(vec3(diff.y, -diff.x, diff.z));
					vec4 delta = vec4(a_normal * lw, 0);

					gl_Position = p_matrix * gl_in[1].gl_Position - delta + 0.000005;
					fColor = vColor[1];
					distance = -1;
					EmitVertex();

					gl_Position = p_matrix * gl_in[2].gl_Position - delta + 0.000005;
					fColor = vColor[2];
					distance = -1;
					EmitVertex();

					gl_Position = p_matrix * gl_in[1].gl_Position + delta + 0.000005;
					fColor = vColor[1];
					distance = 1;
					EmitVertex();

					gl_Position = p_matrix * gl_in[2].gl_Position + delta + 0.000005;
					fColor = vColor[2];
					distance = 1;

					EmitVertex();

					EndPrimitive();
				}
				#endif

				#if FRAGMENT_SHADER
				in vec4 fColor;
				in float distance;
				out vec4 color_out;

				void main()
				{
					float d = abs(distance);
					if (d < 0.8)
						color_out = fColor;
					else if (d < 1.0)
						color_out = vec4(fColor.rgb, (1 - d)*2*fColor.a);
					else
						discard;
				}
				#endif
			";

			_program = new GLProgram(_gl, program_source);
		}

		_gldata = new GLData(_gl, _program);
		update;
		app.addRenderer(this);
	}

	~this()
	{
		if (_gldata !is null)
		{
			_gldata.destroy;
			_gldata = null;
		}
	}

	void update()
	{
		vec2f pos = _camera.position.xy;
		generateGrid(_gldata, _camera.size, pos, _camera.window.x, _camera.window.x/_camera.window.y);
	}

	void onRender()
	{
		import gfm.math : vec2i;

		_program.uniform("mv_matrix").set(_camera.modelView);
		_program.uniform("p_matrix").set(_camera.projection);
		_program.uniform("resolution").set(cast(vec2i)_camera.window);
		_program.uniform("linewidth").set(2.0f);

		glEnable(GL_PRIMITIVE_RESTART);
		glPrimitiveRestartIndex(PrimitiveRestartIndex);
		{
			_program.use();
			scope(exit) _program.unuse();

			_gldata.bind();
			long start = 0;
			glDrawElements(GL_LINE_STRIP_ADJACENCY, cast(int) _gldata.length, GL_UNSIGNED_INT, cast(void *)(start * _gldata.indexSize()));
			_gldata.unbind();

			_gl.runtimeCheck();
		}
	}

private:
	import gfm.opengl;
	OpenGL    _gl;
	GLProgram _program;
	GLData    _gldata;
	Camera    _camera;
}

void generateGrid(GLData grid, float halfWorldWidth, vec2f position, float sizeInPixels, float aspectRatio)
{
	// Color of lines
	vec4f color = vec4f(0.2, 0.2, 0.2, 1.0);

	enum Size = 1000;
	// Every lines has two vertices
	Vertex[Size*2] vertices;
	// and five indices
	uint[Size*5] indices;

	import std.math : quantize, floor, ceil, isNaN;

	assert(!position.x.isNaN);
	assert(!position.y.isNaN);

	auto left   = (position.x - 2.0 * halfWorldWidth);
	auto right  = (position.x + 2.0 * halfWorldWidth);
	auto top    = (position.y - 2.0 * halfWorldWidth/aspectRatio);
	auto bottom = (position.y + 2.0 * halfWorldWidth/aspectRatio);

	int l, i;
	auto xGenerator = CoordGenerator(left, right, sizeInPixels);
	foreach(x; xGenerator)
	{
		auto v = l*2;
		if (v+2 > vertices.length)
			break;
		vertices[v..v+2] = [ Vertex(vec3f(x, top, 0.0), color), Vertex(vec3f(x, bottom, 0.0), color)];
		indices[i..i+5] = [PrimitiveRestartIndex, v, v, v+1, v+1];
		l++;
		i += 5;
	}

	foreach(y; CoordGenerator(top, bottom, sizeInPixels/aspectRatio, xGenerator.interval))
	{
		auto v = l*2;
		if (v+2 > vertices.length)
			break;
		vertices[v..v+2] = [ Vertex(vec3f(left, y, 0.0), color), Vertex(vec3f(right, y, 0.0), color)];
		indices[i..i+5] = [PrimitiveRestartIndex, v, v, v+1, v+1];
		l++;
		i += 5;
	}

	grid.setData(vertices[0..l*2], indices[0..l*5]);
}

/// TODO : hardcoded values
enum CellSizeInPixels = 5.0 /* сантиметры */ * (1/2.54) /* convert to inches */ * 92 /* DPI */;

struct CoordGenerator
{
	float value, interval, pin, hi;

	this(float l, float h, float sizeInPixels, float forced_interval = 0)
	{
		import std.exception : enforce;
		import std.math : quantize, floor, ceil;

		enforce(h > l);
		float delta = h - l;
		interval = CellSizeInPixels*delta/sizeInPixels
			.quantize!ceil(CellSizeInPixels);

		auto new_interval = CellSizeInPixels;
		while(new_interval < interval)
			new_interval *= 2;
		while(new_interval > interval*2)
			new_interval *= 0.5;
		interval = forced_interval > 0 ? forced_interval : new_interval;
		enforce(interval > 0);

		value = l.quantize!floor(interval);
		hi = h.quantize!ceil(interval);
	}

	auto front()
	{
		return value;
	}
	
	void popFront()
	{
		value += interval;
	}
	
	bool empty()
	{
		return value > hi;
	}
}