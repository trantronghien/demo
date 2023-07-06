import 'package:untitled/model/functional_dependency.dart';

void main() {
  //
  // // Tính phụ thuộc hàm trực tiếp
  // List<FunctionalDependency> directDependencies = [];
  // for (var dependency in fds) {
  //   Set<String> leftSide = dependency.leftSide;
  //   Set<String> rightSide = dependency.rightSide;
  //
  //   Set<String> closure = closureOfSet(attributes, fds, leftSide.toList());
  //
  //   if (closure.containsAll(rightSide)) {
  //     directDependencies.add(dependency);
  //   }
  // }
  //
  // print('Direct Dependencies:');
  // for (var dependency in directDependencies) {
  //   print(
  //       '${dependency.leftSide.join(', ')} -> ${dependency.rightSide.join(', ')}');
  // }

  // tìm vùng phủ tối thiểu
  // final fdList = stringToFds(fds);
  // print(fdList.join('\n'));
  // List<List<String>> minimalCover = findMinimalCover(attributes, fdList);
  //
  // print('Minimal Cover:');
  // for (var fd in minimalCover) {
  //   print(fd.join(', '));
  // }
}

///
/// phân rã attributesR R = {A, B} => A và B , AB...
Set<String> decomposeSet(List<String> attributesR) {
  Set<String> result = {};
  final attributesRToString = attributesR.join(',');

  void backtrack(int index, String currentSubset) {
    result.add(currentSubset);
    for (int i = index; i < attributesR.length; i++) {
      String newSubset = currentSubset +
          (currentSubset.isNotEmpty ? ',' : '') +
          attributesR[i];
      backtrack(i + 1, newSubset);
    }
  }

  backtrack(0, '');
  // remove tập rỗng và tập R
  result.remove('');
  result.remove(attributesRToString);
  return result;
}

Set<String> closure(List<String> attributes, List<FunctionalDependency> fds,
    Set<String> decomposeSet) {
  Set<String> closure = {};
  decomposeSet.toList().forEach((element) {
    print('element: ${element}');
    Set<String> closureElement = closureOfSet(attributes, fds, element.replaceAll(r'//s', '').split(','));
    print(closureElement.join(';'));
    print('\n');
  });
  return closure;
}

Set<String> closureOfSet(List<String> attributes,
    List<FunctionalDependency> functionalDependencies, List<String> set) {
  List<String> closure = List.from(set);

  bool updated = true;
  while (updated) {
    updated = false;

    for (var dependency in functionalDependencies) {
      Set<String> leftSide = dependency.leftSide;
      Set<String> rightSide = dependency.rightSide;

      if (leftSide.every((attribute) => closure.contains(attribute))) {
        for (var attribute in rightSide) {
          if (!closure.contains(attribute)) {
            closure.add(attribute);
            updated = true;
          }
        }
      }
    }
  }
  return closure.toSet();
}

List<FunctionalDependency> stringToFds(String dependencyString) {
  final data = dependencyString.split(';');
  return data.map((e) => parseFunctionalDependency(e)).toList();
}

FunctionalDependency parseFunctionalDependency(String dependencyString) {
  List<String> parts = dependencyString.replaceAll(r'\\s', '').split('->');
  String leftSide = parts[0].trim();
  String rightSide = parts[1].trim();

  Set<String> leftSideAttributes = leftSide.split(',').toSet();
  Set<String> rightSideAttributes = rightSide.split(',').toSet();

  return FunctionalDependency(leftSideAttributes, rightSideAttributes);
}

List<List<String>> findMinimalCover(List<String> attributes,
    List<FunctionalDependency> functionalDependencies) {
  List<List<String>> minimalCover = [];
  // Loại bỏ phụ thuộc hàm trùng lặp
  List<FunctionalDependency> uniqueDependencies = [];
  for (var dependency in functionalDependencies) {
    if (!uniqueDependencies.contains(dependency)) {
      uniqueDependencies.add(dependency);
    }
  }

  // Áp dụng quy tắc phân giải
  for (var dependency in uniqueDependencies) {
    Set<String> leftSide = dependency.leftSide;
    Set<String> rightSide = dependency.rightSide;

    for (var attribute in rightSide) {
      List<String> newLeftSide = List.from(leftSide)
        ..remove(attribute);
      List<String> newRightSide = [attribute];

      minimalCover.add([attribute]);

      if (newLeftSide.isNotEmpty) {
        minimalCover.add([...newLeftSide, attribute]);
      }
    }
  }

  // Loại bỏ phụ thuộc hàm dư thừa
  List<List<String>> minimalCoverWithoutRedundancy = [];
  for (var dependency in minimalCover) {
    List<String> leftSide = dependency.sublist(0, dependency.length - 1);
    List<String> rightSide = [dependency.last];

    bool redundant = false;

    for (var existingDependency in minimalCoverWithoutRedundancy) {
      List<String> existingLeftSide =
      existingDependency.sublist(0, existingDependency.length - 1);
      List<String> existingRightSide = [existingDependency.last];

      if (leftSide.every((attribute) => existingLeftSide.contains(attribute)) &&
          rightSide
              .every((attribute) => existingRightSide.contains(attribute))) {
        redundant = true;
        break;
      }
    }

    if (!redundant) {
      minimalCoverWithoutRedundancy.add(dependency);
    }
  }

  return minimalCoverWithoutRedundancy;
}
