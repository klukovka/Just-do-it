import 'package:firebase_auth/firebase_auth.dart';
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
      print(e.message!);
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
      print(e.message!);
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

    } catch (e) {
      print(e);
    }
  }

  logoutGoogle() {
    googleSignin.signOut();
  }

  logout(){
    authService.logout();

  }
}
