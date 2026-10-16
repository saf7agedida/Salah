#!/bin/bash
set -e

echo "🕌 جاري بناء مشروع تطبيق (صلاة - Salah) المتكامل..."

# تنظيف الملفات القديمة لضمان عدم وجود أي تعارض
rm -rf app/src
mkdir -p app/src/main/java/com/salah/app
mkdir -p app/src/main/res/values
mkdir -p app/src/main/res/values-ar
mkdir -p app/src/main/res/drawable
mkdir -p gradle/wrapper
mkdir -p .github/workflows

# 1. إعداد settings.gradle.kts
cat << 'SETTINGS_EOF' > settings.gradle.kts
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "SalahApp"
include(":app")
SETTINGS_EOF

# 2. إعداد build.gradle.kts الرئيسي
cat << 'ROOT_GRADLE_EOF' > build.gradle.kts
plugins {
    id("com.android.application") version "8.2.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
}
ROOT_GRADLE_EOF

# 3. إعداد gradle.properties
cat << 'PROPS_EOF' > gradle.properties
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
kotlin.code.style=official
android.nonTransitiveRClass=true
PROPS_EOF

# 4. إعداد gradle-wrapper.properties
cat << 'WRAPPER_EOF' > gradle/wrapper/gradle-wrapper.properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.4-bin.zip
networkTimeout=10000
validateDistributionUrl=true
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
WRAPPER_EOF

# 5. إعداد app/build.gradle.kts
cat << 'APP_GRADLE_EOF' > app/build.gradle.kts
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.salah.app"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.salah.app"
        minSdk = 24
        targetSdk = 34
        versionCode = 3
        versionName = "3.0.0"

        vectorDrawables {
            useSupportLibrary = true
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
    buildFeatures {
        compose = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.8"
    }
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

dependencies {
    val composeBom = platform("androidx.compose:compose-bom:2024.02.00")
    implementation(composeBom)

    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    implementation("androidx.activity:activity-compose:1.8.2")

    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.material:material-icons-extended")

    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
}
APP_GRADLE_EOF

# 6. تصميم شعار التطبيق الإسلامي (قبة مسجد ومئذنة وهلال)
cat << 'LOGO_EOF' > app/src/main/res/drawable/ic_salah_logo.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <!-- خلفية دائرية زمردية داكنة -->
    <path
        android:fillColor="#064E3B"
        android:pathData="M54,54m-50,0a50,50 0,1 1,100 0a50,50 0,1 1,-100 0" />
    <!-- إطار ذهبي داخلي -->
    <path
        android:fillColor="#00000000"
        android:strokeColor="#FBBF24"
        android:strokeWidth="2.5"
        android:pathData="M54,54m-45,0a45,45 0,1 1,90 0a45,45 0,1 1,-90 0" />
    <!-- الهلال الذهبي في الأعلى -->
    <path
        android:fillColor="#FDE047"
        android:pathData="M54,18c-3.5,0 -6.3,2.8 -6.3,6.3c0,3.5 2.8,6.3 6.3,6.3c1.2,0 2.3,-0.3 3.2,-0.9c-2.6,-0.7 -4.5,-3 -4.5,-5.8c0,-2.8 1.9,-5.1 4.5,-5.8C56.3,18.3 55.2,18 54,18z" />
    <!-- قبة المسجد الرئيسية -->
    <path
        android:fillColor="#10B981"
        android:pathData="M30,62 C30,44 42,33 54,31 C66,33 78,44 78,62 Z" />
    <!-- المئذنة اليمنى -->
    <path
        android:fillColor="#FBBF24"
        android:pathData="M79,34h6v28h-6z" />
    <path
        android:fillColor="#FDE047"
        android:pathData="M78,34l4,-7l4,7z" />
    <!-- قاعدة المسجد والأبواب -->
    <path
        android:fillColor="#047857"
        android:pathData="M24,62h62v18h-62z" />
    <path
        android:fillColor="#FDE047"
        android:pathData="M48,80v-10c0,-3.3 2.7,-6 6,-6s6,2.7 6,6v10z" />
    <!-- خط القاعدة الذهبي -->
    <path
        android:fillColor="#FBBF24"
        android:pathData="M20,80h68v4h-68z" />
</vector>
LOGO_EOF

# 7. إنشاء AndroidManifest.xml
cat << 'MANIFEST_EOF' > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />

    <application
        android:allowBackup="true"
        android:icon="@drawable/ic_salah_logo"
        android:roundIcon="@drawable/ic_salah_logo"
        android:label="@string/app_name"
        android:supportsRtl="true"
        android:theme="@style/Theme.SalahApp">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:configChanges="locale|layoutDirection"
            android:theme="@style/Theme.SalahApp">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <receiver
            android:name=".PrayerReminderReceiver"
            android:exported="false" />

        <receiver
            android:name=".PrayerActionReceiver"
            android:exported="false" />

        <receiver
            android:name=".BootCompletedReceiver"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED" />
            </intent-filter>
        </receiver>

    </application>

</manifest>
MANIFEST_EOF

# 8. إنشاء ملفات النصوص باسم "صلاة" و "Salah"
cat << 'STRINGS_EN_EOF' > app/src/main/res/values/strings.xml
<resources>
    <string name="app_name">Salah</string>
</resources>
STRINGS_EN_EOF

cat << 'STRINGS_AR_EOF' > app/src/main/res/values-ar/strings.xml
<resources>
    <string name="app_name">صلاة</string>
</resources>
STRINGS_AR_EOF

cat << 'THEMES_EOF' > app/src/main/res/values/themes.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.SalahApp" parent="android:Theme.Material.NoActionBar">
        <item name="android:statusBarColor">@android:color/transparent</item>
    </style>
</resources>
THEMES_EOF

# 9. إنشاء الكود البرمجي الكامل في MainActivity.kt
cat << 'KOTLIN_EOF' > app/src/main/java/com/salah/app/MainActivity.kt
package com.salah.app

import android.Manifest
import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.location.Geocoder
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import android.os.CancellationSignal
import android.os.Handler
import android.os.Looper
import android.view.HapticFeedbackConstants
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.draw.scale
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.LayoutDirection
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import java.text.SimpleDateFormat
import java.util.*
import kotlin.math.*

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        PrayerReminderHelper.createNotificationChannel(this)
        PrayerReminderHelper.scheduleTenMinuteCheck(this)

        setContent {
            MaterialTheme(
                colorScheme = darkColorScheme(
                    primary = Color(0xFF10B981),
                    secondary = Color(0xFFFBBF24),
                    background = Color(0xFF041C15)
                )
            ) {
                SalahMainApp()
            }
        }
    }
}

// ============================================================================
// 1. دوال تحويل الوقت لنظام 12 ساعة (ص / م - AM / PM) وحساب التواريخ
// ============================================================================
object TimeUtils {
    fun parseToMinutes(time24: String?): Int? {
        if (time24.isNullOrBlank()) return null
        val clean = time24.substringBefore(" ").trim()
        val parts = clean.split(":")
        if (parts.size < 2) return null
        val h = parts[0].toIntOrNull() ?: return null
        val m = parts[1].toIntOrNull() ?: return null
        return h * 60 + m
    }

    fun formatTo12Hour(time24: String, isArabic: Boolean): String {
        val clean = time24.substringBefore(" ").trim()
        val parts = clean.split(":")
        if (parts.size < 2) return time24
        val hour24 = parts[0].toIntOrNull() ?: return time24
        val minute = parts[1].toIntOrNull() ?: return time24

        val isPm = hour24 >= 12
        val hour12 = when {
            hour24 == 0 -> 12
            hour24 > 12 -> hour24 - 12
            else -> hour24
        }
        val suffix = if (isArabic) {
            if (isPm) "م" else "ص"
        } else {
            if (isPm) "PM" else "AM"
        }
        return String.format(Locale.US, "%d:%02d %s", hour12, minute, suffix)
    }

    fun getTodayKey(): String {
        return SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
    }

    fun getYesterdayKey(): String {
        val cal = Calendar.getInstance()
        cal.add(Calendar.DAY_OF_YEAR, -1)
        return SimpleDateFormat("yyyy-MM-dd", Locale.US).format(cal.time)
    }
}

// ============================================================================
// 2. إدارة حفظ الإعدادات والموقع والصلوات والسبحة (SharedPreferences)
// ============================================================================
object AppPrefs {
    private const val PREFS_NAME = "salah_app_prefs_v3"
    private const val KEY_IS_ARABIC = "is_arabic"
    private const val KEY_CITY_AR = "city_ar"
    private const val KEY_CITY_EN = "city_en"
    private const val KEY_LAT = "lat"
    private const val KEY_LON = "lon"
    private const val KEY_HIJRI_AR = "hijri_ar"
    private const val KEY_HIJRI_EN = "hijri_en"
    private const val KEY_TOTAL_TASBIH = "total_tasbih"
    private const val KEY_HAS_TIMINGS = "has_loaded_timings"

    fun isArabic(context: Context): Boolean {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .getBoolean(KEY_IS_ARABIC, true)
    }

    fun setArabic(context: Context, isArabic: Boolean) {
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit().putBoolean(KEY_IS_ARABIC, isArabic).apply()
    }

