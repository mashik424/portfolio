import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/contacts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_provider.g.dart';

@riverpod
Future<Contacts> fetchContacts(Ref ref) async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection('contacts').limit(1).get();

  if (snapshot.docs.isNotEmpty) {
    return Contacts.fromJson(snapshot.docs.first.data());
  } else {
    throw Exception('No contacts found');
  }
}
