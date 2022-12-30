import 'package:flutter/material.dart';
import 'package:flutter_contacts/properties/email.dart';

class EmailForm extends StatefulWidget {
  final Email email;
  final void Function(Email) onUpdate;
  final void Function() onDelete;

  const EmailForm(
    this.email, {
    required this.onUpdate,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>();
  static const _validLabels = EmailLabel.values;

  TextEditingController _addressController = TextEditingController();
  late EmailLabel _label;
  TextEditingController _customLabelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.email.address);
    _label = widget.email.label;
    _customLabelController =
        TextEditingController(text: widget.email.customLabel);
  }

  void _onChanged() {
    final email = Email(
      _addressController.text,
      label: _label,
      customLabel:
          _label == EmailLabel.custom ? _customLabelController.text : '',
    );
    widget.onUpdate(email);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'Delete',
            child: Text('Delete'),
          ),
        ],
        onSelected: (_) => widget.onDelete(),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          onChanged: _onChanged,
          child: Column(
            children: [
              TextFormField(
                controller: _addressController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Address'),
              ),
              DropdownButtonFormField(
                isExpanded: true, // to avoid overflow
                items: _validLabels
                    .map((e) => DropdownMenuItem<EmailLabel>(
                        value: e, child: Text(e.toString())))
                    .toList(),
                value: _label,
                onChanged: (label) {
                  setState(() {
                    _label = label!;
                  });
                  _onChanged();
                },
              ),
              _label == EmailLabel.custom
                  ? TextFormField(
                      controller: _customLabelController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration:
                          const InputDecoration(hintText: 'Custom label'),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
