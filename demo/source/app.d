import std : exists, readText;
import asdf;
import beholder : Beholder, PointC2f;

int main(string[] args) @safe
{
	if (args.length < 2)
	{
		import std : writefln, baseName;
		writefln("Usage:\n\t%s filename", baseName(args[0]));
		return 1;
	}

	const filename = args[1];
	if (!filename.exists)
	{
		import std : writeln;
		writeln("File ", filename, " does not exist");
		return 2;
	}

	auto txt = readText(filename);
	auto json = () @trusted { return txt.parseJson; } ();
	auto data = jsonToData(json);
	scope beholder = new Beholder(1000, 800, "Demo");
	beholder.addData(data);

	beholder.run();

	return 0;
}

auto jsonToData(ref Asdf json) @trusted
{
import std;
	PointC2f[] points;
	foreach(record; json.byElement)
	{
		auto kj = record["kind"];
		if (kj == Asdf.init)
			continue;

		const kind = cast(string) kj;
		switch (kind)
		{
			case "Point":
				auto xj = record["x"];
				if (xj == Asdf.init)
					continue;
				auto yj = record["y"];
				if (yj == Asdf.init)
					continue;
				const x = cast(float) xj;
				const y = cast(float) yj;
				points ~= PointC2f(x, y);
			break;
			default:
		}
	}
	return points;
}