import android.os.Handler
import android.os.Looper

class TimerHandler {
    private val handler = Handler(Looper.getMainLooper())
    private var timerRunnable: Runnable? = null

    fun startTimer(duration: Int, onTimerTick: () -> Unit) {
        timerRunnable = object : Runnable {
            override fun run() {
                onTimerTick()
                duration--
                if (duration <= 0) {
                    stopTimer()
                } else {
                    handler.postDelayed(this, 1000) // Run every second
                }
            }
        }
        handler.post(timerRunnable!!)
    }

    fun stopTimer() {
        timerRunnable?.let {
            handler.removeCallbacks(it)
            timerRunnable = null
        }
    }
}
