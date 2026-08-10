import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text; // Button text
  final VoidCallback onPressed; // Function to call when the button is pressed
  final Color color; // Button color
  final Color textColor; // Text color
  final double width; // Button width
  final double height; // Button height
  final EdgeInsetsGeometry padding; // Padding inside the button
  final double borderRadius; // Border radius for rounded corners
  final Icon? icon; // Optional icon to display inside the button
  final TextStyle? textStyle; // Customizable text style
  final bool isLoading; // Loading state for button

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue, // Default color is blue
    this.textColor = Colors.white, // Default text color is white
    this.width = double.infinity, // Default width is as wide as the screen
    this.height = 50.0, // Default height is 50
    this.padding = const EdgeInsets.symmetric(
        vertical: 16.0, horizontal: 24.0), // Default padding
    this.borderRadius = 8.0, // Default border radius
    this.icon, // Optional icon
    this.textStyle, // Custom text style
    this.isLoading = false, // Button loading state
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed, // Disable button when loading
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor, backgroundColor: color, // Text color
        minimumSize: Size(width, height), // Button size
        padding: padding, // Padding inside the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
        ),
        elevation: 3, // Button shadow for visual depth
        splashFactory: InkRipple.splashFactory, // Ripple effect for splash
      ),
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white) // Show loading indicator
          : icon == null
              ? Text(
                  text,
                  style: textStyle ??
                      const TextStyle(
                        fontSize: 16.0, // Button text size
                        fontWeight: FontWeight.bold, // Button text weight
                      ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon!,
                    const SizedBox(width: 8.0), // Spacing between icon and text
                    Text(
                      text,
                      style: textStyle ??
                          const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
    );
  }
}
