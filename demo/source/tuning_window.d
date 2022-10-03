module tuning_window;

import nanogui;

class TuningWindow : Window
{
    public FloatBox!float attenuationFactor;
    public CheckBox trails;

    this(Widget parent) @trusted
    {
        super(parent, "Settings");
		
		layout = new BoxLayout(Orientation.Horizontal);
        attenuationFactor = new FloatBox!float(this, 1.0);
		attenuationFactor.minMaxValues(0, 100000);
		attenuationFactor.spinnable = true;
		attenuationFactor.alignment = TextBox.Alignment.Right;
		attenuationFactor.editable = true;
		attenuationFactor.numberFormat = "%.5f";

        trails = new CheckBox(this, "Trails", null);

        new Label(this, " _ ");
    }
}