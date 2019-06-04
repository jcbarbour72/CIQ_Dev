using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;

class VaporWaveView extends WatchUi.WatchFace {

	// The custom Font
	var customFont = null;
	// The custom Font outline
	var customFontOutline = null;
	// The custom data font outline
	var dataFontOutline = null;
	// The custom data font outline
	var dataFont = null;
	// The factor for the grid draw
    var gridFactor;
    // Step goal
    var steps;
    var stepsGoal;
    var thisActivity;
    
    // Step icon
    var stepsIcon;
    

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    	// Load custom font resources
    	customFont = WatchUi.loadResource(Rez.Fonts.customFont);
        customFontOutline = WatchUi.loadResource(Rez.Fonts.customFontOutline);
        dataFontOutline = WatchUi.loadResource(Rez.Fonts.dataFontOutline);
		dataFont = WatchUi.loadResource(Rez.Fonts.dataFont);
        stepsIcon = WatchUi.loadResource(Rez.Drawables.StepsIcon);        
        setLayout(Rez.Layouts.WatchFace(dc));
        
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var date = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        thisActivity = ActivityMonitor.getInfo();
        steps = thisActivity.steps;
        stepsGoal = thisActivity.stepGoal;
        
        // Get time settings 12 or 24hour
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        
        // Set the time string
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

		// Draw sun
        dc.setColor(Graphics.COLOR_ORANGE,Graphics.COLOR_ORANGE);
        dc.fillCircle(dc.getWidth()/2, dc.getHeight()/2.5, dc.getWidth()/4);

		// Block out the bottom half of sun
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, dc.getHeight()/2, dc.getWidth(), 40);

        // Draw the black lines through the sun to make it...synthish
        dc.drawLine(0, 84, dc.getWidth(), 84);
        dc.drawLine(0, 96, dc.getWidth(), 96);
        dc.drawLine(0, 106, dc.getWidth(), 106);
        dc.drawLine(0, 114, dc.getWidth(), 114);

        drawGrid(dc);

		// Draw the custom font outline
        dc.setColor(0x00FFFF, Graphics.COLOR_TRANSPARENT);
        dc.drawText((dc.getWidth()/2) , 155, customFontOutline, timeString, Graphics.TEXT_JUSTIFY_CENTER);
				
		
		// Draw the custom font
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText((dc.getWidth()/2) , 155, customFont, timeString, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawBitmap((dc.getWidth()/8.15) - (stepsIcon.getWidth() / 2), (102 - stepsIcon.getHeight()), stepsIcon);
		dc.drawText(((dc.getWidth()/8.15)) , 104, dataFont, steps, Graphics.TEXT_JUSTIFY_CENTER);
		dc.drawText(((dc.getWidth()/1.14)) , 102 - Graphics.getFontHeight(dataFont), dataFont, date.month + "\n " + date.day, Graphics.TEXT_JUSTIFY_CENTER);
		//dc.drawText(((dc.getWidth()/8.15)) , 104, dataFontOutline, steps, Graphics.TEXT_JUSTIFY_CENTER);
		//dc.drawText(((dc.getWidth()/1.14)) , 104 , dataFontOutline, date.month + " " + date.day, Graphics.TEXT_JUSTIFY_CENTER);

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

    // Draw the grid...this is pretty nasty right now...
    function drawGrid(dc) {
        // Set gridFactor
        gridFactor = 32;

        // Set the color and penwidth
        dc.setColor(Graphics.COLOR_PINK, Graphics.COLOR_PINK);
        dc.setPenWidth(2);
        
        // Horizonatal Line Block  
        dc.drawLine(0, dc.getHeight()/2, dc.getWidth(), dc.getHeight()/2);
        dc.drawLine(0, (dc.getHeight()/2 + dc.getHeight()/gridFactor), dc.getWidth(), (dc.getHeight()/2 + dc.getHeight()/gridFactor));

        gridFactor = gridFactor/2.2;
        dc.drawLine(0, (dc.getHeight()/2 + dc.getHeight()/gridFactor), dc.getWidth(), (dc.getHeight()/2 + dc.getHeight()/gridFactor));

        gridFactor = gridFactor/1.8;
        dc.drawLine(0, (dc.getHeight()/2 + dc.getHeight()/gridFactor), dc.getWidth(), (dc.getHeight()/2 + dc.getHeight()/gridFactor));

        gridFactor = gridFactor/1.8;
        dc.drawLine(0, (dc.getHeight()/2 + dc.getHeight()/gridFactor), dc.getWidth(), (dc.getHeight()/2 + dc.getHeight()/gridFactor));

        gridFactor = gridFactor/1.8;
        dc.drawLine(0, (dc.getHeight()/2 + dc.getHeight()/gridFactor), dc.getWidth(), (dc.getHeight()/2 + dc.getHeight()/gridFactor));

        // Vertical line block
        dc.drawLine(114, dc.getHeight()/2, 40, dc.getHeight());
        dc.drawLine(126, dc.getHeight()/2, 200, dc.getHeight());
        dc.drawLine(80, dc.getHeight()/2, 0, 180);
        dc.drawLine(dc.getWidth()-80, dc.getHeight()/2, dc.getWidth(), 180);
        dc.drawLine(46, dc.getHeight()/2, 0, 140);
        dc.drawLine(dc.getWidth()-46, dc.getHeight()/2, dc.getWidth(), 140);
        

    }

}
