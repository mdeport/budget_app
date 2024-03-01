import 'package:application_budget_app/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<UserModel> get user {
    return _auth.authStateChanges().asyncMap(
        (user) => UserModel(uid: user!.uid, email: user.email!, password: ''));
  }

  Future<UserModel> signIn(UserModel userModel) async {
    UserCredential userCredential;
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
          email: userModel.email, password: userModel.password);
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'wrong-password') {
          return UserModel(
              uid: '',
              email: '',
              password: '',
              errorMessage: 'Mot de passe incorrect.');
        } else if (e.code == 'user-not-found') {
          return UserModel(
              uid: '',
              email: '',
              password: '',
              errorMessage: 'Adresse e-mail non trouvée.');
        } else if (e.code == 'invalid-email') {
          return UserModel(
              uid: '',
              email: '',
              password: '',
              errorMessage: 'Adresse e-mail invalide.');
        } else if (e.code == 'invalid-credential') {
          return UserModel(
              uid: '',
              email: '',
              password: '',
              errorMessage: 'Adresse e-mail ou mot de passe incorrect.');
        }
      }
      // Gérer d'autres erreurs Firebase ou erreurs inattendues ici
      return UserModel(
          uid: '',
          email: '',
          password: '',
          errorMessage: 'Une erreur s\'est produite. Veuillez réessayer.');
    }

    userModel.setUid = userCredential.user!.uid;

    return userModel;
  }

  Future<UserModel> signUp(UserModel userModel) async {
    UserCredential userCredential;
    try {
      final userExists =
          await _auth.fetchSignInMethodsForEmail(userModel.email);
      if (userExists.isNotEmpty) {
        throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'Cette adresse e-mail est déjà utilisée.');
      }

      userCredential = await _auth.createUserWithEmailAndPassword(
          email: userModel.email, password: userModel.password);
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          return UserModel(
              uid: '',
              email: '',
              password: '',
              errorMessage: 'Cette adresse e-mail est déjà utilisée.');
        }
      }
      // Renvoyer l'erreur si ce n'est pas une adresse e-mail déjà utilisée
      throw e;
    }

    userModel.setUid = userCredential.user!.uid;

    return userModel;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
