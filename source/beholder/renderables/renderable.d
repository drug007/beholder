module beholder.renderables.renderable;

import beholder.context : Context;
import beholder.scene.scene_state : SceneState;

class Renderable
{
    abstract void render(Context ctx, ref SceneState sceneState);
}