import 'dart:developer' as developer;

void debugLog(String message) {
  developer.log(message, name: 'log');
}

void debugLogWarning(String message) {
  developer.log(message, name: 'warning');
}

void debugLogError(String message, [Object error, StackTrace stackTrace]) {
  developer.log(
    message,
    name: 'error',
    error: error,
    stackTrace: stackTrace,
  );
}
