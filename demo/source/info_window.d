module info_window;

import nanogui;

class InfoWindow : Window
{
    public Label windowX, windowY, xValue, yValue,
        camX, camY, scale;

    this(Widget parent) @trusted
    {
        super(parent, "");
        layout = new BoxLayout(Orientation.Horizontal);
        windowX = new Label(this, "1024");
        new Label(this, "x");
        windowY = new Label(this, "768");

        auto spacer = new Label(this, "");
        spacer.width = 30;
        new Label(this, "X:");
        xValue = new Label(this, "00000000");
        new Label(this, "Y:");
        yValue = new Label(this, "00000000");
        
        spacer = new Label(this, "camera");

        camX = new Label(this, "000000");
        camY = new Label(this, "000000");

        new Label(this, "scale");
        scale = new Label(this, "000000");
        scale.tooltip = "Размер экрана по ширине в метрах";
    }
}