class InclinometerData {
  double depth;
  double aPlus;
  double aMinus;
  double bPlus;
  double bMinus;

  InclinometerData({
    required this.depth,
    required this.aPlus,
    required this.aMinus,
    required this.bPlus,
    required this.bMinus,
  });
}


// List <String> deviationCalculator(A, a, B, b) {
//   var faceErrorA = A + a;
//   var faceErrorB = B + b;

//   if(faceErrorA || faceErrorB > 3) {
//     return "error sensor reading";
//   }

//   var meanA = (A + a) / 2;
//   var meanB = (B + b) / 2;

//   double absoluteA = meanA.reduce((a, b) => a + b);
//   double absoluteB = meanB.reduce((a, b) => a + b);

  
//   List<String> displacement(baseA, baseB) {
//     double deviationDisplacementA = absoluteA - baseA;
//     double deviationDisplacementB = absoluteB - baseB;

//   }


// }