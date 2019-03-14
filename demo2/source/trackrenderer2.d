module trackrenderer2;

import common : Renderer;
import gldata : GLData;

/// Value of index that indicating primitive restart
enum PrimitiveRestartIndex = 0xFFFF;

struct Vertex
{
	import gfm.math : vec3f, vec4f;
	vec3f position;
	vec4f color;
	vec3f velocity;
	uint  source;
	uint  number;
	uint  timestamp_hi;
	uint  timestamp_lo;
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
				layout(location = 1) in vec4  color;
				layout(location = 2) in vec3  velocity;
				layout(location = 3) in uint  source;
				layout(location = 4) in uint  number;
				layout(location = 5) in uint  timestamp_hi;
				layout(location = 6) in uint  timestamp_lo;

				out vec4 vColor;
				out vec3 vVelocity;
				out float v_size;
				
				flat out uint current_source;
				flat out uint current_number;
				flat out uint current_timestamp_hi;
				flat out uint current_timestamp_lo;

				uniform mat4 mvp_matrix;
				uniform float size;
				uniform float linewidth;
				uniform float antialias;

				const float M_SQRT_2 = 1.4142135623730951;
				
				void main()
				{
					gl_Position = mvp_matrix * vec4(position.xyz, 1.0);
					v_size = M_SQRT_2 * size + 2.0*(linewidth + 1.5*antialias);
					gl_PointSize = v_size;
					vColor = color;
					vVelocity = velocity;
					
					current_source = source;
					current_number = number;
					current_timestamp_hi = timestamp_hi;
					current_timestamp_lo = timestamp_lo;
				}
				#endif

				#if FRAGMENT_SHADER
				in vec4 vColor;
				in vec3 vVelocity;
				in float v_size;
				flat in uint current_source;
				flat in uint current_number;
				flat in uint current_timestamp_hi;
				flat in uint current_timestamp_lo;
				out vec4 color_out;

				uniform float size;
				uniform float linewidth;
				uniform float antialias;

				uniform uint source;
				uniform uint number;
				uniform uint timestamp_hi;
				uniform uint timestamp_lo;

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

				vec4 outline(float distance, // Signed distance to line
					float linewidth,         // Stroke line width
					float antialias,         // Stroke antialiased area
					vec4 stroke,             // Stroke color
					vec4 fill)               // Fill color
				{
					float t = linewidth / 2.0 - antialias;
					float signed_distance = distance;
					float border_distance = abs(signed_distance) - t;
					float alpha = border_distance / antialias;
					
					alpha = exp(-alpha * alpha);

					if( border_distance < 0.0 )
						return stroke;
					else if( signed_distance < 0.0 )
						return mix(fill, stroke, sqrt(alpha));
					else
						return vec4(stroke.rgb, stroke.a * alpha);
				}

				float disc(vec2 P, float size)
				{
					return length(P) - size/2;
				}

				float heart(vec2 P, float size)
				{
					float x = M_SQRT_2/2.0 * (P.x - P.y);
					float y = M_SQRT_2/2.0 * (P.x + P.y);
					float r1 = max(abs(x),abs(y))-size/3.5;
					float r2 = length(P - M_SQRT_2/2.0*vec2(+1.0,-1.0)*size/3.5)
						- size/3.5;
					float r3 = length(P - M_SQRT_2/2.0*vec2(-1.0,-1.0)*size/3.5)
						- size/3.5;
					return min(min(r1,r2),r3);
				}

				// Computes the signed distance from a line
				float line_distance(vec2 p, vec2 p1, vec2 p2) {
					vec2 center = (p1 + p2) * 0.5;
					float len = length(p2 - p1);
					vec2 dir = (p2 - p1) / len;
					vec2 rel_p = p - center;
					return dot(rel_p, vec2(dir.y, -dir.x));
				}

				// Computes the signed distance from a line segment
				float segment_distance(vec2 p, vec2 p1, vec2 p2) {
					vec2 center = (p1 + p2) * 0.5;
					float len = length(p2 - p1);
					vec2 dir = (p2 - p1) / len;
					vec2 rel_p = p - center;
					float dist1 = abs(dot(rel_p, vec2(dir.y, -dir.x)));
					float dist2 = abs(dot(rel_p, dir)) - 0.5*len;
					return max(dist1, dist2);
				}

