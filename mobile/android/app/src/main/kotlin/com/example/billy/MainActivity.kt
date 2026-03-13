package com.example.billy

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.IntentFilter
import android.provider.Telephony

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.billy/sms"
    private var methodChannel: MethodChannel? = null
    private val smsReceiver = SmsReceiver()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        
        // Set up callback to send SMS to Flutter
        SmsReceiver.onSmsReceived = { sender, message ->
            methodChannel?.invokeMethod("onSmsReceived", mapOf(
                "sender" to sender,
                "message" to message,
                "timestamp" to System.currentTimeMillis()
            ))
        }
        
        // Register SMS receiver
        val intentFilter = IntentFilter(Telephony.Sms.Intents.SMS_RECEIVED_ACTION)
        registerReceiver(smsReceiver, intentFilter)
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            unregisterReceiver(smsReceiver)
        } catch (e: Exception) {
            // Receiver not registered
        }
    }
}
