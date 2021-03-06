module application;

import gfm.math;

import beholder.camera;
import beholder.nuklearapp;

class Application : NuklearApp
{
	import common;
	import sharikirenderer;

	private Renderer[] _renderers;
	private Camera _camera;
	private SharikiRenderer _sharikirenderer;

	this(string title, int w, int h)
	{
		super(title, w, h, NuklearApp.FullScreen.no);
		_camera = new Camera(vec2f(-5000, 5000), vec3f(0, 0, 0), 5000);
		_sharikirenderer = new SharikiRenderer(_camera);
		_renderers ~= _sharikirenderer;
	}

	override void destroy()
	{
		if (_sharikirenderer)
		{
			.destroy(_sharikirenderer);
			_sharikirenderer = null;
		}
		super.destroy();
	}

	void setData(R)(R data)
	{
		import std.range;
		_sharikirenderer.update(data, (cast(uint)data.length).iota);
	}

	override void onIdle()
	{
		draw();
	}

	void draw()
	{
		{
			import gfm.opengl;

			glViewport(0, 0, _width, _height);
			glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
			glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

			foreach(r; _renderers)
				r.onRender();
		}
	}
}