				// Computes the centers of a circle with
				// given radius passing through p1 & p2
				vec4 inscribed_circle(vec2 p1, vec2 p2, float radius)
				{
					float q = length(p2-p1);
					vec2 m = (p1+p2)/2.0;
					vec2 d = vec2( sqrt(radius*radius - (q*q/4.0)) * (p1.y-p2.y)/q,
					sqrt(radius*radius - (q*q/4.0)) * (p2.x-p1.x)/q);
					return vec4(m+d, m-d);
				}

				float arrow_curved(vec2 texcoord, float body_, float head,
					float linewidth, float antialias)
				{
					float w = linewidth/2.0 + antialias;
					vec2 start = -vec2(body_/2.0, 0.0);
					vec2 end = +vec2(body_/2.0, 0.0);
					float height = 0.5;
					vec2 p1 = end - head*vec2(+1.0,+height);
					vec2 p2 = end - head*vec2(+1.0,-height);
					vec2 p3 = end;
					// Head : 3 circles
					vec2 c1 = inscribed_circle(p1, p3, 1.25*body_).zw;
					float d1 = length(texcoord - c1) - 1.25*body_;
					vec2 c2 = inscribed_circle(p2, p3, 1.25*body_).xy;
					float d2 = length(texcoord - c2) - 1.25*body_;
					vec2 c3 = inscribed_circle(p1, p2, max(body_-head, 1.0*body_)).xy;
					float d3 = length(texcoord - c3) - max(body_-head, 1.0*body_);
					// Body : 1 segment
					float d4 = segment_distance(texcoord,
					start, end - vec2(linewidth,0.0));
					// Outside rejection (because of circles)

					if( texcoord.y > +(2.0*head + antialias) )
						return 1000.0;
					if( texcoord.y < -(2.0*head + antialias) )
						return 1000.0;
					if( texcoord.x < -(body_/2.0 + antialias) )
						return 1000.0;
					if( texcoord.x > c1.x )
						return 1000.0;
					return min( d4, -min(d3,min(d1,d2)));
				}

				float arrow_angle(vec2 texcoord,
					float body_, float head, float height,
					float linewidth, float antialias)
				{
					float d;
					float w = linewidth/2.0 + antialias;
					vec2 start = -vec2(body_/2.0, 0.0);
					vec2 end = +vec2(body_/2.0, 0.0);
					// Arrow tip (beyond segment end)
					if( texcoord.x > body_/2.0) {
						// Head : 2 segments
						float d1 = line_distance(texcoord,
							end, end - head*vec2(+1.0,-height));
						float d2 = line_distance(texcoord,
							end - head*vec2(+1.0,+height), end);
						// Body : 1 segment
						float d3 = end.x - texcoord.x;
						d = max(max(d1,d2), d3);
					} else {
						// Head : 2 segments
						float d1 = segment_distance(texcoord,
							end - head*vec2(+1.0,-height), end);
						float d2 = segment_distance(texcoord,
							end - head*vec2(+1.0,+height), end);
						// Body : 1 segment
						float d3 = segment_distance(texcoord,
							start, end - vec2(linewidth,0.0));
						d = min(min(d1,d2), d3);
					}
					return d;
				}

				float arrow_angle_30(vec2 texcoord,
					float body_, float head,
					float linewidth, float antialias)
				{
					return arrow_angle(texcoord, body_, head,
						0.25, linewidth, antialias);
				}
				
				void main()
				{
					vec2 rotation = vVelocity.xy/length(vVelocity.xy);

					vec2 p = gl_PointCoord.xy - vec2(0.5,0.5);
					p = vec2(rotation.x*p.x - rotation.y*p.y,
						rotation.y*p.x + rotation.x*p.y);
					float distance = arrow_angle_30(p*v_size, size, size/2, linewidth, antialias);
					vec4 color;
					if (current_source == source && current_number == number &&
					    current_timestamp_hi == timestamp_hi &&
					    current_timestamp_lo == timestamp_lo)
						color = vec4(1, 0, 0, 1);
					else
						color = vColor;
					color_out = filled(distance, linewidth, antialias, color);
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
		_program.uniform("size").set(20.0f);
		_program.uniform("linewidth").set(2.0f);
		_program.uniform("antialias").set(1.0f);
		_program.uniform("source").set(10u/*_highlighted.source*/);
		_program.uniform("number").set(10u/*_highlighted.number*/);
		_program.uniform("timestamp_hi").set(0u);//_highlighted.timestamp_hi);
		_program.uniform("timestamp_lo").set(1u);//_highlighted.timestamp_lo);

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
