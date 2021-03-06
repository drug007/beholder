module dataloader;

import std;

struct DataLoader(Types...)
{
	private Tuple!Types[] _data;

	int load(string filename, string format)
	{
		try
		{
			_data = slurp!Types(filename, format);
		}
		catch(Exception e)
		{
			_data.length = 0;
			writeln("Error occured: ", e.msg);

			return 1;
		}

		return 0;
	}

	auto data()
	{
		return _data;
	}
}