import os
import json
import re

# Update arb files
arb_en = r"e:\project\kiddo\lib\l10n\app_en.arb"
arb_vi = r"e:\project\kiddo\lib\l10n\app_vi.arb"

new_keys_en = {
    "chooseFile": "Choose file",
    "choosePhotoFromLibrary": "Choose photo from library",
    "takePhoto": "Take a photo",
    "error": "Error",
    "noNotification": "No notification",
    "cannotLoadData": "Cannot load data",
    "redeemSuccess": "Redeem successful",
    "photoLibraryAccessDenied": "Photo library access denied.",
    "savedQrToGallery": "QR code saved to gallery!",
    "cannotCaptureWidget": "Cannot capture widget.",
    "noDataOrLoadFailed": "No data or load failed"
}

new_keys_vi = {
    "chooseFile": "Chọn file",
    "choosePhotoFromLibrary": "Chọn ảnh từ thư viện",
    "takePhoto": "Chụp ảnh",
    "error": "Lỗi",
    "noNotification": "Không có thông báo",
    "cannotLoadData": "Không thể tải dữ liệu",
    "redeemSuccess": "Đổi quà thành công",
    "photoLibraryAccessDenied": "Quyền truy cập thư viện ảnh bị từ chối.",
    "savedQrToGallery": "Đã lưu ảnh mã QR vào thư viện ảnh!",
    "cannotCaptureWidget": "Không thể chụp ảnh widget.",
    "noDataOrLoadFailed": "Không có dữ liệu hoặc tải thất bại"
}

def update_arb(file_path, new_keys):
    with open(file_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    for k, v in new_keys.items():
        if k not in data:
            data[k] = v
            
    with open(file_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

update_arb(arb_en, new_keys_en)
update_arb(arb_vi, new_keys_vi)

# Replacements in files
replacements = {
    r"e:\project\kiddo\lib\utils\widget\webview_screen.dart": [
        ("const Text('Mở trình duyệt')", "Text(AppLocalizations.of(context)!.openWeb)")
    ],
    r"e:\project\kiddo\lib\utils\widget\upload_document_dialog.dart": [
        ("const Text('Chọn file')", "Text(AppLocalizations.of(context)!.chooseFile)"),
        ("const Text('Chọn ảnh từ thư viện')", "Text(AppLocalizations.of(context)!.choosePhotoFromLibrary)"),
        ("const Text('Chụp ảnh')", "Text(AppLocalizations.of(context)!.takePhoto)"),
        ("const Text('Thông báo')", "Text(AppLocalizations.of(context)!.notification)")
    ],
    r"e:\project\kiddo\lib\utils\widget\custom_dialog.dart": [
        ("const Text('Hủy')", "Text(AppLocalizations.of(context)!.cancel)"),
        ("const Text('Xác nhận')", "Text(AppLocalizations.of(context)!.confirm)")
    ],
    r"e:\project\kiddo\lib\teacher_modules\teacher_info\teacher_info.dart": [
        ("const Text('Hủy')", "Text(AppLocalizations.of(context)!.cancel)"),
        ("const Text('Xác nhận')", "Text(AppLocalizations.of(context)!.confirm)")
    ],
    r"e:\project\kiddo\lib\teacher_modules\teacher_bottombar\screen\list_class\list_teacher_class.dart": [
        ("const Text(\"Lỗi\")", "Text(AppLocalizations.of(context)!.error)"),
        ('Text("Có lỗi xảy ra: $e")', 'Text("${AppLocalizations.of(context)!.error}: $e")')
    ],
    r"e:\project\kiddo\lib\teacher_modules\teacher_bottombar\screen\detail_rollcall.dart": [
        ("const Text(\"Lỗi\")", "Text(AppLocalizations.of(context)!.error)"),
        ('Text("Có lỗi xảy ra: $errorMessage")', 'Text("${AppLocalizations.of(context)!.error}: $errorMessage")'),
        ("const Text(\"Thành công\")", "Text(AppLocalizations.of(context)!.success)")
    ],
    r"e:\project\kiddo\lib\modules\notification\notification.dart": [
        ('Text("Không có thông báo")', "Text(AppLocalizations.of(context)!.noNotification)")
    ],
    r"e:\project\kiddo\lib\modules\login\teacher_login_screen.dart": [
        ("const Text('Vui lòng thử lại')", "Text(AppLocalizations.of(context)!.pleaseTryAgain)")
    ],
    r"e:\project\kiddo\lib\modules\login\student_login_screen.dart": [
        ("const Text('Vui lòng thử lại')", "Text(AppLocalizations.of(context)!.pleaseTryAgain)")
    ],
    r"e:\project\kiddo\lib\modules\lesson\detail_lesson_screen.dart": [
        ("Text('Không thể tải dữ liệu')", "Text(AppLocalizations.of(context)!.cannotLoadData)")
    ],
    r"e:\project\kiddo\lib\modules\infoAccount\redeem_reward_screen.dart": [
        ("Text('Thông báo')", "Text(AppLocalizations.of(context)!.notification)"),
        ("Text('Đổi quà thành công')", "Text(AppLocalizations.of(context)!.redeemSuccess)")
    ],
    r"e:\project\kiddo\lib\modules\feature_home\hoc_phi\thanh_toan_screen.dart": [
        ("Text('Quyền truy cập thư viện ảnh bị từ chối.')", "Text(AppLocalizations.of(context)!.photoLibraryAccessDenied)"),
        ('Text("Đã lưu ảnh mã QR vào thư viện ảnh!")', "Text(AppLocalizations.of(context)!.savedQrToGallery)"),
        ('Text("Không thể chụp ảnh widget.")', "Text(AppLocalizations.of(context)!.cannotCaptureWidget)"),
        ('Text("Lỗi: $e")', 'Text("${AppLocalizations.of(context)!.error}: $e")')
    ],
    r"e:\project\kiddo\lib\modules\feature_home\hoc_lieu\list_hoc_lieu.dart": [
        ("const Text('Thông báo')", "Text(AppLocalizations.of(context)!.notification)"),
        ("const Text('Đóng')", "Text(AppLocalizations.of(context)!.close)")
    ],
    r"e:\project\kiddo\lib\modules\feature_home\exercise\test_detail_screen.dart": [
        ("const Text('Bạn có chắc chắn muốn nộp bài')", "Text(AppLocalizations.of(context)!.confirmSubmit)")
    ],
    r"e:\project\kiddo\lib\modules\feature_home\evaluate\detail_evaluate_screen2.dart": [
        ('Text("Không có dữ liệu hoặc tải thất bại")', "Text(AppLocalizations.of(context)!.noDataOrLoadFailed)")
    ],
    r"e:\project\kiddo\lib\modules\chat\chat_screen.dart": [
        ("const Text('Tin nhắn đã được gửi')", "Text(AppLocalizations.of(context)!.messageSended)")
    ],
    r"e:\project\kiddo\lib\modules\bottombar\screen\user_info\edit_info_teacher_screen.dart": [
        ("const Text('Thông tin tài khoản')", "Text(AppLocalizations.of(context)!.accountInfo)")
    ]
}

for file_path, reps in replacements.items():
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue
        
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()
        
    needs_import = False
    for old, new in reps:
        if old in content:
            content = content.replace(old, new)
            needs_import = True
            
    if needs_import and "import 'package:flutter_gen/gen_l10n/app_localizations.dart';" not in content:
        # add import after other imports
        content = re.sub(r"(import 'package:[^;]+;)", r"\1\nimport 'package:flutter_gen/gen_l10n/app_localizations.dart';", content, count=1)
            
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)

print("Replacements done.")
