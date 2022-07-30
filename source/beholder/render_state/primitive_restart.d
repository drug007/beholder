module beholder.render_state.primitive_restart;

struct PrimitiveRestart
{
    bool enabled = false;
    uint index   = uint.max;
}