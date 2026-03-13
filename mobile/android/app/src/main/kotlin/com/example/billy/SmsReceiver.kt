package com.example.billy

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import android.telephony.SmsMessage
import android.util.Log

class SmsReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "SmsReceiver"
        var onSmsReceived: ((String, String) -> Unit)? = null
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            val bundle = intent.extras
            if (bundle != null) {
                try {
                    val pdus = bundle.get("pdus") as Array<*>
                    val messages = arrayOfNulls<SmsMessage>(pdus.size)
                    
                    for (i in pdus.indices) {
                        messages[i] = SmsMessage.createFromPdu(pdus[i] as ByteArray)
                    }
                    
                    if (messages.isNotEmpty()) {
                        val sender = messages[0]?.originatingAddress ?: ""
                        val messageBody = StringBuilder()
                        
                        for (message in messages) {
                            messageBody.append(message?.messageBody)
                        }
                        
                        val fullMessage = messageBody.toString()
                        Log.d(TAG, "SMS received from: $sender")
                        Log.d(TAG, "Message: $fullMessage")
                        
                        // Send to Flutter via callback
                        onSmsReceived?.invoke(sender, fullMessage)
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error processing SMS: ${e.message}")
                }
            }
        }
    }
}
