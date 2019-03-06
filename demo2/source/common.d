module common;

interface Renderer
{
	void onRender();
}

interface Simulator
{
	import std.datetime : SysTime;
	import gfm.math : ray3f;

	void onSimulation(SysTime new_timestamp, ray3f ray);

	SysTime finishTimestamp();
}
