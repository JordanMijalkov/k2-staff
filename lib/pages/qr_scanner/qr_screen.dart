import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:k2_staff/core/services/deep_link_service.dart';
import 'package:k2_staff/core/services/service_locator.dart';
import 'package:k2_staff/core/widgets/scaffold/kt_scaffold.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key, required this.fromWhere}) : super(key: key);
  final String fromWhere;
  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  Barcode? result;
  QRViewController? _controller;
  final DeepLinkService _deepLinkService = app<DeepLinkService>();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    }
    _controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return KTScaffold(
      showLeading: widget.fromWhere == 'menu' ? true : false,
      title: "QR Scanner",
     // bottomNavigationBar: null,
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await _controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: _controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                if (snapshot.data == true) {
                                  return Icon(Icons.flash_off);
                                } else
                                  return Icon(Icons.flash_on);
                              },
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await _controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: _controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  if (Platform.isIOS) {
                                    return Icon(Icons.flip_camera_ios);
                                  } else {
                                    return Icon(Icons.flip_camera_android);
                                  }
                                } else {
                                  return Text('Loading ...');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await _controller?.pauseCamera();
                            },
                            child: Icon(Icons.pause)),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await _controller?.resumeCamera();
                            },
                            child: Icon(Icons.play_arrow)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this._controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      this._controller!.pauseCamera();

      var deepLinkResult =
          await _deepLinkService.deepActionCheckInCheckOut(scanData.code);

      if (!deepLinkResult) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 10),
            content:
                Text("Invalid QR Code", style: TextStyle(color: Colors.white)),
            backgroundColor: Theme.of(context).errorColor));
      }

      setState(() {
        result = scanData;
      });
      this._controller!.resumeCamera();
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 20),
          content: Text("Camera Permission is required to scan QR codes.",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).errorColor));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
