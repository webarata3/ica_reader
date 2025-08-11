package dev.webarata3.app.ica_reader

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.content.SharedPreferences
import android.util.Log

class HomeWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val sharedPreferences: SharedPreferences =
            context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val allEntries = sharedPreferences.all
            Log.d("################## log", "")
for ((key, value) in allEntries) {
    Log.d("####################### HomeWidget", "Key: $key, Value: $value")
}
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.home_widget_layout)
            val date = sharedPreferences.getString("date", "不明") ?: "不明"
            val balanceInt = sharedPreferences.getInt("balance", -1)
            val balance = if (balanceInt == -1) {
                "不明"
            } else {
                balanceInt.toString() + "円" }

            views.setTextViewText(R.id.date, date)
            views.setTextViewText(R.id.balance, balance)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
      }
}
