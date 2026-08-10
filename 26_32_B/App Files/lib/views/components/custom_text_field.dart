import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? label;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? id;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Widget? prefixIcon; // Allows any widget
  final Widget? suffixIcon; // Allows any widget (IconButton included)
  final bool enabled;
  final bool autoFocus;
  final String? helperText; // New helper text
  final Color borderColor; // Allows customizable border color
  final FocusNode? focusNode; // Allows focus management

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.textStyle,
    this.padding = const EdgeInsets.all(16.0),
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.autoFocus = false,
    this.id,
    this.helperText,
    this.borderColor = Colors.blue, // Default border color is blue
    this.focusNode,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  late bool _isFocused;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _isFocused = false;

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onSaved: widget.onSaved,
        style: widget.textStyle ??
            TextStyle(
                fontSize: 16.0,
                color: _isFocused ? Colors.black : Colors.blue), // Text color based on focus
        enabled: widget.enabled,
        autofocus: widget.autoFocus,
        focusNode: _focusNode,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          labelStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue, // Label color remains blue
          ),
          prefixIcon: widget.prefixIcon, // Allows any widget
          suffixIcon: widget.suffixIcon, // Allows any widget
          helperText: widget.helperText, // Optional helper text
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: widget.borderColor, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: widget.borderColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
                color: widget.borderColor.withOpacity(0.6), width: 2.0),
          ),
        ),
      ),
    );
  }
}
