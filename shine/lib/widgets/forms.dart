// Flutter imports:
import 'package:flutter/material.dart';

class TextWithButtonFormField<T> extends StatefulWidget {
  const TextWithButtonFormField({
    super.key,
    this.decoration,
    required this.buttonText,
    this.onPressed,
    this.onSaved,
    this.validator,
    this.txController,
    this.autovalidateMode,
    this.readOnly = false,
  });

  final InputDecoration? decoration;
  final String buttonText;
  final void Function(FormFieldState<T> field)? onPressed;
  final FormFieldSetter<T>? onSaved;
  final FormFieldValidator<T>? validator;
  final TextEditingController? txController;
  final AutovalidateMode? autovalidateMode;
  final bool readOnly;

  @override
  State<TextWithButtonFormField> createState() =>
      _TextWithButtonFormFieldState<T>();
}

class _TextWithButtonFormFieldState<T> extends State<TextWithButtonFormField<T>> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return FormField<T>(
      builder: (state) {
        return Row(
          children: [
            Expanded(
              child: TextField(
                decoration: widget.decoration?.copyWith(errorText: state.errorText),
                readOnly: widget.readOnly,
                controller: widget.txController,
              ),
            ),
            const SizedBox(width: 10),
            if (width < 600) IconButton(
              onPressed: () => widget.onPressed?.call(state),

              icon: const Icon(Icons.more_horiz),
            ) else ElevatedButton(
              onPressed: () => widget.onPressed?.call(state),
              child: Text(widget.buttonText),

            ),
          ],
        );
      },
      onSaved: widget.onSaved,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
    );
  }
}
