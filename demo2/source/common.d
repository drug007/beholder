module common;

interface Renderer
{
	void onRender();
}

interface Simulator
{
	import std.datetime : SysTime;

	void onSimulation(SysTime);
	void startSimulation(SysTime);
	void stopSimulation();
}

interface Parent
{
	void addRenderer(Renderer);
	void addSimulator(Simulator);
	void startSimulation();
	void stopSimulation();
}
