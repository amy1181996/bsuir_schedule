package com.abobasoft.bsuir_schedule

import android.annotation.SuppressLint
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import com.abobasoft.bsuir_schedule.R.layout.logo_homescreen_widget

class LogoHomescreenWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val titleText = "251001"
    val views = RemoteViews(context.packageName, logo_homescreen_widget)
    views.setTextViewText(R.id.LittleWidget_Title, titleText)

    var intent = Intent(context, MainActivity::class.java)
    var pendingIntent = PendingIntent.getActivity(context, 0, intent,
        PendingIntent.FLAG_IMMUTABLE)
    views.setOnClickPendingIntent(appWidgetId, pendingIntent)

    var serviceIntent = Intent(context, LittleHomescreenWidgetService::class.java)
    serviceIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
    serviceIntent.setData(Uri.parse(serviceIntent.toUri(Intent.URI_INTENT_SCHEME)))
//    TODO("add empty view")

    views.setRemoteAdapter(R.id.LittleWidget_Items, serviceIntent)

    appWidgetManager.updateAppWidget(appWidgetId, views)
}