module situation;

import std.datetime;

struct Point
{
	float x, y;
	SysTime timestamp;
	bool gui_visible;
	string text;
}

struct Track
{
	int id;
	bool gui_state;
	bool gui_visible;
	string text;
	Point[] point;
}

struct Source
{
	int id;
	bool gui_state;
	string text;
	Track[] track;
}

struct Situation
{
	Source[] source;
}

auto makeTestSituation()
{
	Situation sit;
	float x0 = -10_000;
	float y0 = -10_000;
	SysTime t0 = SysTime.fromISOExtString("0001-01-01T00:00:10Z");
	foreach(sid; 0..3)
	{
		Source src;
		src.id = sid;
		foreach(x; 0..10)
		{
			Track trk;
			trk.id = x;
			trk.gui_visible = true;
			foreach(y; 0..30)
			{
				trk.point ~= Point(x0 + x*10_000, y0 + y * 1000, t0 + y*10.seconds, true);
			}
			src.track ~= trk;
		}
		sit.source ~= src;
	}

	return sit;
}