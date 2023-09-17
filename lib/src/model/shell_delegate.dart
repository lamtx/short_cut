import 'supported_platform.dart';

typedef Action = void Function(String args);

/// Handle shell command internally in dart code.
/// It's useful when some shell commands are available on this platform but not available on other platforms.
///
class ShellDelegate {
  const ShellDelegate({
    required this.handle,
    this.supports = SupportedPlatform.values,
  });

  final List<SupportedPlatform> supports;
  final Action handle;
}
