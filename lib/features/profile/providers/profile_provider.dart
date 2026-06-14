import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/emergency_contact.dart';
import '../../../providers/app_providers.dart';

class ContactsNotifier extends AutoDisposeAsyncNotifier<List<EmergencyContact>> {
  @override
  Future<List<EmergencyContact>> build() async {
    final repo = ref.watch(emergencyRepoProvider);
    return await repo.getContactsForUser('default_user_1');
  }

  Future<void> addContact(String name, String phone, String relation) async {
    final repo = ref.read(emergencyRepoProvider);
    final contact = EmergencyContact(
      id: const Uuid().v4(),
      userId: 'default_user_1',
      name: name,
      phone: phone,
      relation: relation,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await repo.addEmergencyContact(contact);
    ref.invalidateSelf();
  }

  Future<void> deleteContact(String id) async {
    final repo = ref.read(emergencyRepoProvider);
    await repo.deleteContact(id);
    ref.invalidateSelf();
  }
}

final contactsProvider = AsyncNotifierProvider.autoDispose<ContactsNotifier, List<EmergencyContact>>(() {
  return ContactsNotifier();
});
