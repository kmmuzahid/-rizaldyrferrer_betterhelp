# Keep Java 8+ API desugaring classes (like java.time / j$.time)
-keep class j$.** { *; }
-dontwarn j$.**
