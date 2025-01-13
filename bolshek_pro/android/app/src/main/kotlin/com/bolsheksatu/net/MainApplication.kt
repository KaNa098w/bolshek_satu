package com.bolsheksatu.net

import android.app.Application
import com.yandex.mapkit.MapKitFactory

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setLocale("ru_RU")
        MapKitFactory.setApiKey("721e8e1b-9628-4803-9dba-4479c4369909")
    }
}
