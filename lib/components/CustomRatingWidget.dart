import 'package:flutter/material.dart';

class CustomRatingWidget extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;

  const CustomRatingWidget({
    Key? key,
    this.initialRating = 0.0,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  State<CustomRatingWidget> createState() => _CustomRatingWidgetState();
}

class _CustomRatingWidgetState extends State<CustomRatingWidget> {
  double currentRating = 0.0;

  @override
  void initState() {
    super.initState();
    currentRating = widget.initialRating;
  }

  // Method to create a star icon, and optionally half-filled star
  Widget _buildStar(double rating, int index) {
    // Determine full, half, or empty star
    IconData icon;
    double ratingIndex = rating - index;

    if (ratingIndex >= 0.75) {
      icon = Icons.star; // Full star
    } else if (ratingIndex >= 0.25) {
      icon = Icons.star_half; // Half star
    } else {
      icon = Icons.star_border; // Empty star
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          currentRating = index + 0.5;
          if (ratingIndex < 0.25) {
            currentRating = index + 1.0;
          }
        });
        widget.onRatingChanged(currentRating);
      },
      child: Icon(
        icon,
        size: 28.0,
        color: Colors.amber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: currentRating, end: currentRating),
          duration: Duration(milliseconds: 300),
          builder: (context, double rating, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                10,
                (index) => _buildStar(rating, index),
              ),
            );
          },
        )
      ],
    );
  }
}
