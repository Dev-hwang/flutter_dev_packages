package com.pravera.flutter_dev_packages.utils

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.location.LocationManager
import android.net.Uri
import android.os.Build
import android.provider.Settings

class PermissionUtils {
  companion object {
    fun canDrawOverlays(context: Context): Boolean {
      if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
        return true
      }

      return Settings.canDrawOverlays(context)
    }

    fun requestOverlays(activity: Activity, reqCode: Int) {
      if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M || canDrawOverlays(activity.applicationContext)) {
        val intent = Intent(activity.applicationContext, activity::class.java)
        activity.startActivityForResult(intent, reqCode)
        return
      }

      val packageUri = Uri.parse("package:${activity.packageName}")
      val nIntent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, packageUri)
      activity.startActivityForResult(nIntent, reqCode)
    }

    fun isLocationServiceEnabled(context: Context): Boolean {
      val lm = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
      return lm.isProviderEnabled(LocationManager.GPS_PROVIDER)
    }

    fun openLocationServiceSettings(activity: Activity, reqCode: Int) {
      val nIntent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
      nIntent.addCategory(Intent.CATEGORY_DEFAULT)
      activity.startActivityForResult(nIntent, reqCode)
    }
  }
}
