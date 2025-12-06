import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'variant_photo_dao.g.dart';

@DriftAccessor(tables: [VariantPhotos, Variants])
class VariantPhotoDao extends DatabaseAccessor<AppDatabase>
    with _$VariantPhotoDaoMixin {
  VariantPhotoDao(AppDatabase db) : super(db);

  Future<void> upsertPhotos(List<VariantPhotosCompanion> list) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(variantPhotos, list);
    });
  }

  Future<List<VariantPhoto>> getByVariant(String variantId) {
    return (select(variantPhotos)
          ..where((p) => p.variantId.equals(variantId))
          ..orderBy([(p) => OrderingTerm(expression: p.sortOrder)]))
        .get();
  }

  Future<List<VariantPhoto>> getPendingPhotos() {
    return (select(variantPhotos)..where((p) => p.needSync.equals(true))).get();
  }

  Future<void> markPhotosSynced(List<String> ids) async {
    if (ids.isEmpty) return;
    await (update(variantPhotos)..where((p) => p.id.isIn(ids))).write(
      const VariantPhotosCompanion(needSync: Value(false)),
    );
  }

  Future<void> markUploaded({
    required String id,
    required String uploadedUrl,
    required DateTime lastModifiedAt,
  }) async {
    await (update(variantPhotos)..where((p) => p.id.equals(id))).write(
      VariantPhotosCompanion(
        remoteUrl: Value(uploadedUrl),
        needSync: const Value(true),
        lastModifiedAt: Value(lastModifiedAt),
      ),
    );
  }
}
