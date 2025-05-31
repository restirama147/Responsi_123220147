import 'package:flutter/material.dart';
import 'package:responsi_123220147/model/phone_model.dart';
import 'package:responsi_123220147/service/phone_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPhonePage extends StatefulWidget {
  final int id;
  const DetailPhonePage({super.key, required this.id});

  @override
  State<DetailPhonePage> createState() => _DetailPhonePageState();
}

class _DetailPhonePageState extends State<DetailPhonePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Phones"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: _phoneDetail(),
      ),
    );
  }

  Widget _phoneDetail() {
    return FutureBuilder(
      future: PhoneService.getPhoneById(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          Phone phone = Phone.fromJson(snapshot.data!["data"]);
          return _phone(phone);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _phone(Phone phone) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              phone.imageUrl ?? '',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[300],
                  child:
                      const Center(child: Icon(Icons.broken_image, size: 60)),
                );
              },
            ),
          ),
          const SizedBox(width: 30,),
          const SizedBox(height: 16),
          _buildDetailRow("Model", phone.model ?? "-"),
          _buildDetailRow("Brand", phone.brand ?? "-"),
          _buildDetailRow("Price", phone.price?.toString() ?? "-"),
          _buildDetailRow("RAM", phone.ram?.toString() ?? "-"),
          _buildDetailRow("Storage", phone.storage?.toString() ?? "-"),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_circle_fill, color: Colors.white),
              label: const Text(
                "Phone Website",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final url = Uri.parse(phone.websiteUrl ?? '');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("URL tidak valid")),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
