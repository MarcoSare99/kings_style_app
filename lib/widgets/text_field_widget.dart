import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class TextFieldWidget extends StatefulWidget {
  String? label;
  String? hint;
  String? msgError;
  int? inputType;
  int? lenght;
  int? maxLine;
  IconData? icono;
  String? controlador;
  bool error = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextFieldWidget(
      {super.key,
      this.label,
      this.hint,
      this.msgError,
      this.inputType,
      this.lenght,
      this.maxLine,
      this.icono,
      this.controlador});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            maxLines: widget.maxLine ?? 1,
            initialValue: widget.controlador,
            inputFormatters: [LengthLimitingTextInputFormatter(widget.lenght)],
            decoration: InputDecoration(
                prefixIcon: Container(
                  margin: const EdgeInsets.only(left: 14, right: 14),
                  child: Icon(
                    widget.icono,
                  ),
                ),
                hintText: widget.hint,
                labelText: widget.label),
            keyboardType: widget.inputType == 0
                ? TextInputType.number
                : TextInputType.text,
            textInputAction: TextInputAction.next,
            onSaved: (value) {
              widget.controlador = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Fill in this field";
              } else if (widget.error) {
                return widget.msgError;
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              setState(() {
                widget.controlador = value;
                widget.error = false;
              });
            },
          ),
        ));
  }
}
