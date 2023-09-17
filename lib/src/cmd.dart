import 'model/command_spec.dart';
import 'model/condition.dart';

const cmd = {
  "pull": SubCommand(
    desc: "Get files from the device.",
    cmd: {
      "config": Command(
        desc: "Get file config.json from the device.",
        script: [
          "adb pull /sdcard/TBS/config.json",
          "open config.json",
        ],
      ),
      "log": Command(
        desc: "Get all logs from the device.",
        script: [
          "rmdir Log",
          "mkdir Log",
          "adb pull /sdcard/TBS/Log",
        ],
      )
    },
  ),
  "push": SubCommand(
    desc: "Push files to the device.",
    cmd: {
      "config": Command(
        desc: "Push file config.json from current directory to device.",
        script: [
          "adb push config.json /sdcard/TBS/",
          "adb shell am broadcast -a com.mobilehelp.action.config.updated",
        ],
        conditions: [
          Condition.fileExists("config.json"),
        ],
      ),
    },
  ),
  "clear": SubCommand(
    desc: "Remove files from the device.",
    cmd: {
      "log": Command(
        desc: "Remove all logs from the device.",
        script: [
          "adb shell rm -rf /sdcard/TBS/Log/*",
        ],
      ),
    },
  ),
  "am": SubCommand(
    desc: "Run am (activity manager) commands",
    cmd: {
      "register": Command(
        desc: "Register device.",
        params: {
          "1": "phone number",
          "2": "one time token",
        },
        script: [
          "adb shell am start -n com.mobilehelp.alert/.ui.registration.WelcomeActivity -a com.mobilehelp.auto.register --es phone {{1}} --es token {{2}}",
        ],
      ),
      "433": Command(
        desc: "Fake packet 433 sent.",
        params: {
          "dui": "DUI.",
          "address": "Pendant address.",
          "signal": "Signal.",
        },
        script: [
          "adb shell am start -n com.mobilehelp.stub.i2c/.services.I2CService -a fake --es dui {{dui}} --es address {{address}} --es signal {{signal}}",
        ],
      ),
    },
  ),
};
