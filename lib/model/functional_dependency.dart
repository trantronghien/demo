

import 'package:untitled/model/attributes.dart';

class FunctionalDependency {
  Set<Attributes> leftSide;
  Set<Attributes> rightSide;

  @override
  String toString() {
    return '{ ${leftSide.join(',')} -> ${rightSide.join(',')} }';
  }

  FunctionalDependency(this.leftSide, this.rightSide);

  static Set<Attributes> findRelationLeftRight(List<FunctionalDependency> fds) {
    Set<Attributes> result = {};
    for(final f in fds){
      result.addAll(f.leftSide);
      result.addAll(f.rightSide);
    }
    return result;
  }
}