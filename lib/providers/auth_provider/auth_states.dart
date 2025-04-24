part of 'auth_provider.dart';

abstract class AuthState {
  const AuthState();
  bool get isLoggedin;
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  bool get isLoggedin => false;
}

class SigningIn extends AuthState {
  const SigningIn();
  @override
  bool get isLoggedin => false;
}

class SignedIn extends AuthState {
  const SignedIn(this.user);
  final User? user;

  @override
  bool get isLoggedin => user != null;
}

class AuthError extends AuthState {
  const AuthError(this.error);
  final Exception error;

  @override
  bool get isLoggedin => false;
}
