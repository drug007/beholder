import asdf;
import beholder : Beholder, PointC2f, Target;

import std.concurrency;

alias DataChunk = shared(const(PointC2f))[];

int main(string[] args) @safe
{
	import std.datetime : msecs;
	import std.file : exists;

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

	scope beholder = new Beholder(1000, 800, "Demo");

	() @trusted {
		spawn(&loadData, thisTid, filename);

		beholder.onBeforeLoopStart = () @trusted {
			receiveTimeout(0.msecs, (DataChunk p) {
				beholder.addData(cast(PointC2f[]) p);
			});
		};
	} ();

	beholder.run();

	return 0;
}

void loadData(Tid ownerTid, string filename)
{
	import std.algorithm : max;
	import std.concurrency : send;
	import std.datetime : msecs;
	import std.file : readText;
	import std.stdio : writefln;

	import core.thread : Thread;

	auto txt = readText(filename);
	auto json = txt.parseJson;
	auto data = cast(DataChunk) jsonToData(json);

	const total = 10;
	const step = max(data.length / total, 1);
	size_t i = step;
	for(; i < data.length; i += step)
	{
		writefln("sent %s..%s", i-step, i);
		send(ownerTid, data[i - step..i]);
		Thread.sleep(1000.msecs);
	}
	writefln("sent %s..%s", i-step, data.length);
	send(ownerTid, data[i-step..$]);
}

auto jsonToData(ref Asdf json) @trusted
{

	Target[] targets;
	foreach(record; json.byElement)
	{
		auto kj = record["kind"];
		if (kj == Asdf.init)
			continue;

		const kind = cast(string) kj;
		switch (kind)
		{
			case "Target":
				targets ~= Target.fromAsdf(record);
			break;
			default:
		}
	}
	return targets;
}