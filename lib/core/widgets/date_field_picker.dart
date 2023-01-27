import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';

class DateFieldPicker extends StatefulWidget {
  final String? hintText;
  final String labelText;
  final String? helperText;
  final double bottomPadding;
  final DateTime initialValue;
  final FormFieldSetter<DateTime>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;

  DateFieldPicker(
      {Key? key,
      this.hintText,
      required this.labelText,
      this.helperText,
      this.bottomPadding = 0,
      required this.initialValue,
      this.onSaved,
      this.onChanged,
      this.validator})
      : super(key: key);

  @override
  _DateFieldPickerState createState() {
    return _DateFieldPickerState();
  }
}

class _DateFieldPickerState extends State<DateFieldPicker> {
  DateTime _selectedDate = Jiffy().subtract(years: 10).dateTime;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    if (widget.initialValue != null) {
      _selectedDate = widget.initialValue;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1920, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      this.widget.onChanged!(picked);
      setState(() {
        _selectedDate = picked;
        _controller.text = Jiffy(picked).format("dd-MMMM-yyyy");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.labelText, style: Theme.of(context).textTheme.bodyText1),
        Padding(
          padding: EdgeInsets.only(top: 4.0, bottom: widget.bottomPadding),
          child: TextFormField(
            readOnly: true,
            controller: _controller,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: this.widget.validator,
            onSaved: this.widget.onSaved,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,              
              contentPadding: EdgeInsets.only(left: 9),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                    width: 0.5, color: Theme.of(context).colorScheme.onSurface),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                    width: 0.5, color: Theme.of(context).colorScheme.onSurface),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                    color: (Theme.of(context).errorColor), width: 0.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                    color: (Theme.of(context).errorColor), width: 0.5),
              ),
              prefixIcon: InkWell(
                  onTap: () {
                    selectDate(context);
                  },
                  child: Icon(Icons.calendar_today)),
              hintText: widget.hintText ??
                  Jiffy(_selectedDate).format("dd-MMMM-yyyy"),
            ),
          ),
        ),
      ],
    );
  }
}
