# Flutter specific ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep plugin classes explicitly (Registered in GeneratedPluginRegistrant)
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }

# Keep method channel related classes
-keepnames class * implements io.flutter.plugin.common.MethodChannel$MethodCallHandler
-keepnames class * implements io.flutter.plugin.common.EventChannel$StreamHandler

# Keep serialization/JSON parsing classes
-keepattributes Signature
-keepattributes *Annotation*

# Flutter's PlayStoreDeferredComponentManager references Play Core (optional)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
