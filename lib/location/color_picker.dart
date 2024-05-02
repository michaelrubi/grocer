import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:grocer/shared/styles.dart';

class ColorPicker extends StatefulWidget {
  final Function(Color) onColorSelected;
  final Color initialColor;

  const ColorPicker(
      {super.key, required this.onColorSelected, required this.initialColor});

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late HSVColor color;
  final txtCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    color = HSVColor.fromColor(widget.initialColor);
    txtCtrl.text = toHexString(widget.initialColor);
  }

  String toHexString(Color color) =>
      '#${color.value.toRadixString(16).substring(2).toUpperCase()}';

  Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  void onChanged(HSVColor color) {
    this.color = color;
    txtCtrl.text = toHexString(color.toColor());
  }

  void changeText(String text) {
    if (text.length < 6 || (text.length < 7 && text.startsWith('#'))) return;
    Color dartColor = fromHex(text);
    setState(() => onChanged(HSVColor.fromColor(dartColor)));
  }

  void submit() {
    widget.onColorSelected(color.toColor());
    Navigator.of(context).pop();
  }

  void cancel() {
    widget.onColorSelected(widget.initialColor);
    Navigator.of(context).pop();
  }

  void copy() {
    Clipboard.setData(ClipboardData(text: txtCtrl.text));
  }

  void paste() async {
    final text = await Clipboard.getData('text/plain');
    if (text != null && text.text != null) {
      changeText(text.text!); // Update the text field
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.all(Gap.sml),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'SELECT COLOR',
                  style: Txt.h2,
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 6.75 * rem,
                      height: 6.75 * rem,
                      child: WheelPicker(
                        color: color,
                        onChanged: (value) => super.setState(
                          () => onChanged(value),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 6.75 * rem,
                      height: 6.75 * rem,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 4.125 * rem,
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  maxLength: 7,
                                  controller: txtCtrl,
                                  style: Txt.label,
                                  onChanged: (text) => changeText(text),
                                  decoration: InputDecoration(
                                      counterText: '',
                                      contentPadding:
                                          EdgeInsets.only(left: Gap.sml),
                                      hintText: 'Hex Color',
                                      hintStyle:
                                          TextStyle(color: Col.highlight),
                                      filled: true,
                                      fillColor: Col.field,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                          color: Col.highlight,
                                          width: 1,
                                        ),
                                      )),
                                ),
                              ),
                              IconButton(
                                onPressed: paste,
                                icon: const Icon(Icons.content_paste),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SizedBox(
                              width: 6.75 * rem,
                              child: FloatingActionButton(
                                onPressed: copy,
                                backgroundColor: color.toColor(),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(bdrRad)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: submit,
                        style: FilledButton.styleFrom(
                            padding: EdgeInsets.all(Gap.sml / 2),
                            backgroundColor: Col.highlight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            )),
                        child: Padding(
                          padding: EdgeInsets.all(Gap.xs / 2),
                          child: Text('Update', style: Txt.p),
                        ),
                      ),
                    ),
                    SizedBox(width: Gap.sml),
                    Expanded(
                      child: FilledButton(
                        // Cancel Button
                        onPressed: cancel,
                        style: FilledButton.styleFrom(
                            padding: EdgeInsets.all(Gap.sml / 2),
                            backgroundColor: Col.menu,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            )),
                        child: Padding(
                          padding: EdgeInsets.all(Gap.xs / 2),
                          child: Text('Cancel', style: Txt.p),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
