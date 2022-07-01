import 'package:flutter/material.dart';
import 'package:flutter_dev_packages/flutter_dev_packages.dart';

const List<String> _kDropDownItems = ['Java', 'Kotlin', 'Dart', 'Swift'];

class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final _dateTimeNotifier = ValueNotifier(DateTime.now());
  final _dropDownValueNotifier = ValueNotifier(_kDropDownItems.first);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10),
          children: [
            _buildButtonExampleCard(),
            _buildDialogExampleCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard({
    required String title,
    required List<Widget> children,
  }) {
    final contents = <Widget>[
      Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
      const Divider(thickness: 0.5),
    ];

    for (final child in children) {
      contents.add(child);
      contents.add(const SizedBox(height: 8));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: contents,
        ),
      ),
    );
  }

  Widget _buildButtonExampleCard() {
    return _buildExampleCard(
      title: 'Button Example',
      children: [
        SimpleButton(
          child: const Text('Simple Button'),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {},
        ),
        GhostButton(
          child: const Text('Ghost Button'),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {},
        ),
        ValueListenableBuilder<DateTime>(
          valueListenable: _dateTimeNotifier,
          builder: (_, value, __) {
            return DatePickerButton(
              initDate: value,
              icon: const Icon(Icons.calendar_today),
              expanded: true,
              onChanged: (DateTime newDateTime) {
                _dateTimeNotifier.value = newDateTime;
              },
            );
          },
        ),
        ValueListenableBuilder<String>(
          valueListenable: _dropDownValueNotifier,
          builder: (_, value, __) {
            return DropDownButton(
              items: _kDropDownItems,
              value: value,
              expanded: true,
              onChanged: (String newValue) {
                _dropDownValueNotifier.value = newValue;
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDialogExampleCard() {
    showCustomDialog({DialogButtonStyle? buttonStyle}) {
      CustomDialog(
        content: 'Custom 다이얼로그 입니다.',
        buttonStyle: buttonStyle,
        onPositiveButtonPressed: () {},
        onNegativeButtonPressed: () {},
      ).show(context);
    }

    showSystemDialog() {
      SystemDialog(
        content: 'System 다이얼로그 입니다.',
        onPositiveButtonPressed: () {},
        onNegativeButtonPressed: () {},
      ).show(context);
    }

    showToastDialog() {
      const AndroidToast(message: 'Toast 다이얼로그 입니다.').show();
    }

    return _buildExampleCard(
      title: 'Dialog Example',
      children: [
        GhostButton(
          child: const Text('Custom - Flat'),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () =>
              showCustomDialog(buttonStyle: DialogButtonStyle.flat),
        ),
        GhostButton(
          child: const Text('Custom - Android'),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () =>
              showCustomDialog(buttonStyle: DialogButtonStyle.android),
        ),
        GhostButton(
          child: const Text('Custom - iOS'),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () =>
              showCustomDialog(buttonStyle: DialogButtonStyle.ios),
        ),
        GhostButton(
          child: const Text('System'),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: showSystemDialog,
        ),
        GhostButton(
          child: const Text('Toast'),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: showToastDialog,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dateTimeNotifier.dispose();
    _dropDownValueNotifier.dispose();
    super.dispose();
  }
}
