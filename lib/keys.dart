
import 'package:untitled/model/functional_dependency.dart';

void main() {
  List<String> attributes = ['A', 'B', 'C'];
  String fds = "A,B->C,D; D,E-> C,E; C,D-> A,E; D,E-> A,B; D->E";
  final fdList = stringToFds(fds);
  List<List<String>> minimalCover = findMinimalCover(attributes, fdList);

  print('Minimal Cover:');
  for (var fd in minimalCover) {
    print('${fd.leftSide.join(', ')} -> ${fd.rightSide.join(', ')}');
  }
}

List<FunctionalDependency> stringToFds(String dependencyString){
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


List<List<String>> findMinimalCover(List<String> attributes, List<FunctionalDependency> functionalDependencies) {
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
      List<String> newLeftSide = List.from(leftSide)..remove(attribute);
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
      List<String> existingLeftSide = existingDependency.sublist(0, existingDependency.length - 1);
      List<String> existingRightSide = [existingDependency.last];

      if (leftSide.every((attribute) => existingLeftSide.contains(attribute)) &&
          rightSide.every((attribute) => existingRightSide.contains(attribute))) {
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
