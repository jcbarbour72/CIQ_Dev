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
	    
        // Useful for maths
	    var width = dc.getWidth();
	    var height = dc.getHeight();
    	
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
    
	    // Useful for maths
	    var width = dc.getWidth();
	    var height = dc.getHeight();
    
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
        dc.fillCircle(width*0.5, height*0.4, width*0.25);

		// Block out the bottom half of sun
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, height*0.5, width, height*0.166);

        // Draw the black lines through the sun to make it...synthish
        dc.drawLine(0, height*0.35, width, height*0.35);
        dc.drawLine(0, height*0.40, width, height*0.40);
        dc.drawLine(0, height*0.442, width, height*0.442);
        dc.drawLine(0, height*0.475, width, height*0.475);

        drawGrid(dc);

		// Draw the custom font outline
        dc.setColor(0x00FFFF, Graphics.COLOR_TRANSPARENT);
        dc.drawText((width*0.5) , height*0.475, customFontOutline, timeString, Graphics.TEXT_JUSTIFY_CENTER);
				
		
		// Draw the custom font
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText((width*0.5) , height*0.475, customFont, timeString, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawBitmap((width*0.122) - (stepsIcon.getWidth()*0.5), (width*0.425 - stepsIcon.getHeight()), stepsIcon);
		dc.drawText(((width*0.122)) , height*0.433, dataFont, steps, Graphics.TEXT_JUSTIFY_CENTER);
		dc.drawText(((width*0.877)) , height*0.425- Graphics.getFontHeight(dataFont), dataFont, date.month + "\n " + date.day, Graphics.TEXT_JUSTIFY_CENTER);
		//dc.drawText(((width*0.122)) , height*0.433, dataFontOutline, steps, Graphics.TEXT_JUSTIFY_CENTER);
		//dc.drawText(((width*0.877)) , height*0.433 , dataFontOutline, date.month + " " + date.day, Graphics.TEXT_JUSTIFY_CENTER);

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
     // Useful for maths
	    var width = dc.getWidth();
	    var height = dc.getHeight();
	    
        // Set gridFactor
        gridFactor = 32;

        // Set the color and penwidth
        dc.setColor(Graphics.COLOR_PINK, Graphics.COLOR_PINK);
        dc.setPenWidth(2);
        
        // Horizonatal Line Block  
        dc.drawLine(0, height*0.5, width, height*0.5);
        dc.drawLine(0, (height*0.5 + height/gridFactor), width, (height*0.5 + height/gridFactor));

        gridFactor = gridFactor/2.2;
        dc.drawLine(0, (height*0.5 + height/gridFactor), width, (height*0.5 + height/gridFactor));

        gridFactor = gridFactor/1.8;
        dc.drawLine(0, (height*0.5 + height/gridFactor), width, (height*0.5 + height/gridFactor));

        gridFactor = gridFactor/1.8;
        dc.drawLine(0, (height*0.5 + height/gridFactor), width, (height*0.5 + height/gridFactor));

        gridFactor = gridFactor/1.8;
        dc.drawLine(0, (height*0.5 + height/gridFactor), width, (height*0.5 + height/gridFactor));

        // Vertical line block
        dc.drawLine(width*0.475, height*0.5, width*0.166, height);
        dc.drawLine(width*0.525, height*0.5, width*0.833, height);
        dc.drawLine(width*0.333, height*0.5, 0, width*0.75);
        dc.drawLine(width-(width*0.333), height*0.5, width, width*0.75);
        dc.drawLine((width*0.166), height*0.5, 0, height*0.583);
        dc.drawLine(width-(width*0.166), height*0.5, width, height*0.583);
        

    }

}
