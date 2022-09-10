package com.readyremit_reactnative_demo

import android.util.Log
import com.brightwell.readyremit.sdk.*
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import kotlinx.coroutines.runBlocking

class ReadyRemitModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    private val REQUEST_CODE = 10
    private val READYREMIT_AUTH_TOKEN_REQUESTED = "READYREMIT_AUTH_TOKEN_REQUESTED"
    private val READYREMIT_TRANSFER_SUBMITTED = "READYREMIT_TRANSFER_SUBMITTED"
    private lateinit var _onAuthCallback: ReadyRemitAuthCallback
    private lateinit var _onTransferCallback: ReadyRemitTransferCallback

    override fun getName(): String {
        return "ReadyRemitModule"
    }

    @ReactMethod
    fun launch(language: String = "en") {
        ReadyRemit.initialize(
            ReadyRemit.Config.Builder(currentActivity!!.application)
                .useEnvironment(Environment.DEVELOPMENT)
                .useAuthProvider { callback -> requestReadyRemitAccessToken(callback) }
                .useTransferSubmitProvider  { request, callback -> submitReadyRemitTransfer(request, callback) }
                .useDefaultTheme(R.style.Base_Theme_ReadyRemit_Light)
                .useLanguage(language)
                .build()
        )

        ReadyRemit.remitFrom(currentActivity!!, REQUEST_CODE)
    }

    @ReactMethod
    fun setAuthToken(token: String, errorAuthCode: String?) {
        if (token != "") {
            _onAuthCallback.onAuthSucceeded(ReadyRemitAuth(token, ""))
        } else {
            _onAuthCallback.onAuthFailed()
        }
    }

    private fun requestReadyRemitAccessToken(callback: ReadyRemitAuthCallback) {
        runBlocking {
            _onAuthCallback = callback

            reactApplicationContext
                .getJSModule(RCTDeviceEventEmitter::class.java)
                .emit(READYREMIT_AUTH_TOKEN_REQUESTED, null)
        }
    }

    @ReactMethod
    fun setTransferId(transferId: String = "", errorCode: String? = "") {
        if (transferId != "") {
            _onTransferCallback.onTransferSucceeded(transferId)
        } else if (errorCode != null) {
            _onTransferCallback.onTransferFailed(errorCode)
        }
    }

    private suspend fun submitReadyRemitTransfer(
        request: ReadyRemitTransferRequest,
        callback: ReadyRemitTransferCallback
    ) {
        runBlocking {
            _onTransferCallback = callback

            reactApplicationContext
                .getJSModule(RCTDeviceEventEmitter::class.java)
                .emit(READYREMIT_TRANSFER_SUBMITTED, request.toString())
        }
    }
}