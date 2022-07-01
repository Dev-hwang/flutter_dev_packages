package com.pravera.flutter_dev_packages

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.pravera.flutter_dev_packages.errors.PluginErrorCodes
import com.pravera.flutter_dev_packages.utils.ErrorHandleUtils
import com.pravera.flutter_dev_packages.utils.PermissionUtils
import com.pravera.flutter_dev_packages.utils.SystemUtils
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

const val OVERLAYS_REQ_CODE = 1000
const val LOCATION_SERVICE_SETTINGS_REQ_CODE = 1001

class MethodCallHandlerImpl(private val context: Context): MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener {
  private lateinit var permissionMethodChannel: MethodChannel
  private lateinit var systemMethodChannel: MethodChannel

  private var methodCallResult1: MethodChannel.Result? = null
  private var methodCallResult2: MethodChannel.Result? = null
  private var activity: Activity? = null

  fun init(messenger: BinaryMessenger) {
    permissionMethodChannel = MethodChannel(messenger, "flutter_dev_packages/permission")
    permissionMethodChannel.setMethodCallHandler(this)

    systemMethodChannel = MethodChannel(messenger, "flutter_dev_packages/system")
    systemMethodChannel.setMethodCallHandler(this)
  }

  fun setActivity(activity: Activity?) {
    this.activity = activity
  }

  fun dispose() {
    if (::permissionMethodChannel.isInitialized) {
      permissionMethodChannel.setMethodCallHandler(null)
    }

    if (::systemMethodChannel.isInitialized) {
      systemMethodChannel.setMethodCallHandler(null)
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    val reqMethod = call.method
    if (reqMethod.equals("minimize") ||
      reqMethod.equals("killProcess") ||
      reqMethod.equals("requestOverlays") ||
      reqMethod.equals("openLocationServiceSettings")) {
      if (activity == null) {
        ErrorHandleUtils.handleMethodCallError(result, PluginErrorCodes.ACTIVITY_NOT_ATTACHED)
        return
      }
    }

    when (reqMethod) {
      "minimize" -> SystemUtils.minimize(activity!!)
      "killProcess" -> SystemUtils.killProcess(activity!!)
      "wakeLockScreen" -> SystemUtils.wakeLockScreen(context)
      "canDrawOverlays" -> result.success(PermissionUtils.canDrawOverlays(context))
      "requestOverlays" -> {
        methodCallResult1 = result
        PermissionUtils.requestOverlays(activity!!, OVERLAYS_REQ_CODE)
      }
      "isLocationServiceEnabled" ->
        result.success(PermissionUtils.isLocationServiceEnabled(context))
      "openLocationServiceSettings" -> {
        methodCallResult2 = result
        PermissionUtils.openLocationServiceSettings(activity!!, LOCATION_SERVICE_SETTINGS_REQ_CODE)
      }
      else -> result.notImplemented()
    }
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    when (requestCode) {
      OVERLAYS_REQ_CODE -> {
        val canDrawOverlays = PermissionUtils.canDrawOverlays(context)
        methodCallResult1?.success(canDrawOverlays)
      }
      LOCATION_SERVICE_SETTINGS_REQ_CODE -> {
        val isLocationServiceEnabled = PermissionUtils.isLocationServiceEnabled(context)
        methodCallResult2?.success(isLocationServiceEnabled)
      }
    }

    return resultCode == Activity.RESULT_OK
  }
}
