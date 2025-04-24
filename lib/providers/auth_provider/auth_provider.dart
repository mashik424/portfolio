import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';
part 'auth_states.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        state = SignedIn(user);
      } else {
        state = const AuthInitial();
      }
    });
    return const AuthInitial();
  }

  late FirebaseAuth _firebaseAuth;

  Future<void> signIn(String password) async {
    final auth = FirebaseAuth.instance;
    state = const SigningIn();
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: dotenv.env['EMAIL'] ?? '',
        password: password,
      );

      state = SignedIn(credential.user);
    } on Exception catch (e) {
      state = AuthError(e);
    }
  }
}
