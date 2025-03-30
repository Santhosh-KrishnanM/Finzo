import 'package:flutter/material.dart';
import 'package:flutter_application_1/CalculatorPage.dart';
import 'package:flutter_application_1/ProfilePage.dart';
import 'package:flutter_application_1/SettingsPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: MyHomePage(onToggleTheme: _toggleTheme),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Function(bool) onToggleTheme;

  const MyHomePage({super.key, required this.onToggleTheme});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const HomeScreen(),
    const ProfilePage(),
    SettingsPage(
      isDarkMode: false,
      toggleTheme: (bool) {},
    ),
    const CalculatorPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        print('Home');
        break;
      case 1:
        print('Profile');
        break;
      case 2:
        print('Settings');
        break;
      case 3:
        print('Calculator');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finzo'),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Nishanth'),
              accountEmail: Text('Nishu2005@gmail.com'),
            ),
            ListTile(
              title: const Text('Home'),
              leading: const Icon(Icons.home),
              onTap: () {
                setState(() {
                  _currentIndex = 0; // Change to Home
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Profile'),
              leading: const Icon(Icons.person),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              leading: const Icon(Icons.settings),
              onTap: () {
                setState(() {
                  _currentIndex = 2; // Change to Settings
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Calculator'),
              leading: const Icon(Icons.calculate),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_applications_rounded),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            label: 'Calculator',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            '',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Financial Overview:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            child: ListTile(
              title: const Text('Income'),
              trailing: const Text('\$5000'), // Example static value
            ),
          ),
          const SizedBox(height: 5),
          Card(
            elevation: 2,
            child: ListTile(
              title: const Text('Expenses'),
              trailing: const Text('\$3000'), // Example static value
            ),
          ),
          const SizedBox(height: 5),
          Card(
            elevation: 2,
            child: ListTile(
              title: const Text('Net Balance'),
              trailing: const Text('\$2000'), // Example static value
            ),
          ),
        ],
      ),
    );
  }
}
