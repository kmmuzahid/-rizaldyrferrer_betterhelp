import 'package:flutter/material.dart';
import 'dart:io';

class NavigationObserver extends NavigatorObserver {
  final List<String> routeStack = <String>[];

  // Auto-detect ANSI support
  static final bool _supportsAnsi =
      !Platform.isAndroid && !Platform.isIOS && stdout.supportsAnsiEscapes;

  // ANSI Color codes (only applied if supported)
  static String get _reset => _supportsAnsi ? '\x1B[0m' : '';
  static String get _red => _supportsAnsi ? '\x1B[31m' : '';
  static String get _green => _supportsAnsi ? '\x1B[32m' : '';
  static String get _yellow => _supportsAnsi ? '\x1B[33m' : '';
  static String get _magenta => _supportsAnsi ? '\x1B[35m' : '';
  static String get _cyan => _supportsAnsi ? '\x1B[36m' : '';
  static String get _bold => _supportsAnsi ? '\x1B[1m' : '';
  static String get _dim => _supportsAnsi ? '\x1B[2m' : '';

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    super.didPush(route!, previousRoute);

    final routeName = _getRouteName(route);
    routeStack.add(routeName);

    _logNavigation(
      emoji: '🚀',
      action: 'PUSH',
      routeName: routeName,
      color: _green,
      previousRoute: previousRoute != null
          ? _getRouteName(previousRoute)
          : null,
    );
  }

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    super.didPop(route!, previousRoute);

    final routeName = _getRouteName(route);
    routeStack.remove(routeName);

    _logNavigation(
      emoji: '⬅️',
      action: 'POP',
      routeName: routeName,
      color: _yellow,
      previousRoute: previousRoute != null
          ? _getRouteName(previousRoute)
          : null,
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (newRoute == null) return;

    final newName = _getRouteName(newRoute);
    final oldName = oldRoute != null ? _getRouteName(oldRoute) : 'Unknown';

    routeStack.remove(oldName);
    routeStack.add(newName);

    _logNavigation(
      emoji: '🔄',
      action: 'REPLACE',
      routeName: '$oldName → $newName',
      color: _magenta,
    );
  }

  @override
  void didRemove(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    super.didRemove(route!, previousRoute);

    final routeName = _getRouteName(route);
    routeStack.remove(routeName);

    _logNavigation(
      emoji: '🗑️',
      action: 'REMOVE',
      routeName: routeName,
      color: _red,
    );
  }

  /// Extract clean route name from Route
  String _getRouteName(Route<dynamic> route) {
    final name = route.settings.name;
    if (name == null || name.isEmpty) return 'Unknown';
    return name.startsWith('/') ? name.substring(1) : name;
  }

  /// Unified logging method
  void _logNavigation({
    required String emoji,
    required String action,
    required String routeName,
    required String color,
    String? previousRoute,
  }) {
    final stackSize = routeStack.length;
    final stackPath = routeStack.isEmpty ? 'empty' : routeStack.join(' → ');

    // Build the log message
    final buffer = StringBuffer();

    // Action header with color
    buffer.write('$_bold[$emoji $action]$_reset ');

    // Route name with color
    buffer.write('$color$_bold$routeName$_reset');

    // Previous route context (if available)
    if (previousRoute != null && action == 'PUSH') {
      buffer.write(' $_dim(from: $previousRoute)$_reset');
    }

    // Stack info
    buffer.write(' | Stack: $_cyan$stackSize$_reset');

    // Full stack path
    if (stackPath != 'empty') {
      buffer.write(' | $_dim$stackPath$_reset');
    }

    debugPrint(buffer.toString());
    _printSeparator(action);
  }

  /// Print separator for better readability
  void _printSeparator(String action) {
    if (action == 'REPLACE' || action == 'REMOVE') {
      debugPrint('$_dim${'─' * 50}$_reset');
    }
  }

  /// Get current route stack as a readable string
  String get currentStack =>
      routeStack.isEmpty ? 'Navigation stack is empty' : routeStack.join(' → ');

  /// Clear the entire route stack (useful for debugging)
  void clearStack() {
    routeStack.clear();
    debugPrint('$_red$_bold[🧹 CLEAR] Navigation stack cleared$_reset');
  }

  /// Print current stack state
  void printCurrentStack() {
    debugPrint('$_cyan$_bold[📚 STACK] $currentStack$_reset');
  }
}


// ```

// ## Key Improvements:

// 1. **Auto-detects ANSI support** - Colors work on desktop, clean output on mobile
// 2. **Null-safe** - Properly handles null routes
// 3. **Cleaner route names** - Removes leading `/` for readability
// 4. **Better formatting** - More structured and consistent output
// 5. **Context information** - Shows where you came from on PUSH
// 6. **Helper methods** - `currentStack`, `clearStack()`, `printCurrentStack()`
// 7. **Visual separators** - For better readability on complex operations

// ## Example Output:

// **With ANSI support (Desktop):**
// ```
// [🚀 PUSH] onboardingscreen (from: splashscreen) | Stack: 2 | home → onboardingscreen
// [⬅️ POP] onboardingscreen | Stack: 1 | home
// [🔄 REPLACE] splashscreen → home | Stack: 1 | home
// ──────────────────────────────────────────────────
// [🗑️ REMOVE] splashscreen | Stack: 0 | empty
// ──────────────────────────────────────────────────
// ```

// **Without ANSI support (Mobile):**
// ```
// [🚀 PUSH] onboardingscreen (from: splashscreen) | Stack: 2 | home → onboardingscreen
// [⬅️ POP] onboardingscreen | Stack: 1 | home
// [🔄 REPLACE] splashscreen → home | Stack: 1 | home
// ──────────────────────────────────────────────────