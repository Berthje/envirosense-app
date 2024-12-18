import 'package:envirosense/presentation/views/add_device_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({
    required this.setResult,
    super.key,
  });

  final Function setResult;
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
   return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: MobileScanner(
        controller: controller,
        onDetect: (BarcodeCapture capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          final barcode = barcodes.first;

          if (barcode.rawValue != null) {
            setResult(barcode.rawValue);

            await controller
                .stop()
                .then((value) => controller.dispose())
                .then((value) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddDeviceScreen(),
                    ),
                  );
            });
          }
        },
      ),
    );
  }
}
