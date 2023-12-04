import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:notes/dataListe_firestore.dart';
import 'package:notes/UserState.dart';
import 'package:notes/getUser.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() async {
    try {
      // Vérifier le format de l'e-mail
      if (!_isValidEmail(_emailController.text) ||
          !_isValidPassword(_passwordController.text)) {
        //Afficher le message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Veuillez saisir des informations valides"),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      // Code synchrone avant l'appel asynchrone
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Utilisateur enregistré avec succès
      Future.microtask(() {
        Provider.of<UserState>(context, listen: false)
            .setUser(userCredential.user);
      });

      // Afficher le message de succès
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Utilisateur enregistré avec succès'),
            duration: Duration(seconds: 3),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      // Gérer les erreurs FirebaseAuth
      String errorText = 'Erreur lors de l\'enregistrement.';

      if (e.code == 'weak-password') {
        errorText = 'Le mot de passe est trop faible.';
      } else if (e.code == 'email-already-in-use') {
        errorText = 'Un compte existe déjà avec cette adresse e-mail.';
      } else if (e.code == 'invalid-email') {
        errorText = 'L\'adresse e-mail est invalide.';
      }
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorText),
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }
  }

// Fonction pour vérifier le format de l'e-mail
  bool _isValidEmail(String email) {
    // Utilisez une expression régulière pour valider le format de l'e-mail
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
    );
    return emailRegExp.hasMatch(email);
  }

  void _login() async {
    try {
      // Vérifier le format de l'e-mail
      if (!_isValidEmail(_emailController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('L\'adresse e-mail est mal formatée.'),
            duration: Duration(seconds: 3),
          ),
        );
        return; // Arrêter l'exécution si l'e-mail n'est pas correctement formaté
      }

      // Vérifier la force du mot de passe
      if (!_isValidPassword(_passwordController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Le mot de passe est trop faible.'),
            duration: Duration(seconds: 3),
          ),
        );
        return; // Arrêter l'exécution si le mot de passe n'est pas assez fort
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      Future.microtask(() {
        Provider.of<UserState>(context, listen: false)
            .setUser(userCredential.user);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const GetUserPage()));
      });
    } catch (e) {
      // Gérer les erreurs
      String errorText = 'Erreur lors de la connexion.';

      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          errorText = 'L\'adresse e-mail ou le mot de passe est incorrect.';
        } else if (e.code == 'user-disabled') {
          errorText =
              'Le compte associé à cette adresse e-mail a été désactivé.';
        } else if (e.code == 'invalid-email') {
          errorText = 'L\'adresse e-mail est invalide.';
        }
      }
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorText),
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }
    return;
  }

// Fonction pour vérifier la force du mot de passe
  bool _isValidPassword(String password) {
    return password.length >= 5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Authentification'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                // Afficher le message d'erreur
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _register(),
                  child: const Text("S'enregistrer"),
                ),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Se connecter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
