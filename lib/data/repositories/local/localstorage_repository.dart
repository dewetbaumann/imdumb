abstract class ILocalStorage {
  Future<void> create<T>({required String key, required T value});
  Future<T?> findOne<T>({required String key});
  Future<void> delete({required String key});
  Future<void> wipeStorage();
}
