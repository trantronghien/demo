import 'dart:collection';

import 'package:untitled/model/attributes.dart';
import 'package:untitled/model/functional_dependency.dart';

/// tập R = (A, B, C) , F = {"A,B->C,D; B->C,D; C,D-> A,E; D,E-> A,B; D->E"}, tìm X+ = AB+?
/// fu thuộc hàm F = fds
/// listOfSetAttributes là tập cần tìm bao đóng là tập X+
Map<Set<Attributes>,Set<Attributes>> computeClosure(List<Attributes> relation, List<FunctionalDependency> fds, Set<Set<Attributes>> listOfSetAttributes) {
  Map<Set<Attributes>,Set<Attributes>> closure = {};
  for (final setItem in listOfSetAttributes) {
    Set<Attributes> closureElement = closureOfSet(fds, setItem.toList());
    print('$setItem+ = ${closureElement.join(',')}\n');
    closure[setItem] = closureElement;
  }
  return closure; // vd: định dạng {A, B}+ = A,B,C,D,E với key là A, B --> value   A,B,C,D,E
}

Set<Attributes> closureOfSet(
    List<FunctionalDependency> fds,
    List<Attributes> attributes,
    ) {
  Set<Attributes> closure = Set.from(attributes);
  bool updated;
  do {
    updated = false;
    for (var dependency in fds) {
      if (closure.containsAll(dependency.leftSide) && !closure.containsAll(dependency.rightSide)) {
        closure.addAll(dependency.rightSide);
        updated = true;
      }
    }
  } while (updated);

  return SplayTreeSet.from(closure, (a, b) => a.name.compareTo(b.name));
}