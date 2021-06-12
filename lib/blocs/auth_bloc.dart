import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_do_it/services/auth_api.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignin = GoogleSignIn(scopes: ['email']);

  Stream<User?> get currentUser => authService.currentUser;

  Future<User> createUserWithEmail(String _email, String _password) async {
    late User user;
    try {
      user = (await authService.auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      ))
          .user!;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception(_cutExceptionMessage(e));
    }
    return user;
  }

  Future<User> signInWithEmail(String _email, String _password) async {
    late User user;
    try {
      user = (await authService.auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      ))
          .user!;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception(_cutExceptionMessage(e));
    }
    return user;
  }

  loginGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignin.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      //fire base sign in

      final result = await authService.signInWithCredential(credential);
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception(_cutExceptionMessage(e));
    }
  }

  logoutGoogle() {
    googleSignin.signOut();
  }

  logout() {
    authService.logout();
  }

  _cutExceptionMessage(dynamic e) {
    String result = '$e';
    int start = result.indexOf(']') == -1 ? 0 : result.indexOf(']') + 2;
    return result.substring(start);
  }
}