    fun getSavedLocation(context: Context): UserLocation {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val nameAr = prefs.getString(KEY_CITY_AR, "القاهرة") ?: "القاهرة"
        val nameEn = prefs.getString(KEY_CITY_EN, "Cairo") ?: "Cairo"
        val lat = prefs.getFloat(KEY_LAT, 30.0444f).toDouble()
        val lon = prefs.getFloat(KEY_LON, 31.2357f).toDouble()
        return UserLocation(nameAr, nameEn, lat, lon)
    }

    fun saveLocation(context: Context, loc: UserLocation) {
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE).edit()
            .putString(KEY_CITY_AR, loc.nameAr)
            .putString(KEY_CITY_EN, loc.nameEn)
            .putFloat(KEY_LAT, loc.lat.toFloat())
            .putFloat(KEY_LON, loc.lon.toFloat())
            .apply()
    }

    fun savePrayerTimings(
        context: Context,
        prayers: List<PrayerItem>,
        hijriAr: String,
        hijriEn: String
    ) {
        val edit = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE).edit()
        prayers.forEach { p ->
            edit.putString("time_${p.key}", p.time24)
        }
        edit.putString(KEY_HIJRI_AR, hijriAr)
        edit.putString(KEY_HIJRI_EN, hijriEn)
        edit.putBoolean(KEY_HAS_TIMINGS, true)
        edit.apply()
    }

    fun hasLoadedTimings(context: Context): Boolean {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .getBoolean(KEY_HAS_TIMINGS, false)
    }

    fun getCachedPrayerTime24(context: Context, key: String): String? {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .getString("time_$key", null)
    }

    fun getSavedHijri(context: Context, isArabic: Boolean): String {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        return if (isArabic) {
            prefs.getString(KEY_HIJRI_AR, "التاريخ الهجري") ?: "التاريخ الهجري"
        } else {
            prefs.getString(KEY_HIJRI_EN, "Hijri Date") ?: "Hijri Date"
        }
    }

    // تحديد تاريخ اليوم الفعلي للصلاة (معالجة ذكية لما بعد 12 منتصف الليل قبل الفجر)
    fun getEffectiveDateKey(context: Context, prayerKey: String): String {
        if (prayerKey == "Isha") {
            val fajrMin = TimeUtils.parseToMinutes(getCachedPrayerTime24(context, "Fajr")) ?: 270
            val cal = Calendar.getInstance()
            val nowMin = cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE)
            // إذا كان الوقت بعد 12 منتصف الليل وقبل الفجر، فإن صلاة العشاء تتبع ليلة أمس
            if (nowMin < fajrMin) {
                return TimeUtils.getYesterdayKey()
            }
        }
        return TimeUtils.getTodayKey()
    }

    fun isPrayerDone(context: Context, prayerKey: String): Boolean {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val effectiveDate = getEffectiveDateKey(context, prayerKey)
        val todayDate = TimeUtils.getTodayKey()
        return prefs.getBoolean("done_${effectiveDate}_$prayerKey", false) ||
                prefs.getBoolean("done_${todayDate}_$prayerKey", false)
    }

    fun setPrayerDone(context: Context, prayerKey: String, done: Boolean) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE).edit()
        val effectiveDate = getEffectiveDateKey(context, prayerKey)
        val todayDate = TimeUtils.getTodayKey()
        prefs.putBoolean("done_${effectiveDate}_$prayerKey", done)
        prefs.putBoolean("done_${todayDate}_$prayerKey", done)
        prefs.apply()
    }

    fun getTotalTasbih(context: Context): Int {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .getInt(KEY_TOTAL_TASBIH, 0)
    }

    fun incrementTasbih(context: Context): Int {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val next = prefs.getInt(KEY_TOTAL_TASBIH, 0) + 1
        prefs.edit().putInt(KEY_TOTAL_TASBIH, next).apply()
        return next
    }
}

// ============================================================================
// 3. نظام تحديد الصلاة الحالية والتذكير كل 10 دقائق بدون أي خطأ في الأوقات
// ============================================================================
data class ActivePrayerInfo(
    val key: String,
    val nameAr: String,
    val nameEn: String,
    val time24: String
)

object PrayerReminderHelper {
    const val CHANNEL_ID = "salah_persistent_reminder_v3"
    const val NOTIFICATION_ID = 2002
    const val ACTION_MARK_PRAYED = "com.salah.app.ACTION_MARK_PRAYED"
    const val EXTRA_PRAYER_KEY = "extra_prayer_key"

    // الصلوات الخمس المفروضة + الشروق للعرض
    val allPrayerDefs = listOf(
        Triple("Fajr", "الفجر", "Fajr"),
        Triple("Sunrise", "الشروق", "Sunrise"),
        Triple("Dhuhr", "الظهر", "Dhuhr"),
        Triple("Asr", "العصر", "Asr"),
        Triple("Maghrib", "المغرب", "Maghrib"),
        Triple("Isha", "العشاء", "Isha")
    )

    val obligatoryDefs = listOf(
        Triple("Fajr", "الفجر", "Fajr"),
        Triple("Dhuhr", "الظهر", "Dhuhr"),
        Triple("Asr", "العصر", "Asr"),
        Triple("Maghrib", "المغرب", "Maghrib"),
        Triple("Isha", "العشاء", "Isha")
    )

    fun createNotificationChannel(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "تذكير الصلاة المستمر (صلاة)",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "يذكرك بالصلاة الحالية كل 10 دقائق حتى تضغط تمت الصلاة"
                enableVibration(true)
            }
            val manager = context.getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }

    fun scheduleTenMinuteCheck(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, PrayerReminderReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            888,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val triggerAtMillis = System.currentTimeMillis() + (10 * 60 * 1000L) // 10 دقائق
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    triggerAtMillis,
                    pendingIntent
                )
            } else {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    triggerAtMillis,
                    pendingIntent
                )
            }
        } catch (e: SecurityException) {
            alarmManager.set(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent)
        }
    }

    /**
     * يحدد بدقة تامة الصلاة المفروضة الحالية:
     * - من أذان الفجر إلى أذان الظهر: الفجر (وإذا أشرقت الشمس وكان قد صلى الفجر لا يزعجه بأي إشعار).
     * - من الظهر إلى العصر: الظهر.
     * - من العصر إلى المغرب: العصر.
     * - من المغرب إلى العشاء: المغرب.
     * - من العشاء وحتى أذان الفجر (بما في ذلك بعد الساعة 12 منتصف الليل): العشاء!
     */
    fun getCurrentActivePrayer(context: Context): ActivePrayerInfo? {
        if (!AppPrefs.hasLoadedTimings(context)) return null

        val fajrStr = AppPrefs.getCachedPrayerTime24(context, "Fajr") ?: return null
        val sunriseStr = AppPrefs.getCachedPrayerTime24(context, "Sunrise") ?: "06:00"
        val dhuhrStr = AppPrefs.getCachedPrayerTime24(context, "Dhuhr") ?: return null
        val asrStr = AppPrefs.getCachedPrayerTime24(context, "Asr") ?: return null
        val maghribStr = AppPrefs.getCachedPrayerTime24(context, "Maghrib") ?: return null
        val ishaStr = AppPrefs.getCachedPrayerTime24(context, "Isha") ?: return null

        val fajrMin = TimeUtils.parseToMinutes(fajrStr) ?: return null
        val sunriseMin = TimeUtils.parseToMinutes(sunriseStr) ?: (fajrMin + 85)
        val dhuhrMin = TimeUtils.parseToMinutes(dhuhrStr) ?: return null
        val asrMin = TimeUtils.parseToMinutes(asrStr) ?: return null
        val maghribMin = TimeUtils.parseToMinutes(maghribStr) ?: return null
        val ishaMin = TimeUtils.parseToMinutes(ishaStr) ?: return null

        val cal = Calendar.getInstance()
        val nowMin = cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE)

        return when {
            // بعد الساعة 12 منتصف الليل وقبل الفجر -> الوقت يتبع صلاة العشاء!
            nowMin < fajrMin -> ActivePrayerInfo("Isha", "العشاء", "Isha", ishaStr)

            // من الفجر إلى الشروق -> وقت أداء الفجر
            nowMin in fajrMin until sunriseMin -> ActivePrayerInfo("Fajr", "الفجر", "Fajr", fajrStr)

            // من الشروق إلى الظهر -> وقت الضحى (لا توجد فريضة جديدة، لكن لو لم يصلِّ الفجر يذكره بالفجر)
            nowMin in sunriseMin until dhuhrMin -> {
                if (!AppPrefs.isPrayerDone(context, "Fajr")) {
                    ActivePrayerInfo("Fajr", "الفجر", "Fajr", fajrStr)
                } else {
                    null
                }
            }

            // من الظهر إلى العصر -> صلاة الظهر
            nowMin in dhuhrMin until asrMin -> ActivePrayerInfo("Dhuhr", "الظهر", "Dhuhr", dhuhrStr)

            // من العصر إلى المغرب -> صلاة العصر
            nowMin in asrMin until maghribMin -> ActivePrayerInfo("Asr", "العصر", "Asr", asrStr)

            // من المغرب إلى العشاء -> صلاة المغرب
            nowMin in maghribMin until ishaMin -> ActivePrayerInfo("Maghrib", "المغرب", "Maghrib", maghribStr)

            // من العشاء إلى 12 منتصف الليل -> صلاة العشاء
            else -> ActivePrayerInfo("Isha", "العشاء", "Isha", ishaStr)
        }
    }

    fun checkAndSendReminder(context: Context, forceTest: Boolean = false) {
        createNotificationChannel(context)
        val activePrayer = getCurrentActivePrayer(context)

        if (activePrayer == null && !forceTest) {
            cancelNotification(context)
            return
        }

        val target = activePrayer ?: ActivePrayerInfo("Dhuhr", "الظهر", "Dhuhr", "12:00")
        val isDone = AppPrefs.isPrayerDone(context, target.key)

        if (!isDone || forceTest) {
            val isAr = AppPrefs.isArabic(context)
            val prayerName = if (isAr) target.nameAr else target.nameEn
            val formattedTime = TimeUtils.formatTo12Hour(target.time24, isAr)

            val openIntent = Intent(context, MainActivity::class.java)
            val openPending = PendingIntent.getActivity(
                context,
                0,
                openIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val prayedIntent = Intent(context, PrayerActionReceiver::class.java).apply {
                action = ACTION_MARK_PRAYED
                putExtra(EXTRA_PRAYER_KEY, target.key)
            }
            val prayedPending = PendingIntent.getBroadcast(
                context,
                target.key.hashCode(),
                prayedIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val title = if (isAr) {
                "🕌 حي على الصلاة: هل صليت $prayerName؟ ($formattedTime)"
            } else {
                "🕌 Prayer Reminder: Have you prayed $prayerName? ($formattedTime)"
            }

            val body = if (isAr) {
                "تذكير مستمر كل 10 دقائق لحين أداء الصلاة. اضغط «تمت الصلاة ✅» لإيقاف التنبيه."
            } else {
                "Repeats every 10 minutes until you pray. Tap 'I Prayed ✅' to dismiss."
            }

            val actionLabel = if (isAr) "تمت الصلاة ✅" else "I Prayed ✅"

            val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_salah_logo)
                .setContentTitle(title)
                .setContentText(body)
                .setStyle(NotificationCompat.BigTextStyle().bigText(body))
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setCategory(NotificationCompat.CATEGORY_ALARM)
                .setOngoing(true)
                .setAutoCancel(false)
                .setContentIntent(openPending)
                .addAction(android.R.drawable.checkbox_on_background, actionLabel, prayedPending)
                .build()

            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU ||
                ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
            ) {
                manager.notify(NOTIFICATION_ID, notification)
            }
        } else {
            cancelNotification(context)
        }
    }

    fun cancelNotification(context: Context) {
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.cancel(NOTIFICATION_ID)
    }
}

class PrayerReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        PrayerReminderHelper.checkAndSendReminder(context)
        PrayerReminderHelper.scheduleTenMinuteCheck(context)
    }
}

class PrayerActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action == PrayerReminderHelper.ACTION_MARK_PRAYED) {
            val prayerKey = intent.getStringExtra(PrayerReminderHelper.EXTRA_PRAYER_KEY) ?: return
            AppPrefs.setPrayerDone(context, prayerKey, true)
            PrayerReminderHelper.cancelNotification(context)
            val isAr = AppPrefs.isArabic(context)
            Toast.makeText(
                context,
                if (isAr) "تقبل الله طاعتكم! تم تسجيل أداء الصلاة ✅" else "May Allah accept your prayer! ✅",
                Toast.LENGTH_SHORT
            ).show()
        }
    }
}

class BootCompletedReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action == Intent.ACTION_BOOT_COMPLETED) {
            PrayerReminderHelper.scheduleTenMinuteCheck(context)
        }
    }
}

// ============================================================================
// 4. نماذج البيانات وموسوعة الأذكار وحصن المسلم
// ============================================================================
data class UserLocation(
    val nameAr: String,
    val nameEn: String,
    val lat: Double,
    val lon: Double
)

data class PrayerItem(
    val key: String,
    val nameAr: String,
    val nameEn: String,
    val time24: String,
    val isObligatory: Boolean = key != "Sunrise"
)

data class ZikrItem(
    val id: Int,
    val category: String,
    val textAr: String,
    val textEn: String,
    val targetCount: Int,
    val virtueAr: String,
    val virtueEn: String
)

val presetLocations = listOf(
    UserLocation("القاهرة", "Cairo", 30.0444, 31.2357),
    UserLocation("العاشر من رمضان", "10th of Ramadan", 30.2969, 31.7426),
    UserLocation("الإسكندرية", "Alexandria", 31.2001, 29.9187),
    UserLocation("مكة المكرمة", "Makkah", 21.4225, 39.8262),
    UserLocation("المدينة المنورة", "Madinah", 24.4672, 39.6112),
    UserLocation("الرياض", "Riyadh", 24.7136, 46.6753),
    UserLocation("دبي", "Dubai", 25.2048, 55.2708)
)

val hisnAlMuslimAzkar = listOf(
    // أذكار الصباح
    ZikrItem(
        1, "morning",
        "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.",
        "We have reached the morning and at this very time all sovereignty belongs to Allah, and all praise is for Allah.",
        1, "من أذكار الصباح النبوية", "Prophetic Morning Remembrance"
    ),
    ZikrItem(
        2, "morning",
        "اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ.",
        "O Allah, by your leave we have reached the morning and by Your leave we have reached the evening.",
        1, "حفظ وبركة في بداية اليوم", "Protection at the start of the day"
    ),
    ZikrItem(
        3, "morning",
        "بِسْمِ اللهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ.",
        "In the Name of Allah with Whose Name there is protection against every kind of harm in the earth or in the heaven.",
        3, "من قالها 3 مرات لم يضره شيء", "Whoever recites it 3 times will not be harmed"
    ),
    ZikrItem(
        4, "morning",
        "حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ.",
        "Allah is Sufficient for me, none has the right to be worshipped except Him, upon Him I rely.",
        7, "من قالها 7 مرات كفاه الله ما أهمه", "Sufficient against all worries (7 times)"
    ),
    // أذكار المساء
    ZikrItem(
        5, "evening",
        "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.",
        "We have reached the evening and at this very time all sovereignty belongs to Allah.",
        1, "من أذكار المساء المباركة", "Evening Remembrance"
    ),
    ZikrItem(
        6, "evening",
        "أَعُوذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.",
        "I seek refuge in the Perfect Words of Allah from the evil of what He has created.",
        3, "تحصين المساء من كل سوء", "Protection in the evening (3 times)"
    ),
    ZikrItem(
        7, "evening",
        "رَضِيتُ بِاللهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا.",
        "I am pleased with Allah as a Lord, with Islam as a religion, and with Muhammad (ﷺ) as a Prophet.",
        3, "كان حقاً على الله أن يرضيه يوم القيامة", "Guaranteed Allah's pleasure (3 times)"
    ),
    // أذكار بعد الصلاة
    ZikrItem(
        8, "prayer",
        "أَسْتَغْفِرُ اللهَ (ثَلاثاً) .. اللَّهُمَّ أَنْتَ السَّلامُ وَمِنْكَ السَّلامُ، تَبَارَكْتَ يَا ذَا الجَلالِ وَالإِكْرَامِ.",
        "I seek the forgiveness of Allah (3x). O Allah, You are Peace and from You comes peace.",
        1, "سنة دبر كل صلاة مفروضة", "Immediately after obligatory prayer"
    ),
    ZikrItem(
        9, "prayer",
        "سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَاللَّهُ أَكْبَرُ.",
        "SubhanAllah (Glory be to Allah), Alhamdulillah (Praise be to Allah), Allahu Akbar (Allah is Greatest).",
        33, "تسبح 33 وتحمد 33 وتكبر 33 بعد كل صلاة", "33 times after every prayer"
    ),
    ZikrItem(
        10, "prayer",
        "اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ، وَشُكْرِكَ، وَحُسْنِ عِبَادَتِكَ.",
        "O Allah, help me to remember You, to give thanks to You, and to worship You in the best manner.",
        1, "وصية النبي ﷺ لمعاذ بن جبل دبر كل صلاة", "The Prophet's advice after every prayer"
    ),
    // أذكار النوم وحصن المسلم
    ZikrItem(
        11, "hisn",
        "بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ.",
        "In Your name my Lord, I lie down and in Your name I rise, so if You should take my soul then have mercy upon it.",
        1, "من أذكار النوم في حصن المسلم", "Before sleeping (Hisn Al-Muslim)"
    ),
    ZikrItem(
        12, "hisn",
        "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي.",
        "O Allah, I ask You for pardon and well-being in this life and the next, in my religion, worldly affairs, family and wealth.",
        1, "من جوامع الدعاء والتحصين اليومي", "Comprehensive protection Dua"
    ),
    ZikrItem(
        13, "hisn",
        "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ، وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ.",
        "O Ever-Living, O Self-Subsisting, by Your mercy I seek help; rectify all my affairs and do not leave me to myself for the blink of an eye.",
        3, "دعاء الكرب والفرج من حصن المسلم", "For relief and divine support"
    )
)

