import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static bool isInitialize = false;

  static Future<void> initSignIn() async {
    if (!isInitialize) {
      await _googleSignIn.initialize(
        serverClientId:
            '569173351536-64jhilf8gsr5ppftsi10sb0onieg8r9u.apps.googleusercontent.com',
      );
      isInitialize = true;
    }
  }

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // 🔹 GARANTE QUE O GOOGLE SIGN IN FOI INICIALIZADO
      await initSignIn();

      // 🔹 AUTENTICA
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // 🔹 ESPERA OS TOKENS CARREGAREM
      final googleAuth = await googleUser.authentication;

      final authorizationClient = googleUser.authorizationClient;
      GoogleSignInClientAuthorization? authorization = await authorizationClient
          .authorizationForScopes(['email', 'profile']);

      final accessToken = authorization?.accessToken;

      if (googleAuth.idToken == null || accessToken == null) {
        throw FirebaseAuthException(
          code: "token_error",
          message: "Falha ao obter tokens de autenticação.",
        );
      }

      // 🔹 CRIA CREDENTIAL
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: googleAuth.idToken,
      );

      // 🔹 LOGIN NO FIREBASE
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // 🔹 RECARREGA PARA GARANTIR QUE UID E EMAIL ESTÃO DISPONÍVEIS
      await _auth.currentUser?.reload();
      final User? user = _auth.currentUser;

      if (user == null) {
        throw FirebaseAuthException(
          code: "user-null",
          message: "Usuário não retornado após login.",
        );
      }

      // 🔹 AGORA SIM — FIRESTORE SÓ AQUI
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'provider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}
