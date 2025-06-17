import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSlider extends StatefulWidget {
  final ValueChanged<DateTime> onDateChanged;

  const DateSlider({super.key, required this.onDateChanged});

  @override
  _DateSliderState createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  DateTime selectedDate = DateTime.now();

  void _onPageChanged(int index) {
    setState(() {
      selectedDate = DateTime.now()
          .subtract(const Duration(days: 1))
          .add(Duration(days: index));
      widget.onDateChanged(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: PageView.builder(
        itemCount: 3,
        controller: PageController(initialPage: 1),
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          DateTime date = DateTime.now()
              .subtract(const Duration(days: 1))
              .add(Duration(days: index));
          bool isSelected = date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE').format(date),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
                Text(
                  DateFormat('MMM d').format(date),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    fontSize: 18,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
