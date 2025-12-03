import 'package:hive_ce_flutter/adapters.dart';
import 'baseData.dart';

class LocalData{
  // getter for keys
  List<String> getAllKeys() {
    List<String> key = baseData.keys.cast<String>().toList();
    key.sort();
    return key;
  }

  // add new INCL key parser
  String getInclName() {
    List<String> keys = getAllKeys();
    List<int> inclNumbers = [];
    for (var k in keys) {
      if(k.startsWith("INCL")) {
        var number = int.tryParse(k.substring(4));
        if(number != null) {
          inclNumbers.add(number);
        }
      }
    }

    if(inclNumbers.isEmpty) {
      return "INCL02";
    } else {
      inclNumbers.sort();
      int nextNumber = inclNumbers.last + 1;
      return "INCL${nextNumber.toString().padLeft(2, '0')}";
    }
  }

  // get the box
  final baseData = Hive.box("inclinometer_data");

  // save data
  void saveBaseRaw(String key, String value) {
    baseData.put(key, value);
  }

  // get raw data
  String getBaseRaw(String key) {
    return baseData.get(key, defaultValue: "");
  }

  // add to the data
  void addData() {
    saveBaseRaw("INCL02", INCL02);
    saveBaseRaw("INCL03", INCL03);
    saveBaseRaw("INCL04", INCL04);
    saveBaseRaw("INCL05", INCL05);
    saveBaseRaw("INCL06", INCL06);
    saveBaseRaw("INCL07", INCL07);
    saveBaseRaw("INCL08", INCL08);
    saveBaseRaw("INCL09", INCL09);
    saveBaseRaw("INCL10", INCL10);
    saveBaseRaw("INCL11", INCL11);
    saveBaseRaw("INCL12", INCL12);
    saveBaseRaw("INCL13", INCL13);
  }

  // clear data
  void deleteData(key) {
      
  }
  
}