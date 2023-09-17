import 'dart:io';

import '../model/shell_delegate.dart';
import '../model/supported_platform.dart';

final SupportedPlatform? currentSupportedPlatform =
    _getCurrentSupportedPlatform();

SupportedPlatform? _getCurrentSupportedPlatform() {
  if (Platform.isWindows) {
    return SupportedPlatform.windows;
  } else if (Platform.isMacOS) {
    return SupportedPlatform.macos;
  } else if (Platform.isLinux) {
    return SupportedPlatform.linux;
  } else {
    return null;
  }
}

extension SupportedShellDelegate on ShellDelegate {
  bool get isSupported =>
      currentSupportedPlatform != null &&
      supports.contains(currentSupportedPlatform);
}
