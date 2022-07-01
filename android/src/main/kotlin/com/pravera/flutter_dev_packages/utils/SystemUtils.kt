package com.pravera.flutter_dev_packages.utils

import android.app.Activity
import android.content.Context
import android.os.Build
import android.os.PowerManager
import kotlin.system.exitProcess

class SystemUtils {
  companion object {
    fun minimize(activity: Activity) {
      activity.moveTaskToBack(true)
    }

    fun killProcess(activity: Activity) {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
        activity.finishAffinity()
      }
      exitProcess(0)
    }

    fun wakeLockScreen(context: Context) {
      val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
      val flag = PowerManager.SCREEN_BRIGHT_WAKE_LOCK
        .or(PowerManager.ACQUIRE_CAUSES_WAKEUP)
        .or(PowerManager.ON_AFTER_RELEASE)

      val newWakeLock = pm.newWakeLock(flag, "SystemUtils:WAKELOCK")
      newWakeLock.acquire(1000)
      newWakeLock.release()
    }
  }
}
