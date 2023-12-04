import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class OTPTimerPlugin(private val registrar: Registrar) : MethodChannel.MethodCallHandler {
    private val timerHandler = TimerHandler()

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "otp_timer_plugin")
            channel.setMethodCallHandler(OTPTimerPlugin(registrar))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "startTimer" -> {
                val duration = call.argument<Int>("duration")
                timerHandler.startTimer(duration ?: 0) {
                    // Notify Flutter about timer tick
                    val map = mapOf("event" to "tick")
                    registrar.activity().runOnUiThread {
                        // Send the event to Flutter
                        result.success(map)
                    }
                }
            }
            "stopTimer" -> {
                timerHandler.stopTimer()
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
