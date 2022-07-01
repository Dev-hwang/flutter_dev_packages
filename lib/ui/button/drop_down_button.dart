import 'package:flutter/material.dart';
import 'package:flutter_dev_packages/ui/button/models/button_size.dart';

class DropDownButton extends StatelessWidget {
  const DropDownButton({
    Key? key,
    this.buttonSize = ButtonSize.materialLarge,
    required this.items,
    this.value,
    this.valueStyle,
    this.disabledValueStyle,
    this.hint,
    this.hintStyle,
    this.disabledHint,
    this.disabledHintStyle,
    this.icon,
    this.border,
    this.disabledBorder,
    this.borderRadius,
    this.dropdownColor,
    this.dropdownElevation = 8,
    this.padding = const EdgeInsets.only(left: 10),
    this.expanded = false,
    this.onChanged,
  })  : assert(dropdownElevation >= 0),
        super(key: key);

  final ButtonSize buttonSize;
  final List<String> items;
  final String? value;
  final TextStyle? valueStyle;
  final TextStyle? disabledValueStyle;
  final String? hint;
  final TextStyle? hintStyle;
  final String? disabledHint;
  final TextStyle? disabledHintStyle;
  final Icon? icon;
  final Border? border;
  final Border? disabledBorder;
  final BorderRadius? borderRadius;
  final Color? dropdownColor;
  final int dropdownElevation;
  final EdgeInsetsGeometry padding;
  final bool expanded;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    Color defaultColor;
    Border determinedBorder;
    TextStyle? determinedStyle;
    if (onChanged != null) {
      defaultColor = Theme.of(context).colorScheme.onSurface;
      determinedBorder = border ?? Border.all(color: defaultColor);
      determinedStyle = valueStyle ??
          Theme.of(context).textTheme.subtitle1?.copyWith(color: defaultColor);
    } else {
      defaultColor = Theme.of(context).disabledColor;
      determinedBorder = disabledBorder ?? Border.all(color: defaultColor);
      determinedStyle = disabledValueStyle ??
          Theme.of(context).textTheme.subtitle1?.copyWith(color: defaultColor);
    }

    return Container(
      constraints: BoxConstraints(
        minWidth: buttonSize.minWidth,
        minHeight: buttonSize.minHeight,
      ),
      decoration: BoxDecoration(
        border: determinedBorder,
        borderRadius: borderRadius,
      ),
      child: DropdownButton<String>(
        items: _buildMenuItems(context),
        value: value,
        style: determinedStyle,
        hint: _buildHintText(context, false),
        disabledHint: _buildHintText(context, true),
        icon: icon,
        underline: const SizedBox.shrink(),
        dropdownColor: dropdownColor,
        elevation: dropdownElevation,
        isExpanded: expanded,
        onChanged: (String? newValue) {
          if (newValue == null) return;
          onChanged?.call(newValue);
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildMenuItems(BuildContext context) {
    return List.generate(
      items.length,
      (i) => DropdownMenuItem<String>(
        value: items[i],
        child: Padding(padding: padding, child: Text(items[i])),
      ),
    );
  }

  Widget _buildHintText(BuildContext context, bool disabled) {
    String? determinedHint;
    TextStyle? determinedHintStyle;
    if (hint != null && !disabled) {
      determinedHint = hint!;
      determinedHintStyle = hintStyle ??
          Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(color: Theme.of(context).hintColor);
    } else if (disabledHint != null && disabled) {
      determinedHint = disabledHint!;
      determinedHintStyle = disabledHintStyle ??
          Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(color: Theme.of(context).disabledColor);
    }

    if (determinedHint == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: Text(determinedHint, style: determinedHintStyle),
    );
  }
}
