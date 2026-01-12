extension MapWithNullExtension<K, V> on Map<K, V> {
  Map<K, V> removeNulls() {
    removeWhere((_, v) => v == null);
    return this;
  }
}
