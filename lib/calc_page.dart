import 'package:deviation_calculator/calculator_functions/inclinometer_data.dart';
import 'package:deviation_calculator/calculator_functions/inclinometer_service.dart';
import 'package:deviation_calculator/calculator_functions/local_data.dart';
import 'package:deviation_calculator/components/my_bulktextfield.dart';
import 'package:deviation_calculator/components/my_texfield.dart';
import 'package:deviation_calculator/dataPage.dart';
import 'package:deviation_calculator/result_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:toastification/toastification.dart';

class CalcPage extends StatefulWidget {
  const CalcPage({super.key});

  @override
  State<CalcPage> createState() => _CalcPageState();
}

class _CalcPageState extends State<CalcPage> {
  // Bulk Input
  final TextEditingController _bulkInputController = TextEditingController();

  // InclinometerData
  final TextEditingController _depthController = TextEditingController();

  // double aPlus;
  final TextEditingController _aPlusController = TextEditingController();

  // double aMinus;
  final TextEditingController _aMinusController = TextEditingController();

  // double bPlus;
  final TextEditingController _bPlusController = TextEditingController();

  // double bMinus;
  final TextEditingController _bMinusController = TextEditingController();

  var result;
  List<InclinometerData> baseDataStore = [];
  List<double> baseA = [];
  List<double> baseB = [];
  bool baseData = false;
  bool isResult = false;
  bool isRawData = false;
  String? selectedIncl;

  // Refresh Indicator
  Future<void> _refreshData() {
    return Future.delayed(Duration(seconds: 1), () {
    });
  }

  // Input texfield
  Widget inputTextField(TextEditingController controller) {
    return Expanded(
      flex: 12,
      child: MyTextfield(
        hintText: "....",
        obscureText: false,
        controller: controller,
      ),
    );
  }

  // Show save dialog
  Future<void> showSaveDialog(
    String currentData
  ) async {
    final parentContext = context;
    TextEditingController keyController = TextEditingController();
    await showDialog(
      context: parentContext, 
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Save INCL Data",
           style: TextStyle(fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text("Enter key name:"),
              SizedBox(height: 10),
              TextField(
                controller: keyController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter key name",
                  hintText: "INCLXX..",
                ),
              )
            ],
          ),          
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String newKey = keyController.text.trim();
                if(newKey.isEmpty) return;

                LocalData().saveBaseRaw(newKey, currentData);
                Navigator.pop(dialogContext);

