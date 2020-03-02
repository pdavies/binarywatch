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

    // Update the view
    function onUpdate(dc) {
        // Learn about screen resolution
        var screenw = dc.getWidth(); var screenh = dc.getHeight();
        var xmid = screenw / 2; var ymid = screenh / 2;

        // Calculate where to put clock circles
        var voffset = screenw / 8; // Each line's vertical offset from centre
        var dotswidth = screenw * 0.8; // Width of row of dots (from centre of endmost circles)
        var right = dotswidth / 2 + xmid; // x coord of rightmost circle
        var circleSize = screenw * 0.072;
        
        // Work around bug only on device (not simulator) where drawCircle'd circles appear but
        // fillCircle's ones don't.
        // Setting color both before and after clearing the screen fixes it.
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

        // Get time
        var clockTime = System.getClockTime();
        var settings = System.getDeviceSettings();
        var is24 = settings.is24Hour;
        var hr = clockTime.hour;
        if (!is24) {
            if (hr >= 12) {
                hr -= 12;
            }
            if (hr == 0) {
                hr = 12;
            }
        }
        var mins = clockTime.min;
        
        // Draw circles for hours
        var hoursCircles = is24 ? 5 : 4;
        for (var i = 0; i < hoursCircles; i++) {
            var x = right - (dotswidth / (hoursCircles - 1)) * i;
            var y = ymid - voffset;
            if (hr & Math.pow(2, i).toNumber()) {
                dc.fillCircle(x, y, circleSize);
            }
            else {
                dc.drawCircle(x, y, circleSize);
            }
        }

        // Draw circles for minutes
        for (var i = 0; i < 6; i++) {
            var x = right - (dotswidth / 5) * i;
            var y = ymid + voffset;
            if (mins & Math.pow(2, i).toNumber()) {
                dc.fillCircle(x, y, circleSize);
            }
            else {
                dc.drawCircle(x, y, circleSize);
            }
        }

        if (settings.notificationCount > -1) {
            dc.drawText(xmid, screenh * 0.10, Graphics.FONT_MEDIUM, "!", Graphics.TEXT_JUSTIFY_CENTER);
        }

        // Show battery indicator
        var batt = System.getSystemStats().battery;
        if (batt <= 20) {
            var hsize = 20; // Battery body width
            var vsize = 10; // Battery body height
            var ytop = screenh * 0.8; // y coord of top of battery
            var xleft = xmid - hsize / 2; // x coord of left of battery

            // Battery outline
            dc.drawRectangle(xleft, ytop, hsize, vsize);

            // Battery pointy bit
            dc.fillRectangle(xmid + hsize / 2, ytop + 2, 2, vsize - 4);

            // Battery fill
            if (batt <= 10) {
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            }
            else {
                dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
            }
            dc.fillRectangle(xleft + 2, ytop + 2, hsize - 4, vsize - 4);
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
