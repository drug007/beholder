module common;

interface Renderer
{
	void onRender();
}

interface Simulator
{
	import std.datetime : SysTime;

	void onSimulation(const SysTime);
}

interface Parent
{
	void addRenderer(Renderer);
	void addSimulator(Simulator);
}
