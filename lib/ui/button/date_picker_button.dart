import 'package:flutter/material.dart';
import 'package:flutter_dev_packages/ui/button/models/button_size.dart';
import 'package:flutter_dev_packages/ui/dialog/modal_date_picker.dart';

class DatePickerButton extends StatelessWidget {
  const DatePickerButton({
    Key? key,
    this.buttonSize = ButtonSize.materialLarge,
    this.initDate,
    this.firstDate,
    this.lastDate,
    this.pickerLocale,
    this.pickerHelpText,
    this.pickerCancelText,
    this.pickerConfirmText,
    this.pickerErrorFormatText,
    this.pickerErrorInvalidText,
    this.pickerFieldHintText,
    this.pickerFieldLabelText,
    this.textStyle,
    this.icon,
    this.border,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.expanded = false,
    required this.onChanged,
  }) : super(key: key);

  final ButtonSize buttonSize;
  final DateTime? initDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Locale? pickerLocale;
  final String? pickerHelpText;
  final String? pickerCancelText;
  final String? pickerConfirmText;
  final String? pickerErrorFormatText;
  final String? pickerErrorInvalidText;
  final String? pickerFieldHintText;
  final String? pickerFieldLabelText;
  final TextStyle? textStyle;
  final Icon? icon;
  final Border? border;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final bool expanded;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius,
      child: Container(
        constraints: BoxConstraints(
          minWidth: buttonSize.minWidth,
          minHeight: buttonSize.minHeight,
        ),
        decoration: BoxDecoration(
          border: border ??
              Border.all(color: Theme.of(context).colorScheme.onSurface),
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildDateText(context),
            _buildDateIcon(context),
          ],
        ),
      ),
      onTap: () async {
        final selectedDate = await showModalDatePicker(
          context: context,
          initialDate: initDate ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(2000),
          lastDate: lastDate ?? DateTime(2100),
          locale: pickerLocale ?? const Locale('ko'),
          helpText: pickerHelpText,
          cancelText: pickerCancelText,
          confirmText: pickerConfirmText,
          errorFormatText: pickerErrorFormatText,
          errorInvalidText: pickerErrorInvalidText,
          fieldHintText: pickerFieldHintText,
          fieldLabelText: pickerFieldLabelText,
        );

        if (selectedDate != null) {
          onChanged.call(selectedDate);
        }
      },
    );
  }

  Widget _buildDateText(BuildContext context) {
    final dateText = initDate.toString().split(' ').first;
    final dateTextStyle = textStyle ??
        Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).colorScheme.onSurface);

    return Padding(
      padding: padding,
      child: Text(dateText, style: dateTextStyle),
    );
  }

  Widget _buildDateIcon(BuildContext context) {
    if (icon == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 15, end: 5),
      child: icon,
    );
  }
}
