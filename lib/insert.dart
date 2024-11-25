import 'package:flutter/material.dart';
import 'package:perpustakaan/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _addBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final title = _titleController.text;
    final author = _authorController.text;
    final description = _descriptionController.text;

    final response = await Supabase.instance.client.from('Buku').insert([
      {
        'title': title, 
        'author': author, 
        'description': description}
    ]);
    if (response != null) {
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: ${response}')));
    } else {
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Book added')));
      _titleController.clear();
      _authorController.clear();
      _descriptionController.clear();

      Navigator.pop(context, true);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const BookListPage()));
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Tambah Buku'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Buku',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  )
                ),
                style: TextStyle(
                  color: Colors.white
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul Dilarang kosong!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Penulis',
                  labelStyle: TextStyle(
                    color: Colors.white
                  )
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Penulis Dilarang kosong!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  labelStyle: TextStyle(
                    color: Colors.white
                  )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi Dilarang kosong!';
                  }
                  return null;
                },
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addBook,
                child: Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
