import 'package:onesignal_flutter/onesignal_flutter.dart';

const oneSignalAppId = "";

Future<void> initOneSignal() async {
  OneSignal.initialize('c4d95506-f931-4d7c-9f02-793f2cbe76c2');
  OneSignal.Notifications.requestPermission(true).then((value) {});
}

void registerOneSignalEventListener({
  required Function(OSNotificationClickEvent) onOpened,
  required Function(OSNotificationClickResult) onReceivedInForeground,
}) {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("c4d95506-f931-4d7c-9f02-793f2cbe76c2");
  OneSignal.Notifications.requestPermission(true);
}

const tagName = "userId";

void sendUserTag(int schoolId) {
  OneSignal.User.addTagWithKey("schoolId", schoolId);
}

void deleteUserTag() {
  OneSignal.User.removeTag("userId");
}
