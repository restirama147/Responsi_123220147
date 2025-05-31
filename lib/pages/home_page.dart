import 'package:flutter/material.dart';
import 'package:responsi_123220147/model/phone_model.dart';
import 'package:responsi_123220147/pages/create_page.dart';
import 'package:responsi_123220147/pages/detail_page.dart';
import 'package:responsi_123220147/pages/edit_page.dart';
import 'package:responsi_123220147/pages/login_page.dart';
import 'package:responsi_123220147/service/phone_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.username, this.id});
  final String username;
  final int? id;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hallo, ${widget.username}"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _phoneContainer(),
      ),
    );
  }

  Widget _phoneContainer() {
    return FutureBuilder(
      future: PhoneService.getPhone(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Waduh! Gagal memuat data."));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          PhoneModel phoneModel = PhoneModel.fromJson(snapshot.data!);
          if (phoneModel.data == null || phoneModel.data!.isEmpty) {
            return const Center(child: Text("Belum ada data pakaian."));
          }
          return _phoneList(context, phoneModel.data!);
        } else {
          return const Center(child: Text("Tidak ada data."));
        }
      },
    );
  }

  Widget _phoneList(BuildContext context, List<Phone> phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const CreatePhonePage(),
              ),
            );
          },
          child: const Text("Add Phones"),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: phone.length,
            itemBuilder: (context, index) {
              final hp = phone[index];
              return Container(
                margin: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DetailPhonePage(id: hp.id!),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              hp.imageUrl!,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image);
                              },
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hp.model!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(hp.brand!),
                                Text("${hp.price}"),
                                const SizedBox(height: 10),
                              ],
                            ))
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditPhonePage(id: hp.id!),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                _confirmDelete(hp.id!);
                              },
                              color: Colors.red,
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Apakah Anda yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
            ),
            child: const Text("Hapus"),
            onPressed: () {
              Navigator.of(context).pop(); // tutup dialog
              _delete(id);
            },
          ),
        ],
      ),
    );
  }

  void _delete(int id) async {
    try {
      final response = await PhoneService.deletePhone(id);
      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Phone Removed")),
        );
        setState(() {}); // refresh data setelah delete
      } else {
        throw Exception(
            response["message"] ?? "Khusus HP ini tidak bisa dihapus");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $error")),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // tutup dialog
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(); // tutup dialog
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove("username");

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
