// Copyright (c) 2019 David Stump <david@davidstump.net>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

/// Creates a timer that can perform calculated reties by setting
/// `timerCalculation` , such as exponential backoff.
///
/// ### Example
///
///     let reconnectTimer = TimeoutTimer()
///
///     // Receive a callbcak when the timer is fired
///     reconnectTimer.callback.delegate(to: self) { (_) in
///         print("timer was fired")
///     }
///
///     // Provide timer interval calculation
///     reconnectTimer.timerCalculation.delegate(to: self) { (_, tries) -> TimeInterval in
///         return tries > 2 ? 1000 : [1000, 5000, 10000][tries - 1]
///     }
///
///     reconnectTimer.scheduleTimeout() // fires after 1000ms
///     reconnectTimer.scheduleTimeout() // fires after 5000ms
///     reconnectTimer.reset()
///     reconnectTimer.scheduleTimeout() // fires after 1000ms
class TimeoutTimer {
    
    /// Callback to be informed when the underlying Timer fires
    var callback = Delegated<(), Void>()
    
    /// Provides TimeInterval to use when scheduling the timer
    var timerCalculation = Delegated<Int, TimeInterval>()
    
    /// The work to be done when the queue fires
    var workItem: DispatchWorkItem? = nil
    
    /// The number of times the underlyingTimer hass been set off.
    var tries: Int = 0
    
    
    /// Resets the Timer, clearing the number of tries and stops
    /// any scheduled timeout.
    func reset() {
        self.tries = 0
        self.clearTimer()
    }
    
    
    /// Schedules a timeout callback to fire after a calculated timeout duration.
    func scheduleTimeout() {
        // Clear any ongoing timer, not resetting the number of tries
        self.clearTimer()
        
        // Get the next calculated interval, in milliseconds. Do not
        // start the timer if the interval is returned as nil.
        guard let timeInterval
            = self.timerCalculation.call(self.tries + 1) else { return }
        
        // TimeInterval is always in seconds. Multiply it by 1000 to convert
        // to milliseconds and round to the nearest millisecond.
        let dispatchInterval = Int(round(timeInterval * 1000))
        
        let dispatchTime = DispatchTime.now() + .milliseconds(dispatchInterval)
        let workItem = DispatchWorkItem {
            self.tries += 1
            self.callback.call()
        }
        
        self.workItem = workItem
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: workItem)
    }
    
    /// Invalidates any ongoing Timer. Will not clear how many tries have been made
    private func clearTimer() {
        self.workItem?.cancel()
        self.workItem = nil
    }
}
