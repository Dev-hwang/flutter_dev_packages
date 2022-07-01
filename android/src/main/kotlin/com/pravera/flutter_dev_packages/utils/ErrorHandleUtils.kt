package com.pravera.flutter_dev_packages.utils

import com.pravera.flutter_dev_packages.errors.PluginErrorCodes
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class ErrorHandleUtils {
  companion object {
    fun handleMethodCallError(result: MethodChannel.Result, errorCode: PluginErrorCodes) {
      result.error(errorCode.toString(), errorCode.message(), null)
    }

    fun handleStreamError(events: EventChannel.EventSink, errorCode: PluginErrorCodes) {
      events.error(errorCode.toString(), errorCode.message(), null)
    }
  }
}
