module beholder.common;

enum CoordSys { Cartesian, Polar, }

struct GenericPoint(CoordSys coordSys, int Dim, BaseType)
{
    static assert (is(BaseType == float) || is(BaseType == double));

    private BaseType[Dim] _value;

    BaseType x() { return _value[0]; }
    BaseType y() { return _value[1]; }

    void x(BaseType v) { _value[0] = v; }
    void y(BaseType v) { _value[1] = v; }

    static if (Dim == 2)
    {
        this(BaseType x, BaseType y)
        {
            this.x = x;
            this.y = y;
        }
    }
    else static if (Dim == 3)
    {
        this(BaseType x, BaseType y, BaseType z)
        {
            this(x, y);
            this.z = z;
        }

        BaseType z() { return _value[2]; }
        void z(BaseType v) { _value[2] = v; }
    }
    else
        static assert(0, "Only 2D or 3D is possible");
}

alias PointC2f = GenericPoint!(CoordSys.Cartesian, 2, float);