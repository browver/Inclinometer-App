import 'package:flutter/material.dart';

class BulkInputTable extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  const BulkInputTable({
    super.key,
    required this.controller,
    this.hintText = """Paste data here (format: Depth A+ A- B+ B-):
 0	0,0181	-0,0175	0,0095	-0,0077
-0,5	0,0174	-0,0166	0,0084	-0,0069
-1	0,0161	-0,0154	0,0069	-0,0055
""",
  });

  @override
  State<BulkInputTable> createState() => _BulkInputTableState();
}

class _BulkInputTableState extends State<BulkInputTable> {
  List<List<String>> parsedData = [];

  // Realtime data parser
  void _parseData() {
    final lines = widget.controller.text.trim().split('\n');
    parsedData.clear();

    for (var line in lines) {
      if (line.trim().isEmpty) continue;

      List<String> values;

      // use tab as a separator
      if (line.contains('\t')) {
        values = line
            .split('\t')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else {
        // if theres no tab, use space (twice in order)
        values = line
            .split(RegExp(r'\s{2,}'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        // fallback: if theres no 5 column in a row, try split data with a single space
        if (values.length != 5) {
          values = line
              .split(RegExp(r'\s+'))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
        }
      }

      if (values.length == 5) {
        parsedData.add(values);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Make a bigger area of text field
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade500),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: widget.controller,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
            onChanged: (value) => _parseData(),
          ),
        ),
      ],
    );
  }
}

// Parsing logic separate from calc page
class BulkDataParser {
  static Map<String, List<double>> parse(String text) {
    final lines = text.trim().split('\n');

    List<double> depths = [];
    List<double> aPlus = [];
    List<double> aMinus = [];
    List<double> bPlus = [];
    List<double> bMinus = [];

    for (var line in lines) {
      if (line.trim().isEmpty) continue;

      List<String> values;

      // use tab as a separator
      if (line.contains('\t')) {
        values = line
            .split('\t')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else {
        // if theres no tab, use space (twice in order)
        values = line
            .split(RegExp(r'\s{2,}'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        // fallback: if theres no 5 column in a row, try split data with a single space
        if (values.length != 5) {
          values = line
              .split(RegExp(r'\s+'))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
        }
      }

      if (values.length == 5) {
        try {
          depths.add(double.parse(values[0].replaceAll(',', '.')));
          aPlus.add(double.parse(values[1].replaceAll(',', '.')));
          aMinus.add(double.parse(values[2].replaceAll(',', '.')));
          bPlus.add(double.parse(values[3].replaceAll(',', '.')));
          bMinus.add(double.parse(values[4].replaceAll(',', '.')));
        } catch (e) {
          print('Error parsing line: $line - $e');
          continue;
        }
      }
    }
    return {
      'depth': depths,
      'aPlus': aPlus,
      'aMinus': aMinus,
      'bPlus': bPlus,
      'bMinus': bMinus,
    };
  }
}
