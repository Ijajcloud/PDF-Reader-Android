import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdfrx/pdfrx.dart';

void main() {
  runApp(const PDFReaderApp());
}

class PDFReaderApp extends StatelessWidget {
  const PDFReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Reader Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? pdfPath;
  String? pdfName;
  bool darkMode = false;

  Future<void> openPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;

    if (file.path == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot access this PDF file.'),
        ),
      );
      return;
    }

    setState(() {
      pdfPath = file.path;
      pdfName = file.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.indigo,
              ),
              useMaterial3: true,
            ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PDF Reader Pro'),
          actions: [
            IconButton(
              tooltip: 'Toggle dark mode',
              icon: Icon(
                darkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                setState(() => darkMode = !darkMode);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.picture_as_pdf,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              const Text(
                'Your PDF Library',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Open and read PDF documents on your phone.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: openPDF,
                icon: const Icon(Icons.folder_open),
                label: const Text('Open PDF'),
              ),
              const SizedBox(height: 20),
              if (pdfName != null)
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                    ),
                    title: Text(pdfName!),
                    subtitle: const Text('Selected document'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PDFPage(
                            path: pdfPath!,
                            name: pdfName!,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const Spacer(),
              const Text(
                'PDF Reader Pro • Offline reading',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PDFPage extends StatelessWidget {
  final String path;
  final String name;

  const PDFPage({
    super.key,
    required this.path,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: PdfViewer.file(path),
    );
  }
}
