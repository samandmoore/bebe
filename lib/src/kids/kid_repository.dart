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
    );

    final newKids = [
      ...kids,
      newKid,
    ];

    await _storage.save(_storageKey, newKids);

    return newKid;
  }

  Future<void> update(final Kid kid) async {
    final kids = await fetchAll();

    final newKids = [
      ...kids.where((k) => k.id != kid.id),
      kid,
    ];

    await _storage.save(_storageKey, newKids);
  }

  Future<void> delete(final String id) async {
    final kids = await fetchAll();

    final newKids = kids.where((k) => k.id != id).toList();

    await _storage.save(_storageKey, newKids);
  }
}
