import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClassSummaryWidget extends StatefulWidget {
  final int zoomCount;
  final int offlineCount;

  const ClassSummaryWidget({
    super.key,
    required this.zoomCount,
    required this.offlineCount,
  });

  @override
  State<ClassSummaryWidget> createState() => _ClassSummaryWidgetState();
}

class _ClassSummaryWidgetState extends State<ClassSummaryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int get total => widget.zoomCount + widget.offlineCount;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant ClassSummaryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.zoomCount != widget.zoomCount ||
        oldWidget.offlineCount != widget.offlineCount) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : widget.zoomCount / total;

    return Row(
      children: [
        // ===== CIRCLE =====
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final animatedValue = percent * _animation.value;
            final animatedTotal = (total * _animation.value).round();

            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140.w,
                  height: 140.w,
                  child: CircularProgressIndicator(
                    value: animatedValue,
                    strokeWidth: 12.w,
                    backgroundColor: Colors.blue,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.green,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Tổng số lớp",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "$animatedTotal",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),

        SizedBox(width: 20.w),

        // ===== RIGHT =====
        Expanded(
          child: Column(
            children: [
              _buildItem(
                color: Colors.green,
                text: "${widget.zoomCount} lớp zoom",
              ),
              SizedBox(height: 12.h),
              _buildItem(
                color: Colors.blue,
                text: "${widget.offlineCount} lớp trực tiếp",
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildItem({required Color color, required String text}) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.9, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
