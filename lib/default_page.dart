// import 'package:deviation_calculator/calculator_functions/inclinometer_data.dart';
// import 'package:deviation_calculator/calculator_functions/inclinometer_service.dart';
// import 'package:deviation_calculator/components/my_texfield.dart';
// import 'package:flutter/material.dart';

// class CalcPage extends StatefulWidget {
//   const CalcPage({super.key});

//   @override
//   State<CalcPage> createState() => _CalcPageState();
// }

// class _CalcPageState extends State<CalcPage> {
//   // InclinometerData
//   final TextEditingController _depthController = TextEditingController();

//   // double aPlus;
//   final TextEditingController _aPlusController = TextEditingController();

//   // double aMinus;
//   final TextEditingController _aMinusController = TextEditingController();

//   // double bPlus;
//   final TextEditingController _bPlusController = TextEditingController();

//   // double bMinus;
//   final TextEditingController _bMinusController = TextEditingController();

//   // baseA
//   final TextEditingController _baseAController = TextEditingController();

//   // baseB
//   final TextEditingController _baseBController = TextEditingController();

//   bool isBaseData = false;
//   var result;

//   Widget inputRow(String label, TextEditingController controller) {
//     if (controller == _baseAController || controller == _baseBController) {
//       isBaseData = true;
//     }
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 50,
//             child: Container(
//               padding: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                 color: Colors.indigo,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: MyTextfield(
//               hintText: isBaseData == true ? "(opsional)" : "....",
//               obscureText: false,
//               controller: controller,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Align(
//         alignment: AlignmentGeometry.topLeft,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             inputRow("Depth", _depthController),
//             Row(
//               children: [
//                 inputRow("A+", _aPlusController),
//                 inputRow("A-", _aMinusController),
//               ]
//             ),
//             Row(
//               children: [
//                 inputRow("B+", _bPlusController),
//                 inputRow("B-", _bMinusController),
//               ]
//             ),

//             Row(
//               children: [
//                 inputRow("Base A", _baseAController),
//                 inputRow("Base B", _baseBController),
//               ]
//             ),

//             SizedBox(height: 12),

//             Padding(
//               padding: const EdgeInsets.only(left: 24),
//               child: Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.indigo,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   "Warning : ${result[0].warning}",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),

//       // Calculate Button
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom: 40, left: 40, right: 40),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.indigo,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 result != null
//                     ? "Hasil: \n Deviation A: ${result[0].deviationA.toStringAsFixed(4)} \n Deviation B: ${result[0].deviationB.toStringAsFixed(4)}"
//                     : "Hasil: ",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 200,
//               child: FloatingActionButton(
//                 backgroundColor: Colors.indigo,
//                 foregroundColor: Colors.white,
//                 onPressed: () {
//                   // Convert into double
//                   double? depth = double.tryParse(_depthController.text);
//                   double? aPlus = double.tryParse(_aPlusController.text);
//                   double? aMinus = double.tryParse(_aMinusController.text);
//                   double? bPlus = double.tryParse(_bPlusController.text);
//                   double? bMinus = double.tryParse(_bMinusController.text);
//                   double? baseA = double.tryParse(_baseAController.text);
//                   double? baseB = double.tryParse(_baseBController.text);

//                   // base file
//                   List<double> baseAList = baseA != null ? [baseA] : [];
//                   List<double> baseBList = baseB != null ? [baseB] : [];

//                   if (depth == null ||
//                       aPlus == null ||
//                       aMinus == null ||
//                       bPlus == null ||
//                       bMinus == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Semua input harus angka valid")),
//                     );
//                     return;
//                   }
//                   List<InclinometerData> input = [
//                     InclinometerData(
//                       depth: depth,
//                       aPlus: aPlus,
//                       aMinus: aMinus,
//                       bPlus: bPlus,
//                       bMinus: bMinus,
//                     ),
//                   ];
//                   setState(() {
//                     result = InclinometerCalculator().calculate(
//                       input,
//                       baseAList,
//                       baseBList,
//                     );
//                   });
//                 },
//                 child: Text(
//                   "Calculate",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
