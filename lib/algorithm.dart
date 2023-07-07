import 'package:untitled/closure.dart';
import 'package:untitled/keys.dart';
import 'package:untitled/model/attributes.dart';
import 'package:untitled/model/functional_dependency.dart';
import 'package:untitled/normal_form.dart';

void main() {
  List<Attributes> relation = Attributes.stringToAttributes('A, B, C, D').toList();
  String fdString = "A,B->C,D; B -> C,D; C,D-> A,E; D,E-> A,B; D->E";
  // String fdString = "B-> D; A->B; C-> B";
  final fds = stringToFds(fdString);

  // Set<Set<Attributes>> decompose = decomposeSet(Attributes.attributesToListString(relation));
  // Tính bao đóng của tập
  // Map<Set<Attributes>,Set<Attributes>> closureOfR = closure(relation, fds, decompose);
  // print('Closure of R: ${closureOfR.join(',')}');

  // tìm key
  // List<Set<Attributes>> keys = findKeys(Attributes.stringToAttributes('A, B, C, D').toList(), stringToFds('B->D; C->D')); // {A, B, C}
  // Set<Attributes> primaryKeys = findPrimaryKey(Attributes.stringToAttributes('A, B, C, D').toList(), stringToFds('B->D; C->D')); // {A, C}
  // List<Set<Attributes>> keys = findKeys(Attributes.stringToAttributes('A, B, C, D').toList(), stringToFds('A->B; C->D')); // {A, C}
  // print('keys of R: ${keys.join(',')}');
  // Set<Attributes> primaryKeys = findPrimaryKey(Attributes.stringToAttributes('A, B, C, D').toList(), stringToFds('A->B; C->D')); // {A, C}
  // print('primaryKeys of R: ${primaryKeys.join(',')}');

  // NF2
  checkNF(Attributes.stringToAttributes('A, B, C, D').toList(), stringToFds('A,B -> C; A,B -> D'));
  // NOT NF2
  checkNF(Attributes.stringToAttributes('A, B, C, D').toList(), stringToFds('A,B -> C; A,B -> D; B -> D,C'));
  // NF3
  checkNF(Attributes.stringToAttributes('A, B, C, D, G, H').toList(), stringToFds('A,B -> C; A,B -> D; A,B -> G,H; G -> D,H'));
}

/// phân rã attributesR R = {A, B} => A và B , AB...
Set<Set<Attributes>> decomposeSet(List<String> attributesR) {
  Set<String> result = {};
  final attributesRToString = attributesR.join(',');

  void backtrack(int index, String currentSubset) {
    result.add(currentSubset);
    for (int i = index; i < attributesR.length; i++) {
      String newSubset = currentSubset + (currentSubset.isNotEmpty ? ',' : '') + attributesR[i];
      backtrack(i + 1, newSubset.trim());
    }
  }

  backtrack(0, '');
  // remove tập rỗng và tập R
  result.remove('');
  result.remove(attributesRToString);
  return result.map((e) => Attributes.stringToAttributes(e)).toSet();
}

List<FunctionalDependency> stringToFds(String dependencyString) {
  final data = dependencyString.replaceAll(RegExp(r"\s+"), '').split(';');
  return data.map((e) => parseFunctionalDependency(e)).toList();
}

FunctionalDependency parseFunctionalDependency(String dependencyString) {
  List<String> parts = dependencyString.replaceAll(RegExp(r"\s+"), '').split('->');
  String leftSide = parts[0].trim();
  String rightSide = parts[1].trim();

  Set<Attributes> leftSideAttributes = leftSide.split(',').map((item) => Attributes.of(item)).toSet();
  Set<Attributes> rightSideAttributes = rightSide.split(',').map((item) => Attributes.of(item)).toSet();

  return FunctionalDependency(leftSideAttributes, rightSideAttributes);
}
