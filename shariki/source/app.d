import std;

import gfm.math;

import dataloader;
import application;
import sharikirenderer : Vertex;

int main(string[] args)
{
	if (args.length != 2)
	{
		writeln("Usage:");
		writeln("\t", baseName(thisExePath), " `filename`");
		return 1;
	}
	alias Types = AliasSeq!(double, double, double, float, int);
	enum format = "x: %f y: %f z: %f radius: %f kind: %d";
	DataLoader!Types dl;
	if (auto rc = dl.load(args[1], format))
		return rc;

	auto app = new Application("Shariki", 1024, 768);
	app.setData(dl.data.map!(a=>Vertex(vec3f(a[0], a[1], a[2]), a[3], a[4])));
	app.run;
	app.destroy;

	return 0;
}
