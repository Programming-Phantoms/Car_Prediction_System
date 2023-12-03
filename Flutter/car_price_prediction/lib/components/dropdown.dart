import 'package:flutter/material.dart';

class MyDropdown extends StatefulWidget {
  final String hintText;
  final List<dynamic> list;
  final IconData prefixIcon;

  const MyDropdown(
      {super.key,
      required this.hintText,
      required this.list,
      required this.prefixIcon});
  @override
  State<StatefulWidget> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  @override
  Widget build(BuildContext context) {
    String dropDownValue = widget.hintText;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(widget.prefixIcon,
              color: const Color.fromARGB(255, 255, 243, 23), size: 22),
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 255, 243, 23)),
            borderRadius: BorderRadius.circular(5),
          ),
          border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 255, 243, 23)),
            borderRadius: BorderRadius.circular(5),
          ),
          enabled: false,
          disabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 255, 243, 23)),
            borderRadius: BorderRadius.circular(5),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
        dropdownColor: const Color.fromARGB(255, 38, 38, 38),
        // ignore: unnecessary_null_comparison
        hint: dropDownValue == null
            ? const Text('Dropdown')
            : Text(
                dropDownValue,
                style: const TextStyle(
                    color: Color.fromARGB(255, 255, 243, 23), fontSize: 16),
              ),
        isExpanded: true,
        iconSize: 25.0,
        iconDisabledColor: const Color.fromARGB(255, 255, 243, 23),
        iconEnabledColor: const Color.fromARGB(255, 255, 243, 23),
        items: widget.list.map(
          (val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(
                val,
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 243, 23)),
              ),
            );
          },
        ).toList(),
        onChanged: (val) {},
      ),
    );
  }
}
