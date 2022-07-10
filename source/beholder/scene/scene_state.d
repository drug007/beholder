module beholder.scene.scene_state;

import beholder.scene.camera;

class SceneState
{
    Camera camera;

    @disable this();

    this(int w, int h)
    {
        camera = new Camera(w, h);
    }
}