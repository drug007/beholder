module beholder.render_state.color_mask;

struct ColorMask
{
    @disable this();

    this(bool red, bool green, bool blue, bool alpha)
    {
        _red = red;
        _green = green;
        _blue = blue;
        _alpha = alpha;
    }

    bool r() const { return _red;   }
    bool g() const { return _green; }
    bool b() const { return _blue;  }
    bool a() const { return _alpha; }

    // bool opEquals(ref const(ColorMask) other) const
    // {
    //     return 
    //         _red == other._red && 
    //         _green == other._green && 
    //         _blue == other._blue && 
    //         _alpha == other._alpha;
    // }

    // string ToString()
    // {
    //     return string.Format(CultureInfo.CurrentCulture, "(Red: {0}, Green: {1}, Blue: {2}, Alpha: {3})", 
    //         _red, _green, _blue, _alpha);
    // }

    // override int GetHashCode()
    // {
    //     return _red.GetHashCode() ^ _green.GetHashCode() ^ _blue.GetHashCode() ^ _alpha.GetHashCode();
    // }

    private bool _red;
    private bool _green;
    private bool _blue;
    private bool _alpha;
}
