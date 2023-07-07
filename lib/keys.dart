import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:untitled/closure.dart';
import 'package:untitled/model/attributes.dart';
import 'package:untitled/model/functional_dependency.dart';

// sinh tập con có thứ tự 2^n == hàm decomposeSet nhưng có sắp xếp
Set<Set<Attributes>> generateSubsets(List<Attributes> relation) {
  int n = relation.length;
  int total = 1 << n;
  Set<Set<Attributes>> result = {};
  for (int i = 0; i < total; i++) {
    Set<Attributes> subset = {};
    for (int j = 0; j < n; j++) {
      if ((i & (1 << j)) > 0) {
        final attr = relation[j];
        if (attr.name.isNotEmpty) {
          subset.add(attr);
        }
      }
    }
    if (subset.isNotEmpty) {
      result.add(SplayTreeSet.from(subset, (a, b) => a.name.compareTo(b.name)));
    }
  }
  // return SplayTreeSet.from(result,  (a, b) => a.length.compareTo(b.length));
  final format = result.map((e) => e.join(',')).toList();
  format.sort((a, b) {
    if (a.length < b.length) {
      return -1;
    } else if (a.length > b.length) {
      return 1;
    } else {
      return a.compareTo(b);
    }
  });
  Set<Set<Attributes>> subsets = format.map((element) => Attributes.stringToAttributes(element)).toSet();
  subsets.removeWhere((e) => const SetEquality().equals(e, relation.toSet()));
  return subsets;
}

List<Set<Attributes>> findKeys(List<Attributes> attributes, List<FunctionalDependency> fds) {
  List<Set<Attributes>> keys = [];
  Set<Set<Attributes>>  combinations = generateSubsets(attributes);
  for (final combination in combinations) {
    var closure = closureOfSet(fds, combination.toList());
    if (closure.length == attributes.length) {
      keys.add(combination);
    }
  }
  return keys;
}

Set<Attributes> findPrimaryKey(List<Attributes> attributes, List<FunctionalDependency> fds) {
  List<Set<Attributes>> keys = findKeys(attributes, fds);
  if (keys.isEmpty) {
    return {};
  }

  // Example criteria: Choose key with the fewest attributes
  Set<Attributes> primaryKey = keys[0];

  for (var key in keys) {
    if (key.length < primaryKey.length) {
      primaryKey = key;
    }
  }
  return primaryKey;
}
