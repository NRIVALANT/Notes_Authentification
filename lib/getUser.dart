import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/UserState.dart';
import 'package:notes/firebase_auth.dart';
import 'package:provider/provider.dart';

class GetUserPage extends StatefulWidget {
  const GetUserPage({Key? key}) : super(key: key);

  @override
  State<GetUserPage> createState() => _GetUserPageState();
}

class _GetUserPageState extends State<GetUserPage> {
  @override
  void initState() {
    super.initState();
    checkAuthenticationStatus();
  }

  void checkAuthenticationStatus() {
    User? user = Provider.of<UserState>(context, listen: false).user;

    if (user == null) {
      // L'utilisateur n'est pas connecté, redirigez-le vers la page de connexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer l'utilisateur connecté
    User? user = Provider.of<UserState>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilisateur connecté'),
      ),
      body: ListView(
        children: [
          Text('Utilisateur connecté : ${user?.email ?? 'Unknown email'}'),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/firestore');
            },
            child: const Text('Aller à Firestore'),
          ),
          ElevatedButton(
            onPressed: () {
              // Se déconnecter et rediriger vers la page de connexion
              FirebaseAuth.instance.authStateChanges().listen((User? user) {
                if (user == null) {
                  const Text('Utilisateur déconnecté');
                } else {
                  const Text('Utilisateur connecté');
                }
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthPage(),
                ),
              );
            },
            child: const Text('Se déconnecter'),
          ),
          // Ajoutez d'autres widgets pour afficher plus d'informations si nécessaire
        ],
      ),
    );
  }
}
