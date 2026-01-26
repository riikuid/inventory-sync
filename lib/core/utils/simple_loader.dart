import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SimpleLoader extends StatelessWidget {
  final int totalItem;
  final double height;
  final double width;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  const SimpleLoader({
    super.key,
    required this.height,
    required this.width,
    required this.totalItem,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(totalItem, (index) {
        return Padding(
          padding: padding ?? const EdgeInsets.only(bottom: 10.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? 8.0),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
