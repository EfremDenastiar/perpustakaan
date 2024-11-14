import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class bookListPage extends StatefulWidget {
  const bookListPage({super.key});

  @override
  State<bookListPage> createState() => _bookListPageState();
}

class _bookListPageState extends State<bookListPage> {
  List<Map<String, dynamic>> Buku = [];

  @override

  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async{
    final response = await Supabase.instance.client
        .from('Buku')
        .select();

    setState(() {
      Buku = List<Map<String, dynamic>>.from(response);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perpustakaan'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: fetchBooks, 
            icon: Icon(Icons.refresh))
        ],
      ),
      body: Buku.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
            itemCount: Buku.length,
            itemBuilder: (context, index) {
              final dataBuku = Buku[index];
              return ListTile(
                title: Text(dataBuku['judul'] ?? 'No Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dataBuku['penulis'] ?? 'No Author', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                    Text(dataBuku['deskripsi'] ?? 'No Author', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton( //tombol edit
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.edit, color: Colors.orange,)
                    ),
                    IconButton( //tombol hapus
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      icon: Icon(Icons.delete, color: Colors.red,)
                    )
                  ],
                ),
              );
            })
    );
  }
}