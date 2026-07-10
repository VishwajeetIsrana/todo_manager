# Flutter specific ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }

# Keep method channel related classes
-keepnames class * implements io.flutter.plugin.common.MethodChannel$MethodCallHandler
-keepnames class * implements io.flutter.plugin.common.EventChannel$StreamHandler

# Keep serialization/JSON parsing classes
-keepattributes Signature
-keepattributes *Annotation*
