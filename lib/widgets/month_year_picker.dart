import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthYearPicker extends StatefulWidget {
  const MonthYearPicker({
    required this.lastYear,
    required this.firstYear,
    required this.onChanged,
    this.initialValue,
    this.yearValidator,
    this.monthValidator,
    super.key,
  }) : assert(
         lastYear >= firstYear,
         'lastYear must be greater than or equal to firstYear',
       );

  final DateTime? initialValue;
  final int lastYear;
  final int firstYear;
  final ValueChanged<DateTime?> onChanged;

  final FormFieldValidator<DateTime>? yearValidator;
  final FormFieldValidator<DateTime>? monthValidator;

  @override
  State<MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  late List<DateTime> _years;
  late List<DateTime> _months;
  DateTime? _year;
  DateTime? _month;

  @override
  void initState() {
    if (widget.initialValue != null) {
      _year = DateTime(widget.initialValue!.year);
      _month = DateTime(2020, widget.initialValue!.month);
    }

    _years = [];
    for (var i = widget.firstYear; i <= widget.lastYear; i++) {
      _years.add(DateTime(i));
    }

    _months = [];
    for (var i = 1; i <= 12; i++) {
      _months.add(DateTime(2020, i));
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant MonthYearPicker oldWidget) {
    if (oldWidget.firstYear != widget.firstYear ||
        oldWidget.lastYear != widget.lastYear) {
      _years = [];
      for (var i = widget.firstYear; i <= widget.lastYear; i++) {
        _years.add(DateTime(i));
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void _onChanged() {
    DateTime? dateTime;
    if (_year != null && _month != null) {
      dateTime = DateTime(_year!.year, _month!.month);
    } else if (_year != null) {
      dateTime = DateTime(_year!.year);
    }
    widget.onChanged(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<DateTime>(
            value: _year,
            decoration: const InputDecoration(
              label: Text('Year'),
              hintText: 'Year',
              alignLabelWithHint: true,
            ),
            validator: widget.yearValidator,
            items:
                _years
                    .map(
                      (year) => DropdownMenuItem<DateTime>(
                        value: year,
                        child: Text(DateFormat('yyyy').format(year)),
                      ),
                    )
                    .toList(),
            onChanged:
                (value) => setState(() {
                  _year = value;
                  _onChanged();
                }),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<DateTime>(
            value: _month,
            decoration: const InputDecoration(
              label: Text('Month'),
              hintText: 'Month',
              alignLabelWithHint: true,
            ),
            validator: widget.monthValidator,
            items:
                _months
                    .map(
                      (month) => DropdownMenuItem<DateTime>(
                        value: month,
                        child: Text(DateFormat('MMMM').format(month)),
                      ),
                    )
                    .toList(),
            onChanged:
                (value) => setState(() {
                  _month = value;
                  _onChanged();
                }),
          ),
        ),
      ],
    );
  }
}
