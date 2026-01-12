abstract class ApiRepository<Entity, DTO> {
  Future<List<Entity>> findAll();
  Future<Entity> findById(String id);
  Future<Entity> findOne(DTO dto);
  Future<void> create(DTO dto);
  Future<void> update(String id, DTO dto);
  Future<void> delete(String id);
}
