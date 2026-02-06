import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'component_photo_dao.g.dart';

@DriftAccessor(tables: [ComponentPhotos, Components])
class ComponentPhotoDao extends DatabaseAccessor<AppDatabase>
    with _$ComponentPhotoDaoMixin {
  ComponentPhotoDao(AppDatabase db) : super(db);

  Future<void> upsertPhotos(List<ComponentPhotosCompanion> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(componentPhotos, list);
    });
  }

  Future<List<ComponentPhoto>> getByComponent(String componentId) {
    return (select(componentPhotos)
          ..where((p) => p.componentId.equals(componentId))
          ..orderBy([(p) => OrderingTerm(expression: p.sortOrder)]))
        .get();
  }

  Future<List<ComponentPhoto>> getPendingPhotos() {
    return (select(
      componentPhotos,
    )..where((p) => p.needSync.equals(true))).get();
  }

  Future<void> markPhotosSynced(List<String> ids) async {
    if (ids.isEmpty) return;
    await (update(componentPhotos)..where((p) => p.id.isIn(ids))).write(
      const ComponentPhotosCompanion(needSync: Value(false)),
    );
  }

  Future<void> markUploaded({
    required String id,
    required String uploadedUrl,
    required DateTime lastModifiedAt,
  }) async {
    await (update(componentPhotos)..where((p) => p.id.equals(id))).write(
      ComponentPhotosCompanion(
        remoteUrl: Value(uploadedUrl),
        needSync: const Value(true),
        lastModifiedAt: Value(lastModifiedAt),
      ),
    );
  }
}
