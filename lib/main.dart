import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes/dataListe_firestore.dart';
import 'firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:notes/UserState.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Firebase',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Auth Firebase'),
        '/auth': (context) => const AuthPage(),
        '/firestore': (context) => const FirestorePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required String title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Contenu de la page d\'accueil',
            ),
            // Display the user email if the user is logged in
            if (userState.user != null) Text('Email: ${userState.user!.email}'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context,
                    '/auth'); // Naviguer vers la page d'authentification
              },
              // Naviguer vers la page d'authentification
              child: const Text('Aller à l\'authentification'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context,
                    '/firestore'); // Naviguer vers la page de Firestore
              },
              // Naviguer vers la page de Firestore
              child: const Text('Aller à Firestore'),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut; // Se déconnecter de Firebase
              },
              child: const Text('Se déconnecter de Firebase'),
            )
          ],
        ),
      ),
    );
  }
}
