import 'package:bebe/src/shared/jitter.dart';
import 'package:bebe/src/storage/storage.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'kid.dart';

class KidRepository {
  final String _storageKey = 'kids';

  final Ref ref;

  KidRepository(this.ref);

  LocalStorage get _storage => ref.read(storageProvider);

  Future<List<Kid>> fetchAll() async {
    await jitter();

    final data = await _storage.load(_storageKey);

    if (data == null) {
      return [];
    }

    final list = data as List<Object?>;
    return list.map((k) => Kid.fromJson(k as Map<String, Object?>)).toList();
  }

  Future<Kid?> fetchById(final String id) async {
    final kids = await fetchAll();
    return kids.firstWhereOrNull((k) => k.id == id);
  }

  Future<Kid> create(final KidInput kid) async {
    final kids = await fetchAll();

    final newKid = Kid(
      id: const Uuid().v4(),
      name: kid.name,
      birthDate: kid.birthDate,
      isCurrent: true,
    );

    final newKids = [
      ...kids.map((k) => k.copyWith(isCurrent: false)),
      newKid,
    ];

    await _storage.save(_storageKey, newKids.toList());

    return newKid;
  }

  Future<void> update(final Kid kid) async {
    final kids = await fetchAll();

    var newKids = kids.where((k) => k.id != kid.id);
    if (kid.isCurrent) {
      newKids = newKids.map((k) => k.copyWith(isCurrent: false));
    }

    newKids = [
      ...newKids,
      kid,
    ];

    await _storage.save(_storageKey, newKids.toList());
  }

  Future<void> delete(final String id) async {
    final kids = await fetchAll();

    final kidToDelete = kids.firstWhereOrNull((k) => k.id == id);

    if (kidToDelete == null) {
      return;
    }

    var newKids = kids.where((k) => k.id != id);
    if (kidToDelete.isCurrent) {
      newKids = newKids.map((k) => k.copyWith(isCurrent: false));
    }

    await _storage.save(_storageKey, newKids.toList());
  }
}
