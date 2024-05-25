import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_motor/models/product_history.dart'
    as productHistoryModel;
import 'package:inventory_motor/providers/get_all_product_history_provider.dart';
import 'package:inventory_motor/providers/get_all_product_provider.dart';
import 'package:inventory_motor/utils/color.dart';
import 'package:inventory_motor/utils/status.dart';
import 'package:inventory_motor/widgets/appbar_widget.dart';
import 'package:inventory_motor/widgets/button_widget.dart';
import 'package:inventory_motor/widgets/rounded_textfield_widget.dart';
import 'package:provider/provider.dart';
import 'package:inventory_motor/providers/add_product_provider.dart';
import 'package:inventory_motor/providers/update_product_provider.dart';
import 'package:inventory_motor/models/product.dart';

class FormDataPage extends StatefulWidget {
  final Product? product;
  final productHistoryModel.ProductHistory? productHistory;

  const FormDataPage({
    super.key,
    this.product,
    this.productHistory,
  });

  @override
  State<FormDataPage> createState() => _FormDataPageState();
}

class _FormDataPageState extends State<FormDataPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _entryController = TextEditingController();
  final TextEditingController _exitController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Status? _selectedStatus;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _titleController.text = widget.product!.title;
      _dateController.text =
          widget.product!.date.toIso8601String().split('T').first;
      _entryController.text = widget.product!.entry.toString();
      _exitController.text = widget.product!.exit.toString();
      _descriptionController.text = widget.product!.description;
      _selectedStatus = widget.product!.status;
      _selectedImage = File(widget.product!.image);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _dateController.dispose();
    _entryController.dispose();
    _exitController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppbarWidget.myAppBar(
          null, widget.product == null ? "Tambah Produk" : "Update Produk"),
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
            DropdownButtonFormField<Status>(
              value: _selectedStatus,
              items: Status.values.map((Status status) {
                return DropdownMenuItem<Status>(
                  value: status,
                  child: Text(Product.statusToString(status)),
                );
              }).toList(),
              onChanged: (Status? newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            RoundedTextField(
              controller: _entryController,
              labelText: 'Jumlah Masuk',
              keyboardType: TextInputType.number,
            ),
            RoundedTextField(
              controller: _exitController,
              labelText: 'Jumlah Keluar',
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
                widget.product == null ? "Tambah Produk" : "Update Produk",
                SelectColor.kPrimary,
                SelectColor.kWhite,
                () => _submitForm(),
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
        SnackBar(content: Text("Tidak ada gambar/foto yang dipilih")),
      );
    }
  }

  void _submitForm() {
    if (_formIsValid()) {
      if (widget.product == null) {
        _addProduct();
      } else {
        _updateProduct();
      }
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
        _exitController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        (_selectedImage != null);
  }

  void _addProduct() {
    final provider = Provider.of<AddProductProvider>(context, listen: false);

    provider
        .addProduct(
      title: _titleController.text,
      date: DateTime.parse(_dateController.text),
      status: _selectedStatus!,
      entry: int.parse(_entryController.text),
      exit: int.parse(_exitController.text),
      description: _descriptionController.text,
      image: _selectedImage?.path ?? "",
    )
        .then((_) {
      if (provider.error == null) {
        final productProvider =
            Provider.of<GetAllProductProvider>(context, listen: false);
        productProvider.fetchProducts();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.error!)),
        );
      }
    });
  }

  void _updateProduct() {
    final provider = Provider.of<UpdateProductProvider>(context, listen: false);
    final productProvider =
        Provider.of<GetAllProductProvider>(context, listen: false);
    final productHistoryProvider =
        Provider.of<GetAllProductHistoryProvider>(context, listen: false);

    final updatedProduct = widget.product!.copyWith(
      title: _titleController.text,
      date: DateTime.parse(_dateController.text),
      status: _selectedStatus!,
      entry: int.parse(_entryController.text),
      exit: int.parse(_exitController.text),
      description: _descriptionController.text,
      image: _selectedImage?.path ?? "",
    );

    final updateProductHistory = productHistoryModel.ProductHistory(
      id: '',
      productId: updatedProduct.id,
      title: updatedProduct.title,
      date: updatedProduct.date,
      status: updatedProduct.status,
      description: updatedProduct.description,
      image: updatedProduct.image,
    );

    provider
        .updateProduct(updatedProduct, productProvider, productHistoryProvider,
            updateProductHistory)
        .then((_) {
      if (provider.error == null) {
        productProvider.fetchProducts();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.error!)),
        );
      }
    });
  }
}
