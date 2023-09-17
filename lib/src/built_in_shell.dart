import 'model/shell_delegate.dart';
import 'model/supported_platform.dart';
import 'service/shell_delegates/mkdir.dart';
import 'service/shell_delegates/open.dart';
import 'service/shell_delegates/rmdir.dart';

const builtInShell = {
  "open": ShellDelegate(
    handle: open,
    supports: [SupportedPlatform.windows],
  ),
  "rmdir": ShellDelegate(handle: rmdir),
  "mkdir": ShellDelegate(handle: mkdir),
};
