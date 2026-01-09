import 'dart:io';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:flutter/material.dart';

class NavigationObserver extends NavigatorObserver {
  final List<String> routeStack = <String>[];

  // ANSI Color codes
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';
  static const String _bold = '\x1B[1m';

  // Check if terminal supports colors
  static final bool _supportsAnsi = () {
    try {
      return stdout.supportsAnsiEscapes;
    } catch (e) {
      return false;
    }
  }();

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    final routeName = route.settings.name ?? 'Unknown';
    routeStack.add(routeName);
    _printColored(
      '🚀 PUSH',
      '$_green$_bold${routeName.replaceAll('/', '')}$_reset',
      'Stack: ${routeStack.length}',
      'Full: $_cyan${routeStack.join(' → ')}$_reset',
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    final routeName = route.settings.name ?? 'Unknown';
    routeStack.remove(routeName);
    _printColored(
      '⬅️  POP',
      '$_yellow$_bold${routeName.replaceAll('/', '')}$_reset',
      'Stack: ${routeStack.length}',
      'Remaining: $_cyan${routeStack.join(' → ')}$_reset',
    );
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      final newName = newRoute.settings.name ?? 'Unknown';
      final oldName = oldRoute?.settings.name ?? 'Unknown';
      routeStack.remove(oldName);
      routeStack.add(newName);
      _printColored(
        '🔄 REPLACE',
        '$_magenta$oldName$_reset → $_green$_bold$newName$_reset',
        'Stack: ${routeStack.length}',
        'Full: $_cyan${routeStack.join(' → ')}$_reset',
      );
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    final routeName = route.settings.name ?? 'Unknown';
    routeStack.remove(routeName);
    _printColored(
      '🗑️  REMOVE',
      '$_red$_bold$routeName$_reset',
      'Stack: ${routeStack.length}',
      'Remaining: $_cyan${routeStack.join(' → ')}$_reset',
    );
  }

  void _printColored(
    String action,
    String routeInfo,
    String stackInfo,
    String fullStack,
  ) {
    if (_supportsAnsi) {
      // Print with colors
      appLog('$_bold[$action]$_reset $routeInfo | $stackInfo | $fullStack');
    } else {
      // Fallback: strip ANSI codes and print plain text
      final plainAction = '[$action]';
      final plainRoute = _stripAnsi(routeInfo);
      final plainStack = _stripAnsi(stackInfo);
      final plainFull = _stripAnsi(fullStack);
      appLog('$plainAction $plainRoute | $plainStack | $plainFull');
    }
  }

  // Strip ANSI escape codes from a string
  String _stripAnsi(String text) {
    return text.replaceAll(RegExp(r'\x1B\[[0-9;]*m'), '');
  }
}
