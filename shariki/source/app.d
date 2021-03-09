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
	app.setData(dl.data.map!((a) {
		vec4f clr = void;
		switch (a[4])
		{
			case 0 : clr = vec4f(0.0, 1.0, 0.0, 1.0); break;
			case 1 : clr = vec4f(1.0, 1.0, 0.0, 1.0); break;
			case 2 : clr = vec4f(0.0, 1.0, 1.0, 1.0); break;
			case 3 : clr = vec4f(0.5, 0.5, 0.0, 1.0); break;
			case 4 : clr = vec4f(0.5, 1.0, 0.0, 1.0); break;
			case 5 : clr = vec4f(0.5, 0.7, 0.5, 1.0); break;
			case 6 : clr = vec4f(0.0, 1.0, 0.7, 1.0); break;
			case 7 : clr = vec4f(0.5, 0.0, 0.7, 1.0); break;
			case 8 : clr = vec4f(0.7, 0.2, 0.4, 1.0); break;
			case 9 : clr = vec4f(0.5, 1.3, 0.8, 1.0); break;
			default: clr = vec4f(1.0, 1.0, 1.0, 1.0);
		}
		return Vertex(vec3f(a[0], a[1], a[2]), clr, a[3]);
	}));
	app.run;
	scope(exit) app.destroy;

	return 0;
}
