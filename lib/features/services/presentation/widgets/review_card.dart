import 'package:cleaning_service_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewCard extends ConsumerStatefulWidget {
  final int rating;
  final Function(int) onRatingChanged;
  final VoidCallback onSubmitReview;
  final int maxRating;
  final double size;
  final TextEditingController reviewController;

  const ReviewCard({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    required this.maxRating,
    required this.size,
    required this.reviewController,
    required this.onSubmitReview,
  });

  @override
  ConsumerState<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends ConsumerState<ReviewCard> {
  final ExpansibleController _controller = ExpansibleController();
  final reviewFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ExpansionTile(
      controller: _controller,
      title: const Text('Rate Provider'),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.maxRating,
              (index) => IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  index < widget.rating ? Icons.star : Icons.star_border,
                  size: widget.size,
                  color: theme.colorScheme.secondary,
                ),
                onPressed: () {
                  widget.onRatingChanged(index + 1);

                  // Expand tile when star clicked
                  _controller.expand();
                },
              ),
            ),
          ),

          Text(
            "Write a review",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),

      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppTextField(
            controller: widget.reviewController,
            label: '',
            obSecureText: false,
            keyboardType: TextInputType.multiline,
            // focusNode: ,
            maxLines: 5,
         
          ),
        ),

        ElevatedButton(
          onPressed: widget.onSubmitReview,
          child: const Text("Submit Review"),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
