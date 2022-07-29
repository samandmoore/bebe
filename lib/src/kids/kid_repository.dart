import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import 'kid.dart';

class KidRepository {
  List<Kid> _kids = <Kid>[];

  Future<List<Kid>> fetchAll() async => _kids.toList();

  Future<Kid?> fetchById(final String id) async {
    return _kids.firstWhereOrNull((k) => k.id == id);
  }

  Future<Kid> create(final KidInput kid) async {
    final newKid = Kid(
      id: const Uuid().v4(),
      name: kid.name,
      birthDate: kid.birthDate,
    );

    _kids = [
      ..._kids,
      newKid,
    ];

    return newKid;
  }

  Future<void> update(final Kid kid) async {
    _kids = [
      ..._kids.where((k) => k.id != kid.id),
      kid,
    ];
  }

  Future<void> delete(final String id) async {
    _kids = _kids.where((k) => k.id != id).toList();
  }
}
