module common;

interface Renderer
{
	void onRender();
}

interface Simulator
{
	import std.datetime : Duration;

	void onSimulation(Duration delta);
}

interface Parent
{
	void addRenderer(Renderer);
	void addSimulator(Simulator);
	void startSimulation();
	void stopSimulation();
}
