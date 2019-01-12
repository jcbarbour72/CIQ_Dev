using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;

class VaporWaveView extends WatchUi.WatchFace {

    var gridFactor;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
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
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        
        // Update the view
        var view = View.findDrawableById("TimeLabel");
        view.setColor(Graphics.COLOR_PINK);
        view.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_ORANGE,Graphics.COLOR_ORANGE);
        dc.fillCircle(dc.getWidth()/2, dc.getHeight()/2.5, dc.getWidth()/4);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, dc.getHeight()/2, dc.getWidth(), 40);

        
        dc.drawLine(0, 84, dc.getWidth(), 84);
        dc.drawLine(0, 96, dc.getWidth(), 96);
        dc.drawLine(0, 106, dc.getWidth(), 106);
        dc.drawLine(0, 114, dc.getWidth(), 114);

        drawGrid(dc);


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

    // Draw the grid
    function drawGrid(dc) {
        // Set gridFactor
        gridFactor = 32;

        // Set the color
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
