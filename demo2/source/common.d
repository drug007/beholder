module common;

interface Renderer
{
	void onRender();
}

interface Simulator
{
	import std.datetime : SysTime;

	void onSimulation(SysTime new_timestamp);
}

interface Parent
{
	void addRenderer(Renderer);
	void addSimulator(Simulator);
	void startSimulation();
	void stopSimulation();
}
