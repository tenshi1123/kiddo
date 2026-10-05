import 'dart:io';

void main() {
  final file = File(r'e:\project\kiddo\lib\modules\bottombar\screen\home_screen.dart');
  List<String> lines = file.readAsLinesSync();

  // Replace height: 90.h, to 100.h, at around line 542
  for (int i = 500; i < 600; i++) {
    if (lines[i].contains('height: 90.h,')) {
      lines[i] = lines[i].replaceAll('height: 90.h,', 'height: 100.h,');
      break;
    }
  }

  // Replace _homeIcon text at around line 274-280
  for (int i = 250; i < 300; i++) {
    if (lines[i].contains('style: defaultText12B,')) {
      // Add textAlign and maxLines
      lines.insert(i + 1, '            textAlign: TextAlign.center,');
      lines.insert(i + 2, '            maxLines: 2,');
      lines.insert(i + 3, '            overflow: TextOverflow.ellipsis,');
      break;
    }
  }

  // Replace Row at 364-425
  // We find "Row(" after "DateFormat('EEEE').format(model.createdDate),"
  int startIdx = -1;
  int endIdx = -1;
  for (int i = 350; i < 400; i++) {
    if (lines[i].contains('Row(') && lines[i+1].contains('mainAxisAlignment: MainAxisAlignment.spaceBetween,')) {
      startIdx = i;
      break;
    }
  }
  
  if (startIdx != -1) {
    // Find the matching bracket for Row
    int brackets = 0;
    for (int i = startIdx; i < lines.length; i++) {
      brackets += '\\('.allMatches(lines[i]).length;
      brackets -= '\\)'.allMatches(lines[i]).length;
      if (brackets == 0 && lines[i].contains('),')) {
        endIdx = i;
        break;
      }
    }
  }

  if (startIdx != -1 && endIdx != -1) {
    final newRow = '''            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showLeaveReasonDialog(context,
                          typeLearn: model.typeLearn,
                          checkinOffId: model.checkinOffId ?? '',
                          meetingId: model.meetingId ?? '');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: mainRed.withValues(alpha: 0.02),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.r),
                        ),
                        border: Border.all(
                          color: mainRed.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).missWithPermission,
                          style: defaultText14B.copyWith(
                            color: mainRed,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: mainGreen,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            '\${AppLocalizations.of(context).enterClass}  ',
                            style: defaultText14B.copyWith(
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/icons/sign_out.svg',
                          width: 16.w,
                          height: 16.h,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),''';

    lines.removeRange(startIdx, endIdx + 1);
    lines.insert(startIdx, newRow);
  }

  file.writeAsStringSync(lines.join('\n'));
  print('Done applying fixes.');
}
