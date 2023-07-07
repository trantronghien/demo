import 'package:untitled/keys.dart';
import 'package:untitled/model/attributes.dart';
import 'package:untitled/model/functional_dependency.dart';

void checkNF(List<Attributes> attributes, List<FunctionalDependency> fds){
  if(is3NF(attributes, fds)){
    print('NF3');
  }else if(is2NF(attributes, fds)){
    print('NF2');
  }else if(is1NF(attributes, fds)){
    print('NF1');
  }else {
    print('khong đạt dạng chuẩn nào');
  }
}

bool is1NF(List<Attributes> attributes, List<FunctionalDependency> fds) {
  // Check if all attributes are unique
  if (attributes.length != attributes.length) {
    return false;
  }

  // Check if any right side of dependency contains duplicate attributes
  for (var dependency in fds) {
    if (dependency.rightSide.toSet().length != dependency.rightSide.length) {
      return false;
    }
  }

  return true;
}

bool is2NF(List<Attributes> attributes, List<FunctionalDependency> functionalDependencies) {
  List<Set<Attributes>> keys = findKeys(attributes, functionalDependencies);

  for (var dependency in functionalDependencies) {
    if (!keys.any((key) => key.containsAll(dependency.leftSide))) {
      return false;
    }
  }
  return true;
}

bool is3NF(List<Attributes> attributes, List<FunctionalDependency> functionalDependencies) {
  List<Set<Attributes>> keys = findKeys(attributes, functionalDependencies);

  for (var dependency in functionalDependencies) {
    if (!dependency.leftSide.any((attribute) => keys.any((key) => key.contains(attribute))) &&
        !functionalDependencies
            .where((other) => other != dependency)
            .any((other) => other.leftSide.containsAll(dependency.leftSide))) {
      return false;
    }
  }

  return true;
}
