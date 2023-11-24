import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class EmailFieldWidget extends StatefulWidget {
  String? label;
  String? hint;
  String? msgError;
  String? controlador;
  bool error = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  EmailFieldWidget(
      {super.key, this.label, this.hint, this.msgError, this.controlador});

  @override
  State<EmailFieldWidget> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: widget.controlador,
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
            decoration: InputDecoration(
                prefixIcon: Container(
                  margin: const EdgeInsets.only(left: 14, right: 14),
                  child: const Icon(
                    Icons.email,
                  ),
                ),
                hintText: widget.hint,
                labelText: widget.label),
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.next,
            onSaved: (value) {
              widget.controlador = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter an email";
              } else if (!EmailValidator.validate(value)) {
                return "Enter email valited";
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
