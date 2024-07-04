import 'package:flutter/material.dart';
import 'package:inventory_motor/widgets/appbar_widget.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget.myAppBar(null, 'Tentang'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Center(
                  child: Text(
                "Kelompok 4",
                style: TextStyle(
                  fontSize: 20,
                ),
              )),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profile(
                    'Shaiful Anam',
                    'Project Manager',
                    'assets/photo/ipul.webp',
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  profile(
                    'Ifqy Gifha Azhar',
                    'Programmer & UI/UX',
                    'assets/photo/ifqy.jpg',
                  ),
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profile(
                    'Qarel Irham Hildry Java',
                    'Penyusun Laporan',
                    'assets/photo/qarel.webp',
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  profile(
                    'Ineke Ayu Syafira',
                    'Mockup Aplikasi',
                    'assets/photo/ineke.webp',
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Versi Aplikasi 1.0",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column profile(String name, title, img) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Image.asset(
            img,
            fit: BoxFit.cover,
            width: 180,
            height: 180,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(title),
      ],
    );
  }
}
