using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Math;

class binarywatchView extends WatchUi.WatchFace {

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

    function drawBatteryText(text, color, dc) {
        dc.setColor(color, Graphics.COLOR_BLACK);
        dc.drawText(dc.getWidth() / 2, 170, Graphics.FONT_MEDIUM, text, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Update the view
    function onUpdate(dc) {
        // Calculate where to put things
        var w = dc.getWidth(); // Forerunner 45 screen width
        var mid = w / 2;
        var voffset = 25; // Each line's vertical offset from centre
        var width = 165; // Width of row of dots (from centre of endmost circles)
        var right = width / 2 + mid; // x coord of rightmost circle
        var circleSize = 15;
        
        // Get time
        var clockTime = System.getClockTime();
        var hr = clockTime.hour;
        // I want a 12 hour clock, but with midnight=0 and midday=12. Deal with it.
        if (hr > 12) {
            hr -= 12;
        }
        var mins = clockTime.min;
        
        // Work around bug only on device (not simulator) where drawCircle'd circles appear but
        // fillCircle's ones don't.
        // Setting color both before and after clearing the screen fixes it.
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

        // Draw circles for hours
        for (var i = 0; i < 4; i++) {
            var x = right - (width / 3) * i;
            var y = mid - voffset;
            if (hr & Math.pow(2, i).toNumber()) {
                dc.fillCircle(x, y, circleSize);
            }
            else {
                dc.drawCircle(x, y, circleSize);
            }
        }
        
        // Draw circles for minutes
        for (var i = 0; i < 6; i++) {
            var x = right - (width / 5) * i;
            var y = mid + voffset;
            if (mins & Math.pow(2, i).toNumber()) {
                dc.fillCircle(x, y, circleSize);
            }
            else {
                dc.drawCircle(x, y, circleSize);
            }
        }

        // Show battery indicator
        var batt = System.getSystemStats().battery;
        if (batt > 50) {
            drawBatteryText("go go", Graphics.COLOR_GREEN, dc);
        }
        else if (batt > 20) {
            drawBatteryText("so so", Graphics.COLOR_YELLOW, dc);
        }
        else {
            drawBatteryText("oh no", Graphics.COLOR_RED, dc);
        }

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

}
