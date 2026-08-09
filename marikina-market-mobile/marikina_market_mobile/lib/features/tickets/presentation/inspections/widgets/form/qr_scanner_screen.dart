import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_event.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_state.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/form/scanner_corner_pointer.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({
    super.key
  });

  @override
  State<StatefulWidget> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back
  );

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    _controller.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  final double _scanWindowSize = 250.0;

  bool _isScanned = false;
  bool _multipleDetected = false;

  Rect _calculateScanWindow(Size screenSize) {
    final double left = (screenSize.width - _scanWindowSize) / 2;
    final double top = (screenSize.height - _scanWindowSize) / 2;
    return Rect.fromLTWH(left, top, _scanWindowSize, _scanWindowSize);
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isScanned) return;

    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.length > 1) {
      _multipleDetected = true;
      return;
    }

    final codeValue = barcodes[0].rawValue;

    if (codeValue == null) return;

    setState(() => _isScanned = true);

    final bloc = context.read<InspectionBloc>();


    bloc.add(SearchByCodeRequested(codeValue));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InspectionBloc, InspectionState>(
      listener: (context, state) {
        if (state is InspectionVendorSelected) {
          Navigator.pop(context, state.vendor);
        }

        if (state is InspectionSearchError) {
          setState(() => _isScanned = false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.primaryLight,
            ),
          ),
          title: const Text(
            'Scan QR Code',
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              color: AppColors.primaryLight
            ),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryLight,
          actions: [
            ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, state, child) {
                return IconButton(
                  icon: Icon(
                    state.torchState == TorchState.on
                        ? Icons.flash_on
                        : Icons.flash_off,
                    color: state.torchState == TorchState.on
                        ? Colors.yellow
                        : Colors.white,
                  ),
                  onPressed: () => _controller.toggleTorch(),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.cameraswitch, color: Colors.white),
              onPressed: () => _controller.switchCamera(),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
            final scanWindow = _calculateScanWindow(screenSize);
      
            return Container(
              decoration: BoxDecoration(
                color: AppColors.primaryBlack
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                  child: MobileScanner(
                    scanWindow: scanWindow,
                    controller: _controller,
                    onDetect: _onDetect,
                  ),
                ),
                  Center(
                    child: SizedBox(
                      height: _scanWindowSize,
                      width: _scanWindowSize,
                      child: CustomPaint(
                        painter: ScannerCornersPainter(
                          color: _multipleDetected ? AppColors.primaryRed : AppColors.primaryLight,
                        strokeWidth: 5,
                        ),
                      ),
                    ),
                  ),
            
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: BlocBuilder<InspectionBloc, InspectionState>(
                        builder:(context, state) {
                          if (state is InspectionSearchError) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryRed.withValues(alpha: .85),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                state.error,
                                style: TextStyle(
                                  color: AppColors.primaryRed,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }

                          if (state is InspectionSearchLoading) {
                            return CircularProgressIndicator(
                              color: AppColors.primaryLight,
                            );
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: _multipleDetected
                                  ? Colors.red.withValues(alpha: .85)
                                  : AppColors.primaryBlack.withValues(alpha: .30),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _multipleDetected
                                ? 'Multiple codes detected — move closer to isolate one'
                                : 'Align QR code within the frame',
                              style: TextStyle(
                                color: _multipleDetected ? AppColors.primaryRed : AppColors.primaryLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      )
                    ),
                  ),
                ],
              ),
            );
          }
        )
      ),
    );
  }
}