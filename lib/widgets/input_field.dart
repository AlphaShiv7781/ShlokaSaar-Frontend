import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
   InputField({super.key, required this.controller});
  final TextEditingController controller ;
  @override
  Widget build(BuildContext context) {

    return TextField(
      enabled: true,
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter Shloka',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.deepOrange
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.deepOrange.shade900,
                width: 2
          )
        ),
      ),
    );
  }
}
