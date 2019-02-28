module common;

interface Renderer
{
	void onRender();
}

interface Simulator
{
	import std.datetime : SysTime;

	void onSimulation(SysTime new_timestamp);

	SysTime finishTimestamp();
}

interface Parent
{
	void addRenderer(Renderer);
	void startSimulation();
	void stopSimulation();
}
