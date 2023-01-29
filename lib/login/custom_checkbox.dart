import 'package:flutter/material.dart';

class Custom_Checkbox extends StatefulWidget {
  final double? size, iconSize;
  final Function onChange;
  final Color? backgroundColor, borderColor, iconColor;
  final IconData? icon;
  final bool isChecked;

  Custom_Checkbox({
    Key? key,
    this.size,
    this.iconSize,
    required this.onChange,
    this.backgroundColor,
    this.iconColor,
    this.icon,
    this.borderColor,
    required this.isChecked,
  }) : super(key: key);

  @override
  State<Custom_Checkbox> createState() => _Custom_CheckboxState();
}

class _Custom_CheckboxState extends State<Custom_Checkbox> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
          widget.onChange(isChecked);
        });
      },
      child: AnimatedContainer(
          height: widget.size ?? 28,
          width: widget.size ?? 28,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xff1B2635),
              border: Border.all(
                  color: widget.borderColor ?? const Color(0xff1B2635))),
          child: isChecked
              ? Icon(
                  widget.icon ?? Icons.check,
                  color: widget.iconColor ?? Colors.white,
                  size: widget.iconSize ?? 25,
                )
              : null),
    );
  }
}
