import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiddo/teacher_model/teacher_class_model.dart';
import 'package:kiddo/teacher_repo/teacher_class_repo.dart';
import 'package:kiddo/utils/constants/styles.dart';

class AddDocumentSheet extends StatefulWidget {
  const AddDocumentSheet({super.key, required this.sessions});
  final List<DetailBuoiHocExtendedModel> sessions; // danh sách buổi học để chọn
  @override
  State<AddDocumentSheet> createState() => _AddDocumentSheetState();
}

class _AddDocumentSheetState extends State<AddDocumentSheet> {
  static const Color primaryColor = Color(0xFFF36A21);

  PickedFileModel? pickedFile;

  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  int selectedType = 0;
  DetailBuoiHocExtendedModel? selectedSession; // buổi học đã chọn

  /// 📁 Pick file (pdf, doc, svg, ...)
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'svg', 'png', 'jpg'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        pickedFile = PickedFileModel(
          name: result.files.single.name,
          path: result.files.single.path!,
          size: result.files.single.size,
        );
      });
    }
  }

  /// 🖼 Pick image
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      setState(() {
        pickedFile = PickedFileModel(
          name: image.name,
          path: image.path,
        );
      });
    }
  }

  void _removeFile() {
    setState(() {
      pickedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //_buildSourceDropdown(),
                    const SizedBox(height: 16),
                    _buildUploadBox(),
                    if (pickedFile != null) ...[
                      const SizedBox(height: 12),
                      _buildFileItem(),
                    ],
                    const SizedBox(height: 20),
                    _buildLabel('Tên'),
                    _buildTextField(
                      hint: 'Tên bài tập', controller: _nameController,
                      //enabled: false,
                    ),
                    const SizedBox(height: 12),
                    _buildSessionDropdown(),
                    const SizedBox(height: 12),
                    _buildTypeDropdown(),
                    const SizedBox(height: 12),
                    _buildTextField(
                      hint: 'Ghi chú',
                      maxLines: 4,
                      controller: _noteController,
                    ),
                  ],
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Thêm tài liệu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox() {
    return InkWell(
      onTap: _showPickOptions,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Chọn file',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPickOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Chọn file'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFile();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Chọn ảnh từ thư viện'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Chụp ảnh'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFileItem() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              pickedFile!.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _removeFile,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed: pickedFile == null
              ? null
              : () {
                  // TODO: upload file lên server
                  print('Upload: ${pickedFile!.path}');
                  TeacherClassRepo().uploadDocument(
                    id: selectedSession!.eventCheckinOffId,
                    type: selectedType.toString(),
                    name: _nameController.text,
                    note: _noteController.text,
                    photo: File(pickedFile!.path),
                  );
                },
          child: Text(
            'Thêm mới',
            style: defaultText14M.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    bool enabled = true,
    int maxLines = 1,
  }) {
    return TextField(
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: _outlineBorder(),
        enabledBorder: _outlineBorder(),
        disabledBorder: _outlineBorder(),
        focusedBorder: _outlineBorder(color: primaryColor),
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return InkWell(
      onTap: _showTypeBottomSheet,
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: _outlineBorder(),
          enabledBorder: _outlineBorder(),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedType == 0 ? 'Tài liệu' : 'Bài tập',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  void _showTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _typeItem(0, 'Tài liệu'),
              _typeItem(1, 'Bài tập'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSessionDropdown() {
    return InkWell(
      onTap: _showSessionBottomSheet,
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: _outlineBorder(),
          enabledBorder: _outlineBorder(),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedSession?.name ?? 'Chọn buổi học',
                style: TextStyle(
                  color: selectedSession == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  void _showSessionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.sessions.length,
            itemBuilder: (_, index) {
              final item = widget.sessions[index];
              return ListTile(
                title: Text(item.name),
                onTap: () {
                  setState(() {
                    selectedSession = item;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _typeItem(int type, String title) {
    return ListTile(
      title: Text(title),
      onTap: () {
        setState(() {
          selectedType = type;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  OutlineInputBorder _outlineBorder({Color color = const Color(0xFFE0E0E0)}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    );
  }
}

class PickedFileModel {
  final String name;
  final String path;
  final int? size;

  PickedFileModel({
    required this.name,
    required this.path,
    this.size,
  });
}
