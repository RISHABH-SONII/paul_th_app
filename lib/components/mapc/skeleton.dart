import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final double height;
  final double width;

  const Skeleton({Key? key, this.height = 20, this.width = 200})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: Duration(milliseconds: 1500), // Control the shimmer speed
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300], // Base color when shimmer is off
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double height;
  final double width;

  const SkeletonBox({Key? key, this.height = 20, this.width = 200})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Color(0xFFf1f0ed),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
  }
}
