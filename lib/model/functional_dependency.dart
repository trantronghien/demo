

class FunctionalDependency {
  Set<String> leftSide;
  Set<String> rightSide;

  @override
  String toString() {
    return 'FunctionalDependency{leftSide: $leftSide, rightSide: $rightSide}';
  }

  FunctionalDependency(this.leftSide, this.rightSide);
}