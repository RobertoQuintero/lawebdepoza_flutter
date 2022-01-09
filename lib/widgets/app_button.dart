import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String title;
  final VoidCallback onPressed;

  AppButton({
    this.width,
    this.height,
    required this.title,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: width, height: height),
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Theme.of(context).primaryColor.withOpacity(0.9);
                return Theme.of(context)
                    .primaryColor; // Use the component's default.
              },
            ),
          ),
          onPressed: onPressed,
          child: Text(title)),
    );
  }
}
