import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'insert.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Map<String, dynamic>> Buku = [];
  List<bool> _isHovered = [];

  @override
  void initState() {
    super.initState();
    fetchBuku();
  }

  Future<void> fetchBuku() async {
    final response = await Supabase.instance.client.from('Buku').select();

    setState(() {
      Buku = List<Map<String, dynamic>>.from(response);
      _isHovered = List.filled(Buku.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Perpustakaan'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: fetchBuku,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Buku.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: Buku.length,
                itemBuilder: (context, index) {
                  final dataBuku = Buku[index];

                  return MouseRegion(
                    onEnter: (_) => setState(() {
                      _isHovered[index] = true;
                    }),
                    onExit: (_) => setState(() {
                      _isHovered[index] = false;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isHovered[index] ? Colors.grey[800] : Colors.grey[850],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _isHovered[index]
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dataBuku['title'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Penulis: ${dataBuku['author'] ?? 'Unknown'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dataBuku['description'] ?? 'No Description',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman untuk menambah buku baru
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBookPage(),
            ),
          );
        },
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
