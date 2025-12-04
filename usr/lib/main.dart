import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const IPnameApp());
}

class IPnameApp extends StatelessWidget {
  const IPnameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPname',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _usernameController = TextEditingController();
  String _ipAddress = '';
  String _searchedUsername = '';
  final List<String> _savedIpAddresses = [];

  void _findIpAddress() {
    final username = _usernameController.text;
    if (username.isNotEmpty) {
      // IMPORTANT: This is a simulation. It is not possible to get a user's IP address
      // from their YouTube username for privacy and security reasons.
      // We are generating a random IP address for demonstration purposes.
      final random = Random();
      final ip =
          '${random.nextInt(255)}.${random.nextInt(255)}.${random.nextInt(255)}.${random.nextInt(255)}';
      setState(() {
        _ipAddress = ip;
        _searchedUsername = username;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username.')),
      );
    }
  }

  void _saveIpAddress() {
    if (_ipAddress.isNotEmpty &&
        !_savedIpAddresses.contains('$_searchedUsername: $_ipAddress')) {
      setState(() {
        _savedIpAddresses.add('$_searchedUsername: $_ipAddress');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('IP Address saved!')),
      );
    }
  }

  void _deleteIpAddress(int index) {
    setState(() {
      _savedIpAddresses.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved IP Address removed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IPname'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Enter YouTube Username',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _findIpAddress(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _findIpAddress,
              child: const Text('Find IP Address'),
            ),
            const SizedBox(height: 24),
            if (_ipAddress.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IP Address for "$_searchedUsername":',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _ipAddress,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.save_alt),
                        onPressed: _saveIpAddress,
                        tooltip: 'Save IP Address',
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              'Saved IP Addresses',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _savedIpAddresses.isEmpty
                  ? const Center(child: Text('No IP addresses saved yet.'))
                  : ListView.builder(
                      itemCount: _savedIpAddresses.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_savedIpAddresses[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deleteIpAddress(index),
                              tooltip: 'Delete Saved IP',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