// ============================================================================
// 5. الواجهة الرئيسية للتطبيق مع شريط التنقل السفلي (4 أقسام)
// ============================================================================
@Composable
fun SalahMainApp() {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()

    var isArabic by remember { mutableStateOf(AppPrefs.isArabic(context)) }
    var currentTab by remember { mutableIntStateOf(0) }
    var userLocation by remember { mutableStateOf(AppPrefs.getSavedLocation(context)) }
    var prayersList by remember { mutableStateOf(loadCachedPrayersList(context)) }
    var hijriText by remember { mutableStateOf(AppPrefs.getSavedHijri(context, isArabic)) }
    var isLoading by remember { mutableStateOf(true) }
    var isLocatingGps by remember { mutableStateOf(false) }
    var prayedMap by remember { mutableStateOf(mapOf<String, Boolean>()) }
    var currentTimeTick by remember { mutableLongStateOf(System.currentTimeMillis()) }

    fun refreshPrayedStates() {
        val map = mutableMapOf<String, Boolean>()
        PrayerReminderHelper.obligatoryDefs.forEach { def ->
            map[def.first] = AppPrefs.isPrayerDone(context, def.first)
        }
        prayedMap = map
    }

    fun loadTimingsForLocation(loc: UserLocation) {
        scope.launch {
            isLoading = true
            val result = fetchPrayerTimesFromAladhan(context, loc.lat, loc.lon)
            prayersList = result.first
            hijriText = if (isArabic) result.second else result.third
            isLoading = false
            refreshPrayedStates()
            PrayerReminderHelper.checkAndSendReminder(context)
        }
    }

    // عداد زمني يتحدث كل ثانية لحساب الوقت المتبقي للصلاة القادمة بدقة
    LaunchedEffect(Unit) {
        while (true) {
            currentTimeTick = System.currentTimeMillis()
            refreshPrayedStates()
            delay(1000L)
        }
    }

    val notificationPermissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestPermission()
    ) { _ -> }

    val locationPermissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestMultiplePermissions()
    ) { permissions ->
        val granted = permissions[Manifest.permission.ACCESS_FINE_LOCATION] == true ||
                permissions[Manifest.permission.ACCESS_COARSE_LOCATION] == true
        if (granted) {
            isLocatingGps = true
            fetchAccurateGpsAndCityName(context) { detectedLoc ->
                isLocatingGps = false
                if (detectedLoc != null) {
                    userLocation = detectedLoc
                    AppPrefs.saveLocation(context, detectedLoc)
                    loadTimingsForLocation(detectedLoc)
                    Toast.makeText(
                        context,
                        if (isArabic) "تم تحديد موقعك: ${detectedLoc.nameAr} 📍" else "Located: ${detectedLoc.nameEn} 📍",
                        Toast.LENGTH_SHORT
                    ).show()
                } else {
                    Toast.makeText(
                        context,
                        if (isArabic) "تأكد من تفعيل خدمة الموقع (GPS) في الهاتف" else "Please enable GPS Location on your phone",
                        Toast.LENGTH_LONG
                    ).show()
                }
            }
        } else {
            Toast.makeText(
                context,
                if (isArabic) "يلزم السماح بصلاحية الموقع لتحديد مدينتك" else "Location permission is required",
                Toast.LENGTH_SHORT
            ).show()
        }
    }

    LaunchedEffect(Unit) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            notificationPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
        }
        loadTimingsForLocation(userLocation)
    }

    val layoutDirection = if (isArabic) LayoutDirection.Rtl else LayoutDirection.Ltr
    val bgBrush = Brush.verticalGradient(
        listOf(Color(0xFF042F24), Color(0xFF061E18), Color(0xFF03110E))
    )

    CompositionLocalProvider(LocalLayoutDirection provides layoutDirection) {
        Scaffold(
            containerColor = Color.Transparent,
            bottomBar = {
                NavigationBar(
                    containerColor = Color(0xFF05241C).copy(alpha = 0.96f),
                    tonalElevation = 10.dp
                ) {
                    val items = listOf(
                        Triple(0, if (isArabic) "المواقيت" else "Prayers", Icons.Filled.AccessTime),
                        Triple(1, if (isArabic) "الأذكار وحصن المسلم" else "Azkar", Icons.Filled.MenuBook),
                        Triple(2, if (isArabic) "السبحة" else "Tasbih", Icons.Filled.TouchApp),
                        Triple(3, if (isArabic) "القبلة" else "Qibla", Icons.Filled.Explore)
                    )
                    items.forEach { (index, label, icon) ->
                        NavigationBarItem(
                            selected = currentTab == index,
                            onClick = { currentTab = index },
                            icon = { Icon(imageVector = icon, contentDescription = label) },
                            label = {
                                Text(
                                    text = label,
                                    fontSize = 11.sp,
                                    fontWeight = if (currentTab == index) FontWeight.Bold else FontWeight.Normal
                                )
                            },
                            colors = NavigationBarItemDefaults.colors(
                                selectedIconColor = Color(0xFF042F24),
                                selectedTextColor = Color(0xFFFDE047),
                                indicatorColor = Color(0xFFFBBF24),
                                unselectedIconColor = Color.White.copy(alpha = 0.6f),
                                unselectedTextColor = Color.White.copy(alpha = 0.6f)
                            )
                        )
                    }
                }
            }
        ) { innerPadding ->
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(bgBrush)
                    .padding(innerPadding)
            ) {
                Column(modifier = Modifier.fillMaxSize()) {
                    // الشريط العلوي الدائم
                    SalahTopBar(
                        cityName = if (isArabic) userLocation.nameAr else userLocation.nameEn,
                        hijriDate = hijriText,
                        isArabic = isArabic,
                        isLocatingGps = isLocatingGps,
                        onRequestGps = {
                            locationPermissionLauncher.launch(
                                arrayOf(
                                    Manifest.permission.ACCESS_FINE_LOCATION,
                                    Manifest.permission.ACCESS_COARSE_LOCATION
                                )
                            )
                        },
                        onToggleLanguage = {
                            val nextLang = !isArabic
                            isArabic = nextLang
                            AppPrefs.setArabic(context, nextLang)
                            hijriText = AppPrefs.getSavedHijri(context, nextLang)
                        },
                        onRefresh = { loadTimingsForLocation(userLocation) }
                    )

                    when (currentTab) {
                        0 -> PrayersHomeScreen(
                            context = context,
                            prayers = prayersList,
                            prayedMap = prayedMap,
                            selectedLoc = userLocation,
                            isArabic = isArabic,
                            isLoading = isLoading,
                            currentTimeTick = currentTimeTick,
                            onSelectPresetCity = { city ->
                                userLocation = city
                                AppPrefs.saveLocation(context, city)
                                loadTimingsForLocation(city)
                            },
                            onTogglePrayerDone = { key, done ->
                                AppPrefs.setPrayerDone(context, key, done)
                                refreshPrayedStates()
                                val currentActive = PrayerReminderHelper.getCurrentActivePrayer(context)
                                if (done && currentActive?.key == key) {
                                    PrayerReminderHelper.cancelNotification(context)
                                } else if (!done && currentActive?.key == key) {
                                    PrayerReminderHelper.checkAndSendReminder(context)
                                }
                            }
                        )
                        1 -> AzkarAndHisnScreen(isArabic = isArabic)
                        2 -> ElectronicSebhaScreen(context = context, isArabic = isArabic)
                        3 -> QiblaCompassScreen(
                            userLocation = userLocation,
                            isArabic = isArabic,
                            onTestNotification = {
                                PrayerReminderHelper.checkAndSendReminder(context, forceTest = true)
                            }
                        )
                    }
                }
            }
        }
    }
}

// ============================================================================
// 6. الشريط العلوي (اسم التطبيق + المدينة + التاريخ الهجري + GPS + اللغة)
// ============================================================================
@Composable
fun SalahTopBar(
    cityName: String,
    hijriDate: String,
    isArabic: Boolean,
    isLocatingGps: Boolean,
    onRequestGps: () -> Unit,
    onToggleLanguage: () -> Unit,
    onRefresh: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 12.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.weight(1f)
        ) {
            Box(
                modifier = Modifier
                    .size(44.dp)
                    .clip(CircleShape)
                    .background(Color(0xFF10B981).copy(alpha = 0.2f))
                    .border(1.5.dp, Color(0xFFFBBF24), CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Text(text = "🕌", fontSize = 22.sp)
            }
            Spacer(modifier = Modifier.width(10.dp))
            Column {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        text = if (isArabic) "صلاة • " else "Salah • ",
                        color = Color(0xFFFDE047),
                        fontSize = 18.sp,
                        fontWeight = FontWeight.ExtraBold
                    )
                    Text(
                        text = cityName,
                        color = Color.White,
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
                Text(
                    text = hijriDate,
                    color = Color(0xFFA7F3D0),
                    fontSize = 12.sp,
                    fontWeight = FontWeight.Medium
                )
            }
        }

        Row(
            horizontalArrangement = Arrangement.spacedBy(6.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // زر تحديد المدينة بالـ GPS
            Box(
                modifier = Modifier
                    .clip(RoundedCornerShape(50))
                    .background(Color(0xFF10B981).copy(alpha = 0.25f))
                    .border(1.dp, Color(0xFFFBBF24), RoundedCornerShape(50))
                    .clickable { onRequestGps() }
                    .padding(horizontal = 12.dp, vertical = 7.dp),
                contentAlignment = Alignment.Center
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    if (isLocatingGps) {
                        CircularProgressIndicator(
                            color = Color(0xFFFDE047),
                            strokeWidth = 2.dp,
                            modifier = Modifier.size(14.dp)
                        )
                    } else {
                        Icon(
                            imageVector = Icons.Filled.MyLocation,
                            contentDescription = "GPS",
                            tint = Color(0xFFFDE047),
                            modifier = Modifier.size(15.dp)
                        )
                    }
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        text = "GPS",
                        color = Color.White,
                        fontWeight = FontWeight.Bold,
                        fontSize = 12.sp
                    )
                }
            }

            // زر اللغة
            Box(
                modifier = Modifier
                    .clip(RoundedCornerShape(50))
                    .background(Color.White.copy(alpha = 0.1f))
                    .border(1.dp, Color.White.copy(alpha = 0.25f), RoundedCornerShape(50))
                    .clickable { onToggleLanguage() }
                    .padding(horizontal = 10.dp, vertical = 7.dp)
            ) {
                Text(
                    text = if (isArabic) "EN" else "عربي",
                    color = Color.White,
                    fontWeight = FontWeight.Bold,
                    fontSize = 12.sp
                )
            }

            // زر التحديث
            IconButton(
                onClick = onRefresh,
                modifier = Modifier
                    .size(34.dp)
                    .clip(CircleShape)
                    .background(Color.White.copy(alpha = 0.1f))
            ) {
                Icon(
                    imageVector = Icons.Filled.Refresh,
                    contentDescription = null,
                    tint = Color.White,
                    modifier = Modifier.size(18.dp)
                )
            }
        }
    }
}

