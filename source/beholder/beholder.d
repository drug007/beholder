module beholder.beholder;

import nanogui.sdlbackend : SdlBackend;

import beholder.common;

private class Window : SdlBackend
{
	this(int w, int h, string title)
	{
		super(w, h, title);
	}

	override void onVisibleForTheFirstTime()
	{
    }
}

struct Beholder
{
@safe:

    @disable this();

	this(int w, int h, string title) @trusted
	{
        _window = new Window(w, h, title);
    }

    ~this() @trusted
    {
        destroy(_window);
    }

    void addData(PointC2f[] data)
    {

    }

    void run() @trusted
    {
        _window.run();
    }

private:
    SdlBackend _window;
}