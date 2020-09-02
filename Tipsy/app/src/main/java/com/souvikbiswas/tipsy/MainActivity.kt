package com.souvikbiswas.tipsy

import android.graphics.Color
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import kotlinx.android.synthetic.main.activity_main.*
import org.json.JSONObject

private const val FLUTTER_ENGINE_ID = "flutter_engine"
private const val CHANNEL = "com.souvikbiswas.tipsy/result"

class MainActivity : AppCompatActivity() {

    lateinit var flutterEngine: FlutterEngine

    // Defining views
    private lateinit var billTextField: TextView

    private lateinit var zeroPercentButton: Button
    private lateinit var tenPercentButton: Button
    private lateinit var twentyPercentButton: Button

    private lateinit var increaseButton: Button
    private lateinit var decreaseButton: Button

    private lateinit var countTextView: TextView

    private lateinit var calculateButton: Button

    private var count = 2
    private var fraction = 0.1
    private var finalBill = 0.0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        flutterEngine = FlutterEngine(this)

        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        FlutterEngineCache
            .getInstance()
            .put(FLUTTER_ENGINE_ID, flutterEngine)

        setContentView(R.layout.activity_main)

        addViewFunctionality()
    }

    private fun addViewFunctionality() {

        // Initializing views
        billTextField = bill_text_field

        zeroPercentButton = percent_0_button
        tenPercentButton = percent_10_button
        twentyPercentButton = percent_20_button

        increaseButton = plus_button
        decreaseButton = minus_button

        countTextView = split_count_text

        calculateButton = calculate_button

        increaseButton.setOnClickListener {
            count++
            countTextView.text = count.toString()
        }

        decreaseButton.setOnClickListener {
            if (count > 2) {
                count--
                countTextView.text = count.toString()
            }

        }

        // Adding functionality
        zeroPercentButton.setOnClickListener {
            fraction = 0.0
            zeroPercentButton.setBackgroundColor(
                ContextCompat.getColor(
                    this,
                    R.color.colorPrimaryDark
                )
            )
            zeroPercentButton.setTextColor(Color.WHITE)
            tenPercentButton.setBackgroundColor(Color.TRANSPARENT)
            tenPercentButton.setTextColor(ContextCompat.getColor(this, R.color.colorPrimaryDark))
            twentyPercentButton.setBackgroundColor(Color.TRANSPARENT)
            twentyPercentButton.setTextColor(ContextCompat.getColor(this, R.color.colorPrimaryDark))
        }

        tenPercentButton.setOnClickListener {
            fraction = 0.1
            tenPercentButton.setBackgroundColor(
                ContextCompat.getColor(
                    this,
                    R.color.colorPrimaryDark
                )
            )
            tenPercentButton.setTextColor(Color.WHITE)
            zeroPercentButton.setBackgroundColor(Color.TRANSPARENT)
            zeroPercentButton.setTextColor(ContextCompat.getColor(this, R.color.colorPrimaryDark))
            twentyPercentButton.setBackgroundColor(Color.TRANSPARENT)
            twentyPercentButton.setTextColor(ContextCompat.getColor(this, R.color.colorPrimaryDark))
        }

        twentyPercentButton.setOnClickListener {
            fraction = 0.2
            twentyPercentButton.setBackgroundColor(
                ContextCompat.getColor(
                    this,
                    R.color.colorPrimaryDark
                )
            )
            twentyPercentButton.setTextColor(Color.WHITE)
            tenPercentButton.setBackgroundColor(Color.TRANSPARENT)
            tenPercentButton.setTextColor(ContextCompat.getColor(this, R.color.colorPrimaryDark))
            zeroPercentButton.setBackgroundColor(Color.TRANSPARENT)
            zeroPercentButton.setTextColor(ContextCompat.getColor(this, R.color.colorPrimaryDark))
        }

        calculateButton.setOnClickListener {
            var billAmount = billTextField.text?.toString()?.toDoubleOrNull()
            if (billAmount == null) billAmount = 0.0

            val billSplit = billAmount.div(count)
            finalBill = billSplit + billSplit * fraction

            val finalBillString = String.format("%.2f", finalBill)

            println(finalBillString)

            val json = JSONObject()

            json.put("amount", finalBillString)
            json.put("count", count)
            json.put("percent", fraction * 100)

            println(json)

            val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

            methodChannel.invokeMethod("getCalculatedResult", json.toString())

            startActivity(
                FlutterActivity
                    .withCachedEngine(FLUTTER_ENGINE_ID)
                    .build(this)
            )
        }

    }

//    private fun getCalculatedResult(): JSONObject {
//        var billAmount = billTextField.text?.toString()?.toDoubleOrNull()
//        if (billAmount == null) billAmount = 0.0
//
//        val billSplit = billAmount.div(count)
//        finalBill = billSplit + billSplit * fraction
//
//        val finalBillString = String.format("%.2f", finalBill)
//
//        println(finalBillString)
//
//        val json = JSONObject()
//
//        json.put("amount", finalBillString)
//        json.put("count", count)
//        json.put("percent", fraction)
//
//        println(json)
//
//        var methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//
//        methodChannel.invokeMethod("getCalculatedResult", )
//
//        return json
//    }
}