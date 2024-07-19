import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_motor/providers/add_product_provider.dart';
import 'package:inventory_motor/providers/get_all_product_provider.dart';
import 'package:provider/provider.dart';
import 'package:inventory_motor/widgets/appbar_widget.dart';
import 'package:inventory_motor/widgets/button_widget.dart';
import 'package:inventory_motor/widgets/rounded_textfield_widget.dart';
import 'package:inventory_motor/utils/color.dart';
import 'package:inventory_motor/utils/status.dart';

class FormEntryPage extends StatefulWidget {
  const FormEntryPage({super.key});

  @override
  State<FormEntryPage> createState() => _FormEntryPageState();
}

class _FormEntryPageState extends State<FormEntryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _entryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  File? _selectedImage;
  Status? _selectedStatus = Status.masuk;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _dateController.dispose();
    _entryController.dispose();
    _descriptionController.dispose();
    _totalController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppbarWidget.myAppBar(null, "Tambah Data Masuk"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RoundedTextField(
              controller: _titleController,
              labelText: 'Nama Produk',
            ),
            RoundedTextField(
              controller: _dateController,
              labelText: 'Tanggal',
              keyboardType: TextInputType.datetime,
              onTap: () => _selectDate(context),
            ),
            RoundedTextField(
              controller: _entryController,
              labelText: 'Jumlah Masuk',
              keyboardType: TextInputType.number,
            ),
            RoundedTextField(
              controller: _totalController,
              labelText: 'Total Saat Ini',
              keyboardType: TextInputType.number,
            ),
            RoundedTextField(
              controller: _descriptionController,
              labelText: 'Deskripsi',
              isMultiline: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 150,
              child: ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: SelectColor.kPrimary,
                  foregroundColor: Colors.white,
                ),
                child: _selectedImage == null
                    ? const Icon(
                        Icons.image,
                        size: 54,
                      )
                    : Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ButtonWidget.myButton(
                "Tambah Data Masuk",
                SelectColor.kPrimary,
                SelectColor.kWhite,
                _submitForm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = selectedDate.toIso8601String().split('T').first;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada gambar/foto yang dipilih")),
      );
    }
  }

  void _submitForm() {
    if (_formIsValid()) {
      _addProduct();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ada yang masih kosong")),
      );
    }
  }

  bool _formIsValid() {
    return _titleController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _entryController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _totalController.text.isNotEmpty &&
        (_selectedImage != null);
  }

  void _addProduct() {
    final provider = Provider.of<AddProductProvider>(context, listen: false);
    final productProvider =
        Provider.of<GetAllProductProvider>(context, listen: false);
    int total =
        int.parse(_entryController.text) + int.parse(_totalController.text);
    provider
        .addProduct(
      title: _titleController.text,
      date: DateTime.parse(_dateController.text),
      status: _selectedStatus!,
      entry: int.parse(_entryController.text),
      exit: 0,
      description: _descriptionController.text,
      image: _selectedImage?.path ?? "",
      total: total,
    )
        .then((_) async {
      if (provider.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produk berhasil ditambahkan")),
        );
        await productProvider.fetchProducts();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.error!)),
        );
      }
    });
  }
}
