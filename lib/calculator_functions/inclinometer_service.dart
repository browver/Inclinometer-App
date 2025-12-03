import 'inclinometer_data.dart';
import 'inclinometer_result.dart';

class InclinometerCalculator {
  double faceErrorLimit;

  InclinometerCalculator({
    this.faceErrorLimit = 3.0
  });

  Map<String, dynamic> calculate(
    List <InclinometerData> data,
  ) {
    
    List<double> meanA = [];
    List<double> meanB = [];
    List<double> faceErrorA = [];
    List<double> faceErrorB = [];

    for(var d in data) {
      // // Mean
      // double mA = (d.aPlus + d.aMinus) / 2;
      // double mB = (d.bPlus + d.bMinus) / 2;

      // Face Error
      double feA = d.aPlus - d.aMinus;
      double feB = d.bPlus - d.bMinus;

      faceErrorA.add(feA);
      faceErrorB.add(feB);

      // Mean
      meanA.add(feA / 2);
      meanB.add(feB / 2);
    }

    // Absolute Displacement
    List<double> absoluteDispA = [];
    List<double> absoluteDispB = [];

    for(var i = 0; i < data.length; i++) {
      if(i == 0) {
        absoluteDispA.add(meanA[i]);
        absoluteDispB.add(meanB[i]);
      } else {
        absoluteDispA.add(absoluteDispA[i - 1] + meanA[i]);
        absoluteDispB.add(absoluteDispB[i - 1] + meanB[i]);
      }
    }

    return {
      "meanA": meanA,
      "meanB": meanB,
      "faceErrorA": faceErrorA,
      "faceErrorB": faceErrorB,
      "absoluteA": absoluteDispA,
      "absoluteB": absoluteDispB,
    };
  }


    // Deviation Displacement
    List<InclinometerResult> deviationDisplacement(
      List<InclinometerData> data,
      List<double> absoluteA,
      List<double> absoluteB,
      List<double> baseAbsA,
      List<double> baseAbsB,
    ) {

    List<InclinometerResult> result = [];

    // Warning Method
    String warningResult(double devAbsA, double devAbsB) {
      if (devAbsA <= 0.1 && devAbsB <= 0.1) return "Stable";

      if ((devAbsA > 0.1 && devAbsA <= 0.5) || (devAbsB > 0.1 && devAbsB <= 0.5)) return "Alert";

      if ((devAbsA > 0.5 && devAbsA <= 1.5) || (devAbsB > 0.5 && devAbsB <= 1.5)) return "Beware!!";

      if (devAbsA > 1.5 || devAbsB > 1.5) return "Critical Danger!!!";

      return "OK";
    }

    for (var i = 0; i < data.length; i++){
      // get a base value for this index if available
      double? baseAVal;
      if (baseAbsA.isNotEmpty) {
        if (baseAbsA.length > i) {
          baseAVal = baseAbsA[i];
        }
        else if (baseAbsA.length == 1) {
          baseAVal = baseAbsA[0];
        }
        else {
          baseAVal = baseAbsA.last;
        }
      }

      double? baseBVal;
      if (baseAbsB.isNotEmpty) {
        if (baseAbsB.length > i) {
          baseBVal = baseAbsB[i];
        }
        else if (baseAbsB.length == 1) {
          baseBVal = baseAbsB[0];
        }
        else {
          baseBVal = baseAbsB.last;
        }
      }

    // Deviation
      double deviationA = baseAVal != null
        ? absoluteA[i] - baseAVal
        : absoluteA[i] - absoluteA[0];
      double deviationB = baseBVal != null
        ? absoluteB[i] - baseBVal
        : absoluteB[i] - absoluteB[0];

      double devAbsA = deviationA.abs();
      double devAbsB = deviationB.abs();


      // Result
      result.add(InclinometerResult(
        depth: data[i].depth,
        absoluteA: absoluteA[i],
        absoluteB: absoluteB[i],
        deviationA: deviationA,
        deviationB: deviationB,
        warning: warningResult(devAbsA, devAbsB),
      ));
      }
    return result;
  }
} 

void main() {
  List<InclinometerData> input = [
    InclinometerData(depth: 0.0, aPlus: 0.0181, aMinus: -0.0175, bPlus: 0.0095, bMinus: -0.0077),
    InclinometerData(depth: -0.5, aPlus: 0.0174, aMinus: -0.0166, bPlus: 0.0084, bMinus: -0.0069),
    InclinometerData(depth: -1.0, aPlus: 0.0161, aMinus: -0.0154, bPlus: 0.0069, bMinus: -0.0055),
    InclinometerData(depth: -1.5, aPlus: 0.0158, aMinus: -0.0151, bPlus: 0.0088, bMinus: -0.0073),
  ];

  List<double> baseA = [0.0176, 0.0345, 0.05025, 0.06565];
  List<double> baseB = [0.0088, 0.01655, 0.0227, 0.03065];

  var calc = InclinometerCalculator();

  // Step 1 — Hitung dasar
  var step1 = calc.calculate(input);

  // Step 2 — Dapatkan Deviation Displacement
  var result = calc.deviationDisplacement(
    input,
    step1["absoluteA"],
    step1["absoluteB"],
    baseA,
    baseB,
  );

  for (var r in result) {
    print("Depth: ${r.depth}");
    print("Deviation A: ${r.deviationA.toStringAsFixed(4)}");
    print("Deviation B: ${r.deviationB.toStringAsFixed(4)}");
    print("Warning: ${r.warning}");
    print("-------------------------");
  }
}