// ============================================================================
// 7. القسم الأول: شاشة مواقيت الصلاة (نظام 12 ساعة + العداد التنازلي + المتابعة)
// ============================================================================
@Composable
fun PrayersHomeScreen(
    context: Context,
    prayers: List<PrayerItem>,
    prayedMap: Map<String, Boolean>,
    selectedLoc: UserLocation,
    isArabic: Boolean,
    isLoading: Boolean,
    currentTimeTick: Long,
    onSelectPresetCity: (UserLocation) -> Unit,
    onTogglePrayerDone: (String, Boolean) -> Unit
) {
    val activePrayer = remember(currentTimeTick, prayers) {
        PrayerReminderHelper.getCurrentActivePrayer(context)
    }
    val nextPrayerInfo = remember(currentTimeTick, prayers, isArabic) {
        calculateNextPrayerCountdown(prayers, isArabic)
    }
    val completedCount = prayedMap.values.count { it }

    LazyColumn(
        modifier = Modifier.fillMaxSize(),
        contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // 1. شريط اختيار المدن السريع
        item {
            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                items(presetLocations) { city ->
                    val isSelected = city.nameAr == selectedLoc.nameAr || city.nameEn == selectedLoc.nameEn
                    Box(
                        modifier = Modifier
                            .clip(RoundedCornerShape(14.dp))
                            .background(
                                if (isSelected) Brush.horizontalGradient(
                                    listOf(Color(0xFF10B981), Color(0xFF059669))
                                ) else Brush.horizontalGradient(
                                    listOf(Color.White.copy(alpha = 0.08f), Color.White.copy(alpha = 0.08f))
                                )
                            )
                            .border(
                                1.dp,
                                if (isSelected) Color(0xFFFDE047) else Color.White.copy(alpha = 0.15f),
                                RoundedCornerShape(14.dp)
                            )
                            .clickable { onSelectPresetCity(city) }
                            .padding(horizontal = 14.dp, vertical = 8.dp)
                    ) {
                        Text(
                            text = if (isArabic) city.nameAr else city.nameEn,
                            color = Color.White,
                            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Normal,
                            fontSize = 13.sp
                        )
                    }
                }
            }
        }

        // 2. تنبيه الصلاة الحالية المستمر (يظهر فقط إذا دخل وقت الصلاة ولم يضغط تمت الصلاة)
        if (activePrayer != null && prayedMap[activePrayer.key] != true) {
            item {
                val activeTime12 = TimeUtils.formatTo12Hour(activePrayer.time24, isArabic)
                val pName = if (isArabic) activePrayer.nameAr else activePrayer.nameEn
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(24.dp))
                        .background(
                            Brush.horizontalGradient(
                                listOf(Color(0xFFB45309), Color(0xFF92400E))
                            )
                        )
                        .border(1.5.dp, Color(0xFFFDE047), RoundedCornerShape(24.dp))
                        .padding(18.dp)
                ) {
                    Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(
                                imageVector = Icons.Filled.NotificationsActive,
                                contentDescription = null,
                                tint = Color(0xFFFDE047),
                                modifier = Modifier.size(28.dp)
                            )
                            Spacer(modifier = Modifier.width(10.dp))
                            Column(modifier = Modifier.weight(1f)) {
                                Text(
                                    text = if (isArabic) {
                                        "حان الآن وقت صلاة $pName ($activeTime12)"
                                    } else {
                                        "Current Prayer: $pName ($activeTime12)"
                                    },
                                    color = Color.White,
                                    fontWeight = FontWeight.ExtraBold,
                                    fontSize = 17.sp
                                )
                                Text(
                                    text = if (isArabic) {
                                        "يتم تذكيرك كل 10 دقائق ولن يختفي التنبيه إلا بعد الضغط على تمت الصلاة."
                                    } else {
                                        "Reminds you every 10 mins until you confirm praying."
                                    },
                                    color = Color.White.copy(alpha = 0.9f),
                                    fontSize = 12.sp
                                )
                            }
                        }

                        Button(
                            onClick = { onTogglePrayerDone(activePrayer.key, true) },
                            colors = ButtonDefaults.buttonColors(
                                containerColor = Color(0xFF10B981),
                                contentColor = Color.White
                            ),
                            shape = RoundedCornerShape(14.dp),
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            Icon(imageVector = Icons.Filled.CheckCircle, contentDescription = null)
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                text = if (isArabic) "تمت صلاة $pName الحمد لله ✅" else "I Prayed $pName ✅",
                                fontWeight = FontWeight.Bold,
                                fontSize = 15.sp
                            )
                        }
                    }
                }
            }
        }

        // 3. البطاقة الرئيسية: العد التنازلي للصلاة القادمة بنظام 12 ساعة
        item {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(28.dp))
                    .background(
                        Brush.linearGradient(
                            listOf(Color(0xFF065F46), Color(0xFF042F24))
                        )
                    )
                    .border(1.dp, Color(0xFFFBBF24).copy(alpha = 0.5f), RoundedCornerShape(28.dp))
                    .padding(22.dp)
            ) {
                Column(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text(
                        text = if (isArabic) "الصلاة القادمة" else "Next Prayer",
                        color = Color(0xFFA7F3D0),
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Medium
                    )
                    Spacer(modifier = Modifier.height(6.dp))
                    Text(
                        text = "${nextPrayerInfo.first} • ${nextPrayerInfo.second}",
                        color = Color.White,
                        fontSize = 26.sp,
                        fontWeight = FontWeight.ExtraBold
                    )
                    Spacer(modifier = Modifier.height(10.dp))
                    Box(
                        modifier = Modifier
                            .clip(RoundedCornerShape(50))
                            .background(Color.Black.copy(alpha = 0.28f))
                            .border(1.dp, Color(0xFFFDE047).copy(alpha = 0.4f), RoundedCornerShape(50))
                            .padding(horizontal = 22.dp, vertical = 8.dp)
                    ) {
                        Text(
                            text = nextPrayerInfo.third,
                            color = Color(0xFFFDE047),
                            fontSize = 20.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }
            }
        }

        // 4. مؤشر إنجاز الصلوات الخمس اليومي
        item {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(22.dp))
                    .background(Color.White.copy(alpha = 0.06f))
                    .border(1.dp, Color.White.copy(alpha = 0.12f), RoundedCornerShape(22.dp))
                    .padding(16.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = if (isArabic) "متابعة الصلوات الخمس اليوم" else "Daily 5 Prayers Progress",
                        color = Color.White,
                        fontWeight = FontWeight.Bold,
                        fontSize = 15.sp
                    )
                    Text(
                        text = "$completedCount / 5",
                        color = Color(0xFFFDE047),
                        fontWeight = FontWeight.ExtraBold,
                        fontSize = 16.sp
                    )
                }
                Spacer(modifier = Modifier.height(10.dp))
                LinearProgressIndicator(
                    progress = { completedCount / 5f },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(10.dp)
                        .clip(RoundedCornerShape(50)),
                    color = Color(0xFF10B981),
                    trackColor = Color.White.copy(alpha = 0.15f),
                )
            }
        }

        // 5. جدول مواقيت الصلاة بنظام 12 ساعة (ص / م)
        item {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(26.dp))
                    .background(Color.White.copy(alpha = 0.07f))
                    .border(1.dp, Color.White.copy(alpha = 0.14f), RoundedCornerShape(26.dp))
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                if (isLoading && prayers.isEmpty()) {
                    Box(modifier = Modifier.fillMaxWidth().padding(24.dp), contentAlignment = Alignment.Center) {
                        CircularProgressIndicator(color = Color(0xFF10B981))
                    }
                } else {
                    prayers.forEach { item ->
                        val isCurrent = activePrayer?.key == item.key
                        val isDone = prayedMap[item.key] == true
                        val time12 = TimeUtils.formatTo12Hour(item.time24, isArabic)

                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(18.dp))
                                .background(
                                    if (isCurrent) Color(0xFF10B981).copy(alpha = 0.22f)
                                    else Color.White.copy(alpha = 0.04f)
                                )
                                .border(
                                    width = if (isCurrent) 1.5.dp else 1.dp,
                                    color = if (isCurrent) Color(0xFFFDE047) else Color.White.copy(alpha = 0.08f),
                                    shape = RoundedCornerShape(18.dp)
                                )
                                .clickable(enabled = item.isObligatory) {
                                    onTogglePrayerDone(item.key, !isDone)
                                }
                                .padding(horizontal = 16.dp, vertical = 14.dp),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                if (item.isObligatory) {
                                    Icon(
                                        imageVector = if (isDone) Icons.Filled.CheckCircle else Icons.Outlined.RadioButtonUnchecked,
                                        contentDescription = null,
                                        tint = if (isDone) Color(0xFF10B981) else Color.White.copy(alpha = 0.55f),
                                        modifier = Modifier.size(24.dp)
                                    )
                                } else {
                                    Icon(
                                        imageVector = Icons.Filled.WbSunny,
                                        contentDescription = null,
                                        tint = Color(0xFFFBBF24),
                                        modifier = Modifier.size(22.dp)
                                    )
                                }
                                Spacer(modifier = Modifier.width(12.dp))
                                Column {
                                    Text(
                                        text = if (isArabic) item.nameAr else item.nameEn,
                                        color = Color.White,
                                        fontWeight = if (isCurrent) FontWeight.ExtraBold else FontWeight.Bold,
                                        fontSize = 17.sp
                                    )
                                    Text(
                                        text = when {
                                            !item.isObligatory -> if (isArabic) "وقت الشروق (انتهاء الفجر)" else "Sunrise time"
                                            isDone -> if (isArabic) "تمت الصلاة ✅" else "Prayed ✅"
                                            isCurrent -> if (isArabic) "الصلاة الحالية • اضغط لتأكيد الأداء" else "Current • Tap when prayed"
                                            else -> if (isArabic) "اضغط لتعليم تمت الصلاة" else "Tap to mark prayed"
                                        },
                                        color = if (isDone) Color(0xFF6EE7B7) else Color.White.copy(alpha = 0.6f),
                                        fontSize = 11.sp
                                    )
                                }
                            }

                            // عرض الوقت بنظام 12 ساعة واضح وأنيق
                            Box(
                                modifier = Modifier
                                    .clip(RoundedCornerShape(12.dp))
                                    .background(Color.Black.copy(alpha = 0.25f))
                                    .padding(horizontal = 12.dp, vertical = 6.dp)
                            ) {
                                Text(
                                    text = time12,
                                    color = if (isCurrent) Color(0xFFFDE047) else Color.White,
                                    fontWeight = FontWeight.ExtraBold,
                                    fontSize = 16.sp
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

// ============================================================================
// 8. القسم الثاني: شاشة الأذكار وحصن المسلم مع عداد تفاعلي لكل ذكر
// ============================================================================
@Composable
fun AzkarAndHisnScreen(isArabic: Boolean) {
    val view = LocalView.current
    var selectedCategory by remember { mutableStateOf("morning") }
    var countsMap by remember { mutableStateOf(mapOf<Int, Int>()) }

    val categories = listOf(
        "morning" to (if (isArabic) "☀️ أذكار الصباح" else "☀️ Morning"),
        "evening" to (if (isArabic) "🌙 أذكار المساء" else "🌙 Evening"),
        "prayer" to (if (isArabic) "🕌 بعد الصلاة" else "🕌 After Prayer"),
        "hisn" to (if (isArabic) "🛡️ حصن المسلم" else "🛡️ Hisn Al-Muslim")
    )

    val filteredList = hisnAlMuslimAzkar.filter { it.category == selectedCategory }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 16.dp)
    ) {
        LazyRow(
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            modifier = Modifier.padding(vertical = 8.dp)
        ) {
            items(categories) { (catKey, catLabel) ->
                val isSelected = selectedCategory == catKey
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(16.dp))
                        .background(
                            if (isSelected) Color(0xFFFBBF24) else Color.White.copy(alpha = 0.08f)
                        )
                        .clickable { selectedCategory = catKey }
                        .padding(horizontal = 16.dp, vertical = 10.dp)
                ) {
                    Text(
                        text = catLabel,
                        color = if (isSelected) Color(0xFF042F24) else Color.White,
                        fontWeight = FontWeight.Bold,
                        fontSize = 13.sp
                    )
                }
            }
        }

        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(12.dp),
            contentPadding = PaddingValues(vertical = 10.dp)
        ) {
            items(filteredList) { zikr ->
                val currentCount = countsMap[zikr.id] ?: 0
                val isCompleted = currentCount >= zikr.targetCount

                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(22.dp))
                        .background(
                            if (isCompleted) Color(0xFF065F46).copy(alpha = 0.45f)
                            else Color.White.copy(alpha = 0.07f)
                        )
                        .border(
                            1.dp,
                            if (isCompleted) Color(0xFF10B981) else Color.White.copy(alpha = 0.14f),
                            RoundedCornerShape(22.dp)
                        )
                        .clickable {
                            if (currentCount < zikr.targetCount) {
                                view.performHapticFeedback(HapticFeedbackConstants.KEYBOARD_TAP)
                                countsMap = countsMap.toMutableMap().apply {
                                    put(zikr.id, currentCount + 1)
                                }
                            }
                        }
                        .padding(18.dp)
                ) {
                    Text(
                        text = zikr.textAr,
                        color = Color.White,
                        fontSize = 18.sp,
                        lineHeight = 28.sp,
                        fontWeight = FontWeight.Bold
                    )

                    if (!isArabic) {
                        Spacer(modifier = Modifier.height(6.dp))
                        Text(
                            text = zikr.textEn,
                            color = Color.White.copy(alpha = 0.75f),
                            fontSize = 13.sp
                        )
                    }

                    Spacer(modifier = Modifier.height(12.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = if (isArabic) zikr.virtueAr else zikr.virtueEn,
                            color = Color(0xFFA7F3D0),
                            fontSize = 12.sp,
                            modifier = Modifier.weight(1f)
                        )

                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            if (currentCount > 0) {
                                IconButton(
                                    onClick = {
                                        countsMap = countsMap.toMutableMap().apply { put(zikr.id, 0) }
                                    },
                                    modifier = Modifier.size(28.dp)
                                ) {
                                    Icon(
                                        imageVector = Icons.Filled.RestartAlt,
                                        contentDescription = "Reset",
                                        tint = Color.White.copy(alpha = 0.6f)
                                    )
                                }
                            }

                            Box(
                                modifier = Modifier
                                    .clip(RoundedCornerShape(50))
                                    .background(
                                        if (isCompleted) Color(0xFF10B981) else Color(0xFFFBBF24)
                                    )
                                    .padding(horizontal = 16.dp, vertical = 6.dp)
                            ) {
                                Text(
                                    text = if (isCompleted) {
                                        if (isArabic) "اكتمل ✅ ($currentCount/${zikr.targetCount})" else "Done ✅ ($currentCount/${zikr.targetCount})"
                                    } else {
                                        "$currentCount / ${zikr.targetCount}"
                                    },
                                    color = if (isCompleted) Color.White else Color(0xFF042F24),
                                    fontWeight = FontWeight.ExtraBold,
                                    fontSize = 13.sp
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

// ============================================================================
// 9. القسم الثالث: السبحة الإلكترونية الذكية
// ============================================================================
@Composable
fun ElectronicSebhaScreen(context: Context, isArabic: Boolean) {
    val view = LocalView.current
    val phrases = listOf(
        "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ" to "SubhanAllahi wa bihamdihi",
        "سُبْحَانَ اللَّهِ الْعَظِيمِ" to "SubhanAllahil Adheem",
        "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ" to "Alhamdulillah",
        "اللَّهُ أَكْبَرُ" to "Allahu Akbar",
        "لَا إِلَهَ إِلَّا اللَّهُ" to "La ilaha illa Allah",
        "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ" to "Astaghfirullah",
        "اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ" to "Salawat on the Prophet ﷺ",
        "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ" to "La hawla wa la quwwata illa billah"
    )

    var selectedPhraseIndex by remember { mutableIntStateOf(0) }
    var count by remember { mutableIntStateOf(0) }
    var target by remember { mutableIntStateOf(33) }
    var totalLifetime by remember { mutableIntStateOf(AppPrefs.getTotalTasbih(context)) }
    var isPressed by remember { mutableStateOf(false) }

    val scale by animateFloatAsState(
        targetValue = if (isPressed) 0.93f else 1f,
        animationSpec = tween(100),
        label = "sebha_scale"
    )

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(18.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceBetween
    ) {
        // اختيار الذكر
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text(
                text = if (isArabic) "اختر الذكر للتسبيح" else "Select Dhikr",
                color = Color(0xFFA7F3D0),
                fontSize = 13.sp
            )
            Spacer(modifier = Modifier.height(8.dp))
            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                items(phrases.indices.toList()) { idx ->
                    val selected = idx == selectedPhraseIndex
                    Box(
                        modifier = Modifier
                            .clip(RoundedCornerShape(14.dp))
                            .background(
                                if (selected) Color(0xFF10B981) else Color.White.copy(alpha = 0.08f)
                            )
                            .clickable {
                                selectedPhraseIndex = idx
                                count = 0
                            }
                            .padding(horizontal = 14.dp, vertical = 8.dp)
                    ) {
                        Text(
                            text = if (isArabic) phrases[idx].first else phrases[idx].second,
                            color = Color.White,
                            fontWeight = FontWeight.Bold,
                            fontSize = 13.sp
                        )
                    }
                }
            }
        }

        // عرض الذكر الحالي والهدف
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text(
                text = phrases[selectedPhraseIndex].first,
                color = Color(0xFFFDE047),
                fontSize = 24.sp,
                fontWeight = FontWeight.ExtraBold,
                textAlign = TextAlign.Center
            )
            Spacer(modifier = Modifier.height(10.dp))
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                listOf(33, 99, 100, 1000).forEach { t ->
                    Box(
                        modifier = Modifier
                            .clip(RoundedCornerShape(50))
                            .background(
                                if (target == t) Color(0xFFFBBF24) else Color.White.copy(alpha = 0.08f)
                            )
                            .clickable { target = t }
                            .padding(horizontal = 14.dp, vertical = 4.dp)
                    ) {
                        Text(
                            text = "$t",
                            color = if (target == t) Color(0xFF042F24) else Color.White,
                            fontWeight = FontWeight.Bold,
                            fontSize = 13.sp
                        )
                    }
                }
            }
        }

        // زر السبحة الدائري الكبير
        Box(
            modifier = Modifier
                .size(230.dp)
                .scale(scale)
                .clip(CircleShape)
                .background(
                    Brush.radialGradient(
                        listOf(Color(0xFF10B981), Color(0xFF065F46), Color(0xFF042F24))
                    )
                )
                .border(4.dp, Color(0xFFFBBF24), CircleShape)
                .clickable {
                    isPressed = true
                    view.performHapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY)
                    count += 1
                    totalLifetime = AppPrefs.incrementTasbih(context)
                    if (count >= target) {
                        view.performHapticFeedback(HapticFeedbackConstants.LONG_PRESS)
                        count = 0
                    }
                    Handler(Looper.getMainLooper()).postDelayed({ isPressed = false }, 110)
                },
            contentAlignment = Alignment.Center
        ) {
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Text(
                    text = "$count",
                    color = Color.White,
                    fontSize = 64.sp,
                    fontWeight = FontWeight.ExtraBold
                )
                Text(
                    text = if (isArabic) "الهدف: $target" else "Target: $target",
                    color = Color(0xFFFDE047),
                    fontSize = 15.sp,
                    fontWeight = FontWeight.SemiBold
                )
                Spacer(modifier = Modifier.height(6.dp))
                Text(
                    text = if (isArabic) "اضغط للتسبيح" else "Tap to Count",
                    color = Color.White.copy(alpha = 0.7f),
                    fontSize = 12.sp
                )
            }
        }

        // شريط الإحصائيات والتصفير
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(20.dp))
                .background(Color.White.copy(alpha = 0.08f))
                .padding(horizontal = 20.dp, vertical = 14.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(
                    text = if (isArabic) "مجموع تسبيحاتك الكلي" else "Total Lifetime Tasbih",
                    color = Color.White.copy(alpha = 0.7f),
                    fontSize = 12.sp
                )
                Text(
                    text = "$totalLifetime",
                    color = Color(0xFFFDE047),
                    fontSize = 20.sp,
                    fontWeight = FontWeight.ExtraBold
                )
            }

            OutlinedButton(
                onClick = { count = 0 },
                border = ButtonDefaults.outlinedButtonBorder.copy(width = 1.dp),
                colors = ButtonDefaults.outlinedButtonColors(contentColor = Color.White)
            ) {
                Icon(imageVector = Icons.Filled.RestartAlt, contentDescription = null)
                Spacer(modifier = Modifier.width(6.dp))
                Text(text = if (isArabic) "تصفير العداد" else "Reset")
            }
        }
    }
}

// ============================================================================
// 10. القسم الرابع: بوصلة اتجاه القبلة الحية وإعدادات الإشعارات
// ============================================================================
@Composable
fun QiblaCompassScreen(
    userLocation: UserLocation,
    isArabic: Boolean,
    onTestNotification: () -> Unit
) {
    val context = LocalContext.current
    var azimuth by remember { mutableFloatStateOf(0f) }

    val qiblaBearing = remember(userLocation) {
        calculateQiblaBearing(userLocation.lat, userLocation.lon)
    }

    DisposableEffect(context) {
        val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val rotationSensor = sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR)

        val listener = object : SensorEventListener {
            override fun onSensorChanged(event: SensorEvent?) {
                if (event?.sensor?.type == Sensor.TYPE_ROTATION_VECTOR) {
                    val rotationMatrix = FloatArray(9)
                    SensorManager.getRotationMatrixFromVector(rotationMatrix, event.values)
                    val orientation = FloatArray(3)
                    SensorManager.getOrientation(rotationMatrix, orientation)
                    val deg = Math.toDegrees(orientation[0].toDouble()).toFloat()
                    azimuth = (deg + 360f) % 360f
                }
            }
            override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
        }

        if (rotationSensor != null) {
            sensorManager.registerListener(listener, rotationSensor, SensorManager.SENSOR_DELAY_UI)
        }

        onDispose {
            sensorManager.unregisterListener(listener)
        }
    }

    val needleRotation = (qiblaBearing - azimuth + 360f) % 360f
    val isAligned = needleRotation < 12f || needleRotation > 348f

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceBetween
    ) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text(
                text = if (isArabic) "بوصلة اتجاه القبلة الدقيقة" else "Accurate Qibla Compass",
                color = Color.White,
                fontSize = 20.sp,
                fontWeight = FontWeight.ExtraBold
            )
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = if (isArabic) {
                    "زاوية القبلة من ${userLocation.nameAr}: ${qiblaBearing.roundToInt()}° من الشمال"
                } else {
                    "Qibla Angle from ${userLocation.nameEn}: ${qiblaBearing.roundToInt()}° N"
                },
                color = Color(0xFFA7F3D0),
                fontSize = 14.sp
            )
        }

        // رسم البوصلة ومؤشر الكعبة
        Box(
            modifier = Modifier.size(250.dp),
            contentAlignment = Alignment.Center
        ) {
            Canvas(modifier = Modifier.fillMaxSize()) {
                drawCircle(
                    color = if (isAligned) Color(0xFF10B981) else Color(0xFFFBBF24),
                    style = Stroke(width = 8f)
                )
                drawCircle(
                    color = Color.White.copy(alpha = 0.06f)
                )
            }

            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .rotate(needleRotation),
                contentAlignment = Alignment.Center
            ) {
                Canvas(modifier = Modifier.size(200.dp)) {
                    val center = Offset(size.width / 2, size.height / 2)
                    val top = Offset(size.width / 2, 20f)
                    drawLine(
                        color = Color(0xFFFDE047),
                        start = center,
                        end = top,
                        strokeWidth = 12f,
                        cap = StrokeCap.Round
                    )
                }
                Text(
                    text = "🕋",
                    fontSize = 34.sp,
                    modifier = Modifier
                        .align(Alignment.TopCenter)
                        .padding(top = 6.dp)
                )
            }
        }

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(22.dp))
                .background(Color.White.copy(alpha = 0.08f))
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = if (isAligned) {
                    if (isArabic) "أنت الآن متجه نحو القبلة تماماً ✅" else "You are facing the Qibla ✅"
                } else {
                    if (isArabic) "أدر الهاتف حتى تشير الكعبة 🕋 للأعلى" else "Rotate phone until 🕋 points straight up"
                },
                color = if (isAligned) Color(0xFF6EE7B7) else Color.White,
                fontWeight = FontWeight.Bold,
                fontSize = 15.sp
            )
            Spacer(modifier = Modifier.height(12.dp))
            Button(
                onClick = onTestNotification,
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color(0xFF10B981),
                    contentColor = Color.White
                ),
                shape = RoundedCornerShape(14.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                Icon(imageVector = Icons.Outlined.Notifications, contentDescription = null)
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = if (isArabic) "تجربة إشعار الصلاة الآن (نظام 12 ساعة) 🔔" else "Test 12h Prayer Notification 🔔",
                    fontWeight = FontWeight.Bold
                )
            }
        }
    }
}

// ============================================================================
// 11. حسابات العد التنازلي، القبلة، الـ GPS الدقيق، و Aladhan API
// ============================================================================
fun calculateNextPrayerCountdown(
    prayers: List<PrayerItem>,
    isArabic: Boolean
): Triple<String, String, String> {
    val obligatory = prayers.filter { it.isObligatory }
    if (obligatory.isEmpty()) {
        return Triple(
            if (isArabic) "الفجر" else "Fajr",
            if (isArabic) "4:30 ص" else "4:30 AM",
            "--:--:--"
        )
    }

    val cal = Calendar.getInstance()
    val nowSec = cal.get(Calendar.HOUR_OF_DAY) * 3600 +
            cal.get(Calendar.MINUTE) * 60 +
            cal.get(Calendar.SECOND)

    var nextPrayer: PrayerItem? = null
    var targetSec = 0

    for (p in obligatory) {
        val pMin = TimeUtils.parseToMinutes(p.time24) ?: continue
        val pSec = pMin * 60
        if (pSec > nowSec) {
            nextPrayer = p
            targetSec = pSec
            break
        }
    }

    // إذا انتهت صلوات اليوم (بعد العشاء)، فالصلاة القادمة هي فجر الغد
    if (nextPrayer == null) {
        nextPrayer = obligatory.first()
        val fajrMin = TimeUtils.parseToMinutes(nextPrayer.time24) ?: 270
        targetSec = (24 * 3600) + (fajrMin * 60)
    }

    val diffSec = (targetSec - nowSec).coerceAtLeast(0)
    val hours = diffSec / 3600
    val minutes = (diffSec % 3600) / 60
    val seconds = diffSec % 60

    val name = if (isArabic) nextPrayer.nameAr else nextPrayer.nameEn
    val time12 = TimeUtils.formatTo12Hour(nextPrayer.time24, isArabic)
    val countdown = if (isArabic) {
        String.format(Locale.US, "باقي %02d:%02d:%02d", hours, minutes, seconds)
    } else {
        String.format(Locale.US, "In %02d:%02d:%02d", hours, minutes, seconds)
    }

    return Triple(name, time12, countdown)
}

fun calculateQiblaBearing(lat: Double, lon: Double): Float {
    val kaabaLat = Math.toRadians(21.422487)
    val kaabaLon = Math.toRadians(39.826206)
    val userLat = Math.toRadians(lat)
    val userLon = Math.toRadians(lon)

    val dLon = kaabaLon - userLon
    val y = sin(dLon) * cos(kaabaLat)
    val x = cos(userLat) * sin(kaabaLat) - sin(userLat) * cos(kaabaLat) * cos(dLon)
    var brng = Math.toDegrees(atan2(y, x)).toFloat()
    brng = (brng + 360f) % 360f
    return brng
}

@SuppressLint("MissingPermission")
fun fetchAccurateGpsAndCityName(context: Context, onResult: (UserLocation?) -> Unit) {
    val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
    val providers = listOf(
        LocationManager.GPS_PROVIDER,
        LocationManager.NETWORK_PROVIDER,
        LocationManager.PASSIVE_PROVIDER
    )

    var bestLocation: Location? = null
    for (p in providers) {
        try {
            if (locationManager.isProviderEnabled(p)) {
                val loc = locationManager.getLastKnownLocation(p)
                if (loc != null && (bestLocation == null || loc.accuracy < bestLocation.accuracy)) {
                    bestLocation = loc
                }
            }
        } catch (_: Exception) {}
    }

    if (bestLocation != null) {
        resolveExactCityName(context, bestLocation.latitude, bestLocation.longitude, onResult)
        return
    }

    val activeProvider = providers.firstOrNull {
        try { locationManager.isProviderEnabled(it) } catch (_: Exception) { false }
    }

    if (activeProvider == null) {
        onResult(null)
        return
    }

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
        locationManager.getCurrentLocation(
            activeProvider,
            CancellationSignal(),
            ContextCompat.getMainExecutor(context)
        ) { loc ->
            if (loc != null) {
                resolveExactCityName(context, loc.latitude, loc.longitude, onResult)
            } else {
                onResult(null)
            }
        }
    } else {
        locationManager.requestSingleUpdate(activeProvider, object : LocationListener {
            override fun onLocationChanged(location: Location) {
                resolveExactCityName(context, location.latitude, location.longitude, onResult)
            }
            @Deprecated("Deprecated in Java")
            override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
            override fun onProviderEnabled(provider: String) {}
            override fun onProviderDisabled(provider: String) {}
        }, Looper.getMainLooper())
    }
}

/**
 * تحديد اسم المدينة بـ 3 طبقات متتالية لضمان كتابة اسم المدينة الحقيقي دائماً:
 * 1. Android Geocoder المدمج في النظام
 * 2. BigDataCloud Reverse Geocode API (سريع ومجاني ولا يحظر الطلبات)
 * 3. OpenStreetMap Nominatim API
 */
@Suppress("DEPRECATION")
fun resolveExactCityName(
    context: Context,
    lat: Double,
    lon: Double,
    onResult: (UserLocation?) -> Unit
) {
    Thread {
        var cityAr = ""
        var cityEn = ""

        // الطبقة 1: Android Geocoder
        try {
            if (Geocoder.isPresent()) {
                val geoAr = Geocoder(context, Locale("ar"))
                val listAr = geoAr.getFromLocation(lat, lon, 1)
                if (!listAr.isNullOrEmpty()) {
                    val addr = listAr[0]
                    cityAr = (addr.locality ?: addr.subAdminArea ?: addr.adminArea ?: "").trim()
                }

                val geoEn = Geocoder(context, Locale.ENGLISH)
                val listEn = geoEn.getFromLocation(lat, lon, 1)
                if (!listEn.isNullOrEmpty()) {
                    val addr = listEn[0]
                    cityEn = (addr.locality ?: addr.subAdminArea ?: addr.adminArea ?: "").trim()
                }
            }
        } catch (_: Exception) {}

        // الطبقة 2: BigDataCloud API في حال لم يرجع الـ Geocoder اسم المدينة
        if (cityAr.isBlank() || cityEn.isBlank()) {
            try {
                val urlAr = URL("https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$lat&longitude=$lon&localityLanguage=ar")
                val jsonAr = JSONObject(urlAr.readText())
                if (cityAr.isBlank()) {
                    cityAr = jsonAr.optString("city")
                        .ifBlank { jsonAr.optString("locality") }
                        .ifBlank { jsonAr.optString("principalSubdivision") }
                }

                val urlEn = URL("https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$lat&longitude=$lon&localityLanguage=en")
                val jsonEn = JSONObject(urlEn.readText())
                if (cityEn.isBlank()) {
                    cityEn = jsonEn.optString("city")
                        .ifBlank { jsonEn.optString("locality") }
                        .ifBlank { jsonEn.optString("principalSubdivision") }
                }
            } catch (_: Exception) {}
        }

        // الطبقة 3: OpenStreetMap Nominatim API
        if (cityAr.isBlank() || cityEn.isBlank()) {
            try {
                val connAr = (URL("https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&accept-language=ar").openConnection() as HttpURLConnection).apply {
                    setRequestProperty("User-Agent", "SalahAndroidApp/3.0")
                    connectTimeout = 5000
                    readTimeout = 5000
                }
                val addrAr = JSONObject(connAr.inputStream.bufferedReader().use { it.readText() }).optJSONObject("address")
                if (addrAr != null && cityAr.isBlank()) {
                    cityAr = addrAr.optString("city")
                        .ifBlank { addrAr.optString("town") }
                        .ifBlank { addrAr.optString("village") }
                        .ifBlank { addrAr.optString("state") }
                }
            } catch (_: Exception) {}
        }

        if (cityAr.isBlank()) cityAr = "موقعي الحالي"
        if (cityEn.isBlank()) cityEn = "My Location"

        Handler(Looper.getMainLooper()).post {
            onResult(UserLocation(cityAr, cityEn, lat, lon))
        }
    }.start()
}

fun loadCachedPrayersList(context: Context): List<PrayerItem> {
    val defaults = mapOf(
        "Fajr" to "04:45",
        "Sunrise" to "06:12",
        "Dhuhr" to "12:05",
        "Asr" to "15:25",
        "Maghrib" to "17:58",
        "Isha" to "19:18"
    )
    return PrayerReminderHelper.allPrayerDefs.map { def ->
        val t = AppPrefs.getCachedPrayerTime24(context, def.first) ?: defaults[def.first] ?: "12:00"
        PrayerItem(def.first, def.second, def.third, t, def.first != "Sunrise")
    }
}

suspend fun fetchPrayerTimesFromAladhan(
    context: Context,
    lat: Double,
    lon: Double
): Triple<List<PrayerItem>, String, String> = withContext(Dispatchers.IO) {
    try {
        val url = URL("https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lon&method=5")
        val conn = (url.openConnection() as HttpURLConnection).apply {
            requestMethod = "GET"
            connectTimeout = 8000
            readTimeout = 8000
        }
        val response = conn.inputStream.bufferedReader().use { it.readText() }
        val dataObj = JSONObject(response).getJSONObject("data")
        val timings = dataObj.getJSONObject("timings")
        val dateObj = dataObj.getJSONObject("date")
        val hijriObj = dateObj.getJSONObject("hijri")

        val dayNum = hijriObj.optString("day", "")
        val monthAr = hijriObj.getJSONObject("month").optString("ar", "")
        val monthEn = hijriObj.getJSONObject("month").optString("en", "")
        val yearNum = hijriObj.optString("year", "")
        val weekdayAr = hijriObj.getJSONObject("weekday").optString("ar", "")
        val weekdayEn = hijriObj.getJSONObject("weekday").optString("en", "")

        val hijriAr = "$weekdayAr، $dayNum $monthAr $yearNum هـ"
        val hijriEn = "$weekdayEn, $dayNum $monthEn $yearNum AH"

        val items = PrayerReminderHelper.allPrayerDefs.map { def ->
            val raw = timings.optString(def.first, "12:00").substringBefore(" ").trim()
            PrayerItem(def.first, def.second, def.third, raw, def.first != "Sunrise")
        }

        AppPrefs.savePrayerTimings(context, items, hijriAr, hijriEn)
        Triple(items, hijriAr, hijriEn)
    } catch (_: Exception) {
        val cached = loadCachedPrayersList(context)
        Triple(
            cached,
            AppPrefs.getSavedHijri(context, true),
            AppPrefs.getSavedHijri(context, false)
        )
    }
}
KOTLIN_EOF

# 10. تحديث ملف GitHub Actions لتوليد ملف APK باسم Salah-App-APK
cat << 'WORKFLOW_EOF' > .github/workflows/android-build.yml
name: Build Salah App APK

on:
  push:
    branches: [ "main", "master" ]
  pull_request:
    branches: [ "main", "master" ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Setup Gradle
        uses: gradle/actions/setup-gradle@v3
        with:
          gradle-version: '8.4'

      - name: Build Debug APK
        run: gradle assembleDebug

      - name: Upload APK Artifact
        uses: actions/upload-artifact@v4
        with:
          name: Salah-App-APK
          path: app/build/outputs/apk/debug/app-debug.apk
WORKFLOW_EOF

echo "✅ تم بناء مشروع تطبيق (صلاة - Salah) بالكامل بنجاح!"
