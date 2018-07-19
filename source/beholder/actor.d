module beholder.actor;

class Actor(R, I)
{
    this(R data, I indices)
    {
        this.data    = data;
        this.indices = indices;
    }

    R data;
    I indices;
}

auto makeActor(R, I)(R data, I indices)
{
    return new Actor!(R, I)(data, indices);
}