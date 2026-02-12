# Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.ryanheise.audioservice.** { *; }
-keep class com.google.android.gms.ads.** { *; }

# Add standard Flutter Proguard rules
-keep class io.flutter.embedding.engine.FlutterJNI { *; }
-keep class io.flutter.embedding.engine.loader.FlutterLoader { *; }
-keep class io.flutter.view.FlutterMain { *; }
-keep class io.flutter.view.FlutterView { *; }
-keep class io.flutter.app.FlutterActivity { *; }
-keep class io.flutter.app.FlutterApplication { *; }
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
-dontwarn io.flutter.embedding.**
-ignorewarnings
