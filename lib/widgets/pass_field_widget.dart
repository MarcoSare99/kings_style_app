import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class PassFieldWidget extends StatefulWidget {
  String? label;
  String? hint;
  String? msgError;
  String? controlador;
  bool error = false;
  bool isShow = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  PassFieldWidget(
      {super.key, this.label, this.hint, this.msgError, this.controlador});

  @override
  State<PassFieldWidget> createState() => _PassFieldState();
}

class _PassFieldState extends State<PassFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formkey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          initialValue: widget.controlador,
          obscureText: !widget.isShow,
          inputFormatters: [LengthLimitingTextInputFormatter(50)],
          decoration: InputDecoration(
              prefixIcon: Container(
                  margin: const EdgeInsets.only(left: 14, right: 14),
                  child: const Icon(
                    Icons.lock,
                  )),
              suffixIcon: Container(
                margin: const EdgeInsets.only(left: 14, right: 14),
                child: IconButton(
                  icon: Icon(
                      widget.isShow ? Icons.visibility : Icons.visibility_off,
                      color: widget.isShow
                          ? Theme.of(context).colorScheme.primary
                          : null),
                  onPressed: () {
                    setState(() {
                      widget.isShow = !widget.isShow;
                    });
                  },
                ),
              ),
              hintText: widget.hint,
              labelText: widget.label),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.next,
          onSaved: (value) {
            widget.controlador = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "Enter your password";
            } else if (widget.error) {
              return widget.msgError;
            }
            return null;
          },
          onChanged: (value) {
            widget.controlador = value;
            widget.error = false;
          },
        ),
      ),
    );
  }
}
