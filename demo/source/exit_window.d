module exit_window;

import nanogui;

class ExitWindow : Window
{
    public Button btnYes, btnNo;

    this(Widget parent) @trusted
    {
        super(parent, "Question");

        auto colWidth  = [6,  0, 70, 0, 6]; // columns width
		auto rowHeight = [6, 30,  5, 0, 6]; // rows height
	
		auto advLayout = new AdvancedGridLayout(colWidth, rowHeight);

		btnYes = new Button(this, "Yes");
		btnNo = new Button(this, "No");

		auto content = new Label(this, "Are you really want to exit?");
		advLayout.setAnchor(content, AdvancedGridLayout.Anchor(1, 1, 3, 1, Alignment.Middle, Alignment.Middle));
		advLayout.setAnchor(btnYes,  AdvancedGridLayout.Anchor(1, 3, 1, 1));
		advLayout.setAnchor(btnNo,   AdvancedGridLayout.Anchor(3, 3, 1, 1));

        layout = advLayout;

		visible = false;
    }
}