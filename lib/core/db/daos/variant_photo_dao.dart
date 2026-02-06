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

  Future<List<VariantPhoto>> getPhotosByVariantId(String variantId) async {
    return await (select(variantPhotos)
          ..where((p) => p.variantId.equals(variantId) & p.deletedAt.isNull())
          ..orderBy([(p) => OrderingTerm(expression: p.sortOrder)]))
        .get();
  }

  /// Soft delete photo
  Future<void> softDeletePhoto(String photoId) async {
    await (update(variantPhotos)..where((p) => p.id.equals(photoId))).write(
      VariantPhotosCompanion(
        deletedAt: Value(DateTime.now()),
        lastModifiedAt: Value(DateTime.now()),
        needSync: const Value(true),
      ),
    );
  }

  /// Delete all photos for a variant (soft delete)
  Future<void> softDeletePhotosByVariantId(String variantId) async {
    await (update(
      variantPhotos,
    )..where((p) => p.variantId.equals(variantId))).write(
      VariantPhotosCompanion(
        deletedAt: Value(DateTime.now()),
        lastModifiedAt: Value(DateTime.now()),
        needSync: const Value(true),
      ),
    );
  }

  Future<List<VariantPhoto>> getByVariant(String variantId) {
    return (select(variantPhotos)
          ..where((p) => p.variantId.equals(variantId))
          ..orderBy([(p) => OrderingTerm(expression: p.sortOrder)]))
        .get();
  }

  /// Update local path setelah download berhasil
  Future<void> updateLocalPath({
    required String photoId,
    required String localPath,
  }) async {
    await (update(variantPhotos)..where((p) => p.id.equals(photoId))).write(
      VariantPhotosCompanion(
        localPath: Value(localPath),
        updatedAt: Value(DateTime.now()),
        lastModifiedAt: Value(DateTime.now()),
        // needSync tetap false karena ini hanya update local cache
      ),
    );
  }

  /// Get photos yang perlu di-download (punya remoteUrl tapi belum ada localPath)
  Future<List<VariantPhoto>> getPhotosNeedDownload(String variantId) async {
    return await (select(variantPhotos)..where(
          (p) =>
              p.variantId.equals(variantId) &
              p.remoteUrl.isNotNull() &
              (p.localPath.isNull() | p.localPath.equals('')) &
              p.deletedAt.isNull(),
        ))
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
