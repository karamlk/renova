import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FormPdfViewerScreen extends StatefulWidget {
  const FormPdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.token,
  });

  final String pdfUrl;
  final String token;

  @override
  State<FormPdfViewerScreen> createState() => _FormPdfViewerScreenState();
}

class _FormPdfViewerScreenState extends State<FormPdfViewerScreen> {
  Uint8List? _pdfBytes;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final response = await http.get(
        Uri.parse(widget.pdfUrl),
        headers: {
          'Accept': 'application/pdf',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(_serverMessage(response));
      }

      final bytes = Uint8List.fromList(response.bodyBytes);
      if (bytes.isEmpty) throw Exception('الملف فارغ');

      _pdfBytes = bytes;
    } catch (error) {
      _error =
          'تعذر تحميل ملف PDF: ${error.toString().replaceFirst('Exception: ', '')}';
    }

    if (mounted) setState(() {});
  }

  String _serverMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['message'] != null) {
        return 'رمز الاستجابة ${response.statusCode}: ${body['message']}';
      }
      if (body is Map && body['error'] != null) {
        return 'رمز الاستجابة ${response.statusCode}: ${body['error']}';
      }
    } catch (_) {}
    return 'رمز الاستجابة ${response.statusCode} من الخادم.';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الملف المرفق')),
      body: _pdfBytes != null
          ? SfPdfViewer.memory(_pdfBytes!)
          : Center(
              child: _error == null
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_error!, textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _pdfBytes = null;
                                _error = null;
                              });
                              _loadPdf();
                            },
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    ),
            ),
    );
  }
}
