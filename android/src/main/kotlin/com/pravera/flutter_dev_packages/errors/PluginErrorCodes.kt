package com.pravera.flutter_dev_packages.errors

enum class PluginErrorCodes {
  ACTIVITY_NOT_ATTACHED,
  UNKNOWN_ERROR;

  fun message(): String {
    return when (this) {
      ACTIVITY_NOT_ATTACHED -> "Cannot call method using Activity because Activity is not attached to FlutterEngine."
      UNKNOWN_ERROR -> "An unknown error has occurred."
    }
  }
}
