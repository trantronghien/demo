class Attributes {
  final String name;

  Attributes(this.name);

  factory Attributes.of(String name) {
    return Attributes(name);
  }

  static Set<Attributes> stringToAttributes(String attributes) {
    return attributes.replaceAll(RegExp(r"\s+"), '').split(',').map((e) => Attributes.of(e)).toSet();
  }

  static List<String> attributesToListString(Iterable<Attributes> attributes) {
    return attributes.map((e) => e.name).toList();
  }

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attributes && runtimeType == other.runtimeType && name.toUpperCase().trim() == other.name.toUpperCase().trim();

  @override
  int get hashCode => name.hashCode;
}