                toastification.show(
                  context: parentContext,
                  type: ToastificationType.success,
                  style: ToastificationStyle.flatColored,
                  autoCloseDuration: const Duration(seconds: 3),
                  icon: Icon(Icons.check),
                  backgroundColor: Colors.green[200]!,
                  foregroundColor: Colors.green,
                  title: Text("Data saved as $newKey"),
                  dragToClose: true,
                );
              },
              child: Text("Save"),
            ),
          ],
        );
      }
    );
  }

  // String fixed data
  String fixedData(double value) {
    String s = value.toStringAsFixed(10);
    s = s.replaceFirst(RegExp(r'\.?0+$'), '');
    return s;
  }

  // clear InputField
  void resetInputFields() {
    _bulkInputController.clear();
    _depthController.clear();
    _aPlusController.clear();
    _aMinusController.clear();
    _bPlusController.clear();
    _bMinusController.clear();
  }

  // Input Title
  Widget inputTitle(String text) {
    return Container(
      width: 60,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // add data method
  void parseBaseData(String raw) {
    baseDataStore.clear();
    var parsedData = BulkDataParser.parse(raw);
    List<double> depth = parsedData['depth'] ?? [];
    List<double> aPlus = parsedData['aPlus'] ?? [];
    List<double> aMinus = parsedData['aMinus'] ?? [];
    List<double> bPlus = parsedData['bPlus'] ?? [];
    List<double> bMinus = parsedData['bMinus'] ?? [];

    for (int i = 0; i < depth.length; i++) {
      baseDataStore.add(
        InclinometerData(
          depth: depth[i],
          aPlus: aPlus[i],
          aMinus: aMinus[i],
          bPlus: bPlus[i],
          bMinus: bMinus[i],
        ),
      );
    }

    var baseCalc = InclinometerCalculator().calculate(baseDataStore);

    setState(() {
      baseA = baseCalc["absoluteA"];
      baseB = baseCalc["absoluteB"];
      baseData = true;
    });
  }

  // Warning color method
  Color warningColor(warning) {
    if (warning == "Stable") {
      return Colors.green;
    } else if (warning == "Alert") {
      return Colors.yellow;
    } else if (warning == "Beware!!") {
      return Colors.orange;
    } else if (warning == "Critical Danger!!!") {
      return Colors.red;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Deviation Calculator",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Result section
                Container(
                  height: 160,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (result != null && isResult == true) ...[
                          for (var r in result) ...[
                            SizedBox(height: 2),
                            Text(
                              "Depth: ${r.depth}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Deviation Disp A: ${fixedData(r.deviationA)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Deviation Disp B: ${fixedData(r.deviationB)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Warning: ${r.warning}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: warningColor(r.warning),
                                  ),
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ResultPage(result: result),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "[More]",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                          ],
                        ] else if (isResult == false) ...[
                          SizedBox(height: 2),
                          Text(
                            "Depth: -",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Deviation A: -",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Deviation B: -",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                "Warning: -",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Datapage(),
                                    ),
                                  );
                                }, 
                                child: Text(
                                  "[INCL Data]",
                                  style: TextStyle(color: Colors.white),
                                ))
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
        
                // Input Section
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        baseData == false
                            ? "Input Base Data: "
                            : "Input Current Data",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
        
                    Spacer(),

                    // Dropdown fixed data
                    ValueListenableBuilder(
                      valueListenable: LocalData().baseData.listenable(),
                      builder: (context, box, widget) {
                        List<String> allKeys = LocalData().getAllKeys();
                        return SizedBox(
                          width: 140,
                          child: DropdownMenu<String>(
                            onSelected: (value) {
                              setState(() {
                                selectedIncl = value;
                                isRawData = true;
                              });
                              if (value == "Default") {
                                setState(() {
                                  selectedIncl = null;
                                  baseData = false;
                                  isRawData = false;
                                  result = [];
                                  baseDataStore = [];
                                  resetInputFields();
                                  baseDataStore.clear();
                                  baseA.clear();
                                  baseB.clear();
                                });
                                return;
                              }
                              if (value != null) {
                                setState(() {
                                  selectedIncl = value;
                                  isRawData = true;
                                });
                                final raw = LocalData().getBaseRaw(value);
                                _bulkInputController.text = raw;
                                parseBaseData(raw);
                                _bulkInputController.clear();
                              }
                            },
                            menuHeight: 200,
                            enableSearch: true,
                            label: Text(
                              "Select INCL",
                              style: TextStyle(fontSize: 12),
                            ),
                            dropdownMenuEntries: [
                              DropdownMenuEntry(value: "Default", label: "Default"),
                              ...allKeys.map((key) => DropdownMenuEntry(
                                value: key, label: key),
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ],
                ),
                SizedBox(height: 10),
        
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      inputTitle("Depth"),
                      SizedBox(width: 18),
                      inputTitle("A+"),
                      SizedBox(width: 18),
                      inputTitle("A-"),
                      SizedBox(width: 18),
                      inputTitle("B+"),
                      SizedBox(width: 18),
                      inputTitle("B-"),
                    ],
                  ),
                ),
        
                BulkInputTable(controller: _bulkInputController),
        
                SizedBox(height: 30),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Calculate Button
                    if (baseData == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              var parsedData = BulkDataParser.parse(
                                _bulkInputController.text,
                              );
                              // Convert into double
                              List<double> depth = parsedData['depth'] ?? [];
                              List<double> aPlus = parsedData['aPlus'] ?? [];
                              List<double> aMinus = parsedData['aMinus'] ?? [];
                              List<double> bPlus = parsedData['bPlus'] ?? [];
                              List<double> bMinus = parsedData['bMinus'] ?? [];
        
                              if (depth.isEmpty ||
                                  aPlus.isEmpty ||
                                  aMinus.isEmpty ||
                                  bPlus.isEmpty ||
                                  bMinus.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Semua input harus angka valid",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              } else if (!(depth.length == aPlus.length &&
                                  aPlus.length == aMinus.length &&
                                  aMinus.length == bPlus.length &&
                                  bPlus.length == bMinus.length)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Semua jumlah input harus sama",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              } else if (baseDataStore.length != depth.length) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: Text("Wait a sec.."),
                                      content: Text(
                                        "Data count mismatch, Wanna try again?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("No"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              result = [];
                                              isResult = false;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text("Yes"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
        
                              List<InclinometerData> input = [];
                              for (int i = 0; i < depth.length; i++) {
                                input.add(
                                  InclinometerData(
                                    depth: depth[i],
                                    aPlus: aPlus[i],
                                    aMinus: aMinus[i],
                                    bPlus: bPlus[i],
                                    bMinus: bMinus[i],
                                  ),
                                );
                              }
        
                              var calc = InclinometerCalculator();
                              var step1 = calc.calculate(input);
        
                              setState(() {
                                result = calc.deviationDisplacement(
                                  input,
                                  step1["absoluteA"],
                                  step1["absoluteB"],
                                  baseA,
                                  baseB,
                                );
                              });
                              isResult = true;
                              _bulkInputController.clear();
        
                              if (!isRawData) {
                                baseData = false;
                                baseDataStore.clear();
                                _bulkInputController.clear();
                              }
                            },
        
                            child: Text(
                              "Calculate",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
        
                    if (baseData != true && isRawData == false)
                      // Add new base Data
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {  
                              baseDataStore.clear();
                              baseData = true;
                              var parsedData = BulkDataParser.parse(
                                _bulkInputController.text,
                              );
                              List<double> depth = parsedData['depth'] ?? [];
                              List<double> aPlus = parsedData['aPlus'] ?? [];
                              List<double> aMinus = parsedData['aMinus'] ?? [];
                              List<double> bPlus = parsedData['bPlus'] ?? [];
                              List<double> bMinus = parsedData['bMinus'] ?? [];
        
                              if (depth.isEmpty ||
                                  aPlus.isEmpty ||
                                  aMinus.isEmpty ||
                                  bPlus.isEmpty ||
                                  bMinus.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Semua input harus angka valid",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              } else if (!(depth.length == aPlus.length &&
                                  aPlus.length == aMinus.length &&
                                  aMinus.length == bPlus.length &&
                                  bPlus.length == bMinus.length)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Semua jumlah input harus sama",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
        
                              String input = _bulkInputController.text;
                              showSaveDialog(input);
        
                              // Reset Controller
                              resetInputFields();
                            },
                            child: Text(
                              "Add to INCL Data",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
        
                    // Add new Data
                    if (baseData != true && isRawData == false)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              baseDataStore.clear();
                              baseData = true;
                              var parsedData = BulkDataParser.parse(
                                _bulkInputController.text,
                              );
                              List<double> depth = parsedData['depth'] ?? [];
                              List<double> aPlus = parsedData['aPlus'] ?? [];
                              List<double> aMinus = parsedData['aMinus'] ?? [];
                              List<double> bPlus = parsedData['bPlus'] ?? [];
                              List<double> bMinus = parsedData['bMinus'] ?? [];
        
                              if (depth.isEmpty ||
                                  aPlus.isEmpty ||
                                  aMinus.isEmpty ||
                                  bPlus.isEmpty ||
                                  bMinus.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Semua input harus angka valid",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              } else if (!(depth.length == aPlus.length &&
                                  aPlus.length == aMinus.length &&
                                  aMinus.length == bPlus.length &&
                                  bPlus.length == bMinus.length)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Semua jumlah input harus sama",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              for (int i = 0; i < depth.length; i++) {
                                baseDataStore.add(
                                  InclinometerData(
                                    depth: depth[i],
                                    aPlus: aPlus[i],
                                    aMinus: aMinus[i],
                                    bPlus: bPlus[i],
                                    bMinus: bMinus[i],
                                  ),
                                );
                              }
        
                              var baseCalc = InclinometerCalculator().calculate(
                                baseDataStore,
                              );
        
                              setState(() {
                                baseA = baseCalc["absoluteA"];
                                baseB = baseCalc["absoluteB"];
                              });
        
                              // Reset Controller
                              resetInputFields();
                            },
                            child: Text(
                              "Add Current Data",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
        
                      // SizedBox(width: 5),
        
                    // Refresh Button
                    if (isResult == true)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            result = [];
                            isResult = false;
                            _bulkInputController.clear();
                          });
                        },
                        icon: Icon(Icons.refresh),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
