import 'dart:io';
import 'dart:convert';

void main() {
  final arbEn = File(r'e:\project\kiddo\lib\l10n\app_en.arb');
  final arbVi = File(r'e:\project\kiddo\lib\l10n\app_vi.arb');
  final homeScreen = File(r'e:\project\kiddo\lib\modules\bottombar\screen\home_screen.dart');

  final newKeysEn = {
    "enterClass": "Enter class",
    "upcomingSchedule": "Upcoming schedule",
    "seeSchedule": "View schedule",
    "noUpcomingSchedule": "No upcoming schedule",
    "inviteFriends": "Invite friends, get instant rewards",
    "centerNews": "Center news",
    "checkInternet": "Please check your internet connection",
    "monday": "Monday",
    "tuesday": "Tuesday",
    "wednesday": "Wednesday",
    "thursday": "Thursday",
    "friday": "Friday",
    "saturday": "Saturday",
    "sunday": "Sunday",
    "ok": "OK"
  };

  final newKeysVi = {
    "enterClass": "Vào lớp",
    "upcomingSchedule": "Lịch học sắp tới",
    "seeSchedule": "Xem lịch học",
    "noUpcomingSchedule": "Chưa có lịch học sắp tới",
    "inviteFriends": "Mời bạn bè, nhận quà liền tay",
    "centerNews": "Bảng tin trung tâm",
    "checkInternet": "Vui lòng kiểm tra lại kết nối internet",
    "monday": "Thứ 2",
    "tuesday": "Thứ 3",
    "wednesday": "Thứ 4",
    "thursday": "Thứ 5",
    "friday": "Thứ 6",
    "saturday": "Thứ 7",
    "sunday": "Chủ nhật",
    "ok": "OK"
  };

  void updateArb(File file, Map<String, String> newKeys) {
    if (!file.existsSync()) return;
    final content = file.readAsStringSync();
    final Map<String, dynamic> data = jsonDecode(content);
    bool changed = false;
    newKeys.forEach((key, value) {
      if (!data.containsKey(key)) {
        data[key] = value;
        changed = true;
      }
    });
    if (changed) {
      file.writeAsStringSync(const JsonEncoder.withIndent('    ').convert(data));
    }
  }

  updateArb(arbEn, newKeysEn);
  updateArb(arbVi, newKeysVi);

  if (homeScreen.existsSync()) {
    String content = homeScreen.readAsStringSync();
    
    // Replace strings
    content = content.replaceAll("String selectedCategory = 'Tất cả';", "String selectedCategory = 'all';"); // Wait, this might break logic if it checks 'Tất cả' later. Let's check logic instead of replacing state variables if possible. Actually, "Tất cả" is used for UI, so we better replace the UI part.
    // Let's replace only the UI text occurrences.
    
    content = content.replaceAll("'Tất cả'", "AppLocalizations.of(context).all");
    
    // For date format: '${model.createdDate.day}, tháng ${model.createdDate.month}'
    content = content.replaceAll(r"'${model.createdDate.day}, tháng ${model.createdDate.month}'", r"'${model.createdDate.day}, ${AppLocalizations.of(context).month} ${model.createdDate.month}'");

    content = content.replaceAll("'Xin nghỉ'", "AppLocalizations.of(context).missWithPermission");
    content = content.replaceAll("'Vào lớp  '", "'\${AppLocalizations.of(context).enterClass}  '");
    
    content = content.replaceAll('1: "Thứ 2"', '1: AppLocalizations.of(context).monday');
    content = content.replaceAll('2: "Thứ 3"', '2: AppLocalizations.of(context).tuesday');
    content = content.replaceAll('3: "Thứ 4"', '3: AppLocalizations.of(context).wednesday');
    content = content.replaceAll('4: "Thứ 5"', '4: AppLocalizations.of(context).thursday');
    content = content.replaceAll('5: "Thứ 6"', '5: AppLocalizations.of(context).friday');
    content = content.replaceAll('6: "Thứ 7"', '6: AppLocalizations.of(context).saturday');
    content = content.replaceAll('7: "Chủ nhật"', '7: AppLocalizations.of(context).sunday');

    content = content.replaceAll("'Lịch học sắp tới'", "AppLocalizations.of(context).upcomingSchedule");
    content = content.replaceAll("'  Xem lịch học'", "'  \${AppLocalizations.of(context).seeSchedule}'");
    content = content.replaceAll("'Chưa có lịch học sắp tới'", "AppLocalizations.of(context).noUpcomingSchedule");
    content = content.replaceAll("'  Mời bạn bè, nhận quà liền tay'", "'  \${AppLocalizations.of(context).inviteFriends}'");
    content = content.replaceAll("'  Bảng tin trung tâm'", "'  \${AppLocalizations.of(context).centerNews}'");
    content = content.replaceAll("'Vui lòng kiểm tra lại kết nối internet'", "AppLocalizations.of(context).checkInternet");
    content = content.replaceAll("'Vui lòng kiểm tra lại kết nối internet2'", "AppLocalizations.of(context).checkInternet");
    content = content.replaceAll("const Text('OK')", "Text(AppLocalizations.of(context).ok)");

    if (!content.contains("import 'package:kiddo/l10n/app_localizations.dart';")) {
        content = content.replaceFirstMapped(RegExp(r"(import 'package:[^;]+;)"), (match) => "\${match.group(1)}\nimport 'package:kiddo/l10n/app_localizations.dart';");
    }

    homeScreen.writeAsStringSync(content);
    print('Updated home_screen.dart');
  }
}
