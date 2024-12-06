import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String scannedCode = 'Code Not Found';
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  void _onDetect(String code) {
    setState(() {
      scannedCode = code.isNotEmpty ? code : 'Code Not Found';
    });
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose the controller to release resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: [
          // Torch Toggle
          IconButton(
            icon: Icon(
              controller.torchEnabled ? Icons.flash_on : Icons.flash_off,
              color: controller.torchEnabled ? Colors.yellow : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                controller.toggleTorch();
              });
            },
          ),
          // Camera Facing Toggle
          IconButton(
            icon: const Icon(Icons.switch_camera),
            onPressed: () {
              setState(() {
                controller.switchCamera();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) {
                if (capture.barcodes.isNotEmpty) {
                  _onDetect(
                      capture.barcodes.first.rawValue ?? 'Code Not Found');
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            height: 150,
            alignment: Alignment.center,
            child: Text(
              scannedCode,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
