import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventory_motor/data/local/product_db.dart';
import 'package:inventory_motor/pages/home_page.dart';
import 'package:inventory_motor/utils/color.dart';
import 'package:inventory_motor/widgets/button_widget.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final TextEditingController _pinController = TextEditingController();
  final int _correctPin = 491723;
  int _failedAttempts = 0;
  DateTime? _lockoutEndTime;
  bool _isLoginDisabled = false;

  @override
  void initState() {
    super.initState();
    _insertDefaultPin();
    _loadLockoutStatus();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _insertDefaultPin() async {
    const defaultPin = 491723;
    final db = ProductDatabase.instance;
    final existingPin = await db.getPin();
    if (existingPin == null) {
      await db.insertPin(defaultPin);
    }
  }

  Future<void> _loadLockoutStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _failedAttempts = prefs.getInt('failedAttempts') ?? 0;
    final lockoutEndTimeString = prefs.getString('lockoutEndTime');
    if (lockoutEndTimeString != null) {
      _lockoutEndTime = DateTime.parse(lockoutEndTimeString);
      if (DateTime.now().isAfter(_lockoutEndTime!)) {
        _resetFailedAttempts();
      } else {
        _startLockoutCountdown();
      }
    }
    setState(() {});
  }

  Future<void> _saveLockoutStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('failedAttempts', _failedAttempts);
    if (_lockoutEndTime != null) {
      await prefs.setString(
          'lockoutEndTime', _lockoutEndTime!.toIso8601String());
    } else {
      await prefs.remove('lockoutEndTime');
    }
  }

  void _startLockoutCountdown() {
    setState(() {
      _isLoginDisabled = true;
    });
    final remainingTime = _lockoutEndTime!.difference(DateTime.now());
    Future.delayed(remainingTime, () {
      _resetFailedAttempts();
      setState(() {
        _isLoginDisabled = false;
      });
    });
  }

  void _login() async {
    if (_isLoginDisabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Terlalu banyak percobaan gagal. Silakan coba lagi pada ${_lockoutEndTime!.hour}:${_lockoutEndTime!.minute}',
          ),
        ),
      );
      return;
    }

    if (int.tryParse(_pinController.text) == _correctPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login berhasil!')),
      );
      _resetFailedAttempts();
    } else {
      _failedAttempts++;
      if (_failedAttempts >= 4) {
        _lockoutEndTime = DateTime.now().add(const Duration(minutes: 5));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Terlalu banyak percobaan gagal. Silakan coba lagi dalam 5 menit.'),
          ),
        );
        _startLockoutCountdown();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('PIN salah! Percobaan gagal: $_failedAttempts/4')),
        );
      }
      await _saveLockoutStatus();
    }
  }

  void _resetFailedAttempts() async {
    setState(() {
      _failedAttempts = 0;
      _lockoutEndTime = null;
    });
    await _saveLockoutStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: SelectColor.kPrimary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Halaman Login",
                  style: TextStyle(
                    fontSize: 24,
                    color: SelectColor.kWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset('assets/auth.png'),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _pinController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Masukkan PIN',
                          counterText: '',
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ButtonWidget.myButton(
                          'Login',
                          SelectColor.kPrimary,
                          SelectColor.kWhite,
                          _isLoginDisabled ? null : () => _login(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
