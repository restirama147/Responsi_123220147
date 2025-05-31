import 'package:flutter/material.dart';
import 'package:responsi_123220147/model/phone_model.dart';
import 'package:responsi_123220147/pages/home_page.dart';
import 'package:responsi_123220147/service/phone_service.dart';

class CreatePhonePage extends StatefulWidget {
  const CreatePhonePage({super.key});

  @override
  State<CreatePhonePage> createState() => _CreatePhonePageState();
}

class _CreatePhonePageState extends State<CreatePhonePage> {
  final TextEditingController model = TextEditingController();
  final TextEditingController brand = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController ram = TextEditingController();
  
  List<int> storage = [128, 256, 512];
  int inistorage = 128;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Data Movie"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(model, "Model", hint: "Masukkan model"),
              const SizedBox(height: 10),
              _buildTextField(brand, "Brand", hint: "Masukkan brand"),
              const SizedBox(height: 10),
              _buildTextField(price, "Price", keyboardType: TextInputType.number,hint: "Masukkan harga"),
              const SizedBox(height: 10),
              _buildTextField(ram, "RAM", keyboardType: TextInputType.number,hint: "RAM (GB)"),
              const SizedBox(height: 10),
              const Text("Storage", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: inistorage,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => inistorage = value);
                  }
                },
                items: storage.map((int storage) {
                  return DropdownMenuItem<int>(
                    value: storage,
                    child: Text("$storage"),
                  );
                }).toList(),
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _createPhone(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Tambah Data", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, String? hint}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: keyboardType == TextInputType.multiline ? null : 1,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label wajib diisi";
        }
        if ((label == "Price" || label == "RAM") &&
            int.tryParse(value.trim()) == null) {
          return "$label harus berupa angka valid";
        }
        return null;
      },
    );
  }
  
  Future<void> _createPhone(BuildContext context) async {
    try {
      if (model.text.trim().isEmpty ||
          price.text.trim().isEmpty ||
          brand.text.trim().isEmpty ||
          ram.text.trim().isEmpty ){
        throw Exception("Semua kolom wajib diisi.");
      }
      
      double priceInt = double.parse(price.text.trim());
      int ramInt = int.parse(ram.text.trim());

      Phone newPhone = Phone(
        model: model.text.trim(),
        storage: inistorage,
        brand: brand.text.trim(),
        ram: ramInt,
        price: priceInt,
      );

      final response = await PhoneService.createPhone(newPhone);

      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Phone Created")),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage(username: '')),
        );
      } else {
        throw Exception(response["message"] ?? "Terjadi kesalahan.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    }
  }

}