import 'dart:ui';

String getDeviceLanguage() {
  return PlatformDispatcher.instance.locale.languageCode;
}
