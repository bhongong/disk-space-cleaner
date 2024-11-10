import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disk Space Cleaner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DiskCleanerPage(),
    );
  }
}

class DiskCleanerPage extends StatefulWidget {
  const DiskCleanerPage({super.key});

  @override
  State<DiskCleanerPage> createState() => _DiskCleanerPageState();
}

class _DiskCleanerPageState extends State<DiskCleanerPage> {
  String? selectedPath;
  String searchPattern = '';
  bool isSearchingFolder = true;
  List<String> searchResults = [];
  Set<String> selectedItems = {};
  bool isScanning = false;
  bool selectAll = false;
  bool isDeleting = false; // Added state for deleting

  Future<void> browsePath() async {
    String? path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      setState(() {
        selectedPath = path;
      });
    }
  }

  Future<void> scanDirectory() async {
    if (selectedPath == null || searchPattern.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a directory and enter a search pattern')),
      );
      return;
    }

    setState(() {
      isScanning = true;
      searchResults = [];
      selectedItems.clear();
      selectAll = false;
    });

    try {
      await _scanRecursively(Directory(selectedPath!));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scanning directory: $e')),
      );
    }

    setState(() {
      isScanning = false;
    });
  }

  // Future<void> _scanRecursively(Directory directory) async {
  //   try {
  //     await for (final entity in directory.list(recursive: true, followLinks: false)) {
  //       if (!isScanning) return; // Stop if scanning is cancelled

  //       final basename = path.basename(entity.path);
  //       if (basename.contains(searchPattern)) {
  //         if ((isSearchingFolder && entity is Directory) ||
  //             (!isSearchingFolder && entity is File)) {
  //           setState(() {
  //             searchResults.add(entity.path);
  //           });
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     // Skip directories we can't access
  //     print('Error accessing ${directory.path}: $e');
  //   }
  // }

// [Previous imports and MyApp class remain the same...]

  Future<void> _scanRecursively(Directory directory) async {
    try {
      await for (final entity in directory.list(followLinks: false)) {
        if (!isScanning) return; // Stop if scanning is cancelled

        final basename = path.basename(entity.path);
        
        // If we're searching for folders and this is a matching folder
        if (isSearchingFolder && entity is Directory && basename.contains(searchPattern)) {
          setState(() {
            searchResults.add(entity.path);
          });
          continue; // Skip recursing into this directory
        }
        
        // If we're searching for files and this is a matching file
        if (!isSearchingFolder && entity is File && basename.contains(searchPattern)) {
          setState(() {
            searchResults.add(entity.path);
          });
        }
        
        // Only recurse into the directory if:
        // 1. It's not a matching directory when we're searching for folders
        // 2. We're searching for files
        if (entity is Directory && 
            (!isSearchingFolder || !basename.contains(searchPattern))) {
          await _scanRecursively(entity);
        }
      }
    } catch (e) {
      // Skip directories we can't access
      print('Error accessing ${directory.path}: $e');
    }
  }

// [Rest of the code remains the same...]

  Future<void> deleteSelected() async {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select items to delete')),
      );
      return;
    }

    // Show confirmation dialog
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete ${selectedItems.length} items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      isDeleting = true; // Set deleting state to true
    });

    int successCount = 0;
    int failCount = 0;

    for (final itemPath in selectedItems) {
      try {
        final item = FileSystemEntity.typeSync(itemPath) == FileSystemEntityType.directory
            ? Directory(itemPath)
            : File(itemPath);
            
        await item.delete(recursive: true);
        successCount++;
      } catch (e) {
        failCount++;
        print('Error deleting $itemPath: $e');
      }
    }

    setState(() {
      searchResults.removeWhere((path) => selectedItems.contains(path));
      selectedItems.clear();
      selectAll = false;
      isDeleting = false; // Set deleting state to false
    });

    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted $successCount items. Failed: $failCount')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disk Space Cleaner'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Directory Selection
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(text: selectedPath ?? ''),
                            decoration: const InputDecoration(
                              labelText: 'Selected Directory',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: browsePath,
                          icon: const Icon(Icons.folder_open),
                          label: const Text('Browse'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search Pattern Input
                    TextField(
                      onChanged: (value) => searchPattern = value,
                      decoration: const InputDecoration(
                        labelText: 'Search Pattern',
                        border: OutlineInputBorder(),
                        hintText: 'e.g., node_modules, .venv',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search Type Selection
                    Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: isSearchingFolder,
                          onChanged: (value) => setState(() => isSearchingFolder = value!),
                        ),
                        const Text('Folder'),
                        const SizedBox(width: 16),
                        Radio<bool>(
                          value: false,
                          groupValue: isSearchingFolder,
                          onChanged: (value) => setState(() => isSearchingFolder = value!),
                        ),
                        const Text('File'),
                      ],
                    ),
                    
                    // Scan Button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: isScanning ? null : scanDirectory,
                        icon: isScanning 
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.search),
                        label: Text(isScanning ? 'Scanning...' : 'Scan'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Results Section
            if (searchResults.isNotEmpty) ...[
              Row(
                children: [
                  Checkbox(
                    value: selectAll,
                    onChanged: (bool? value) {
                      setState(() {
                        selectAll = value!;
                        if (selectAll) {
                          selectedItems = Set.from(searchResults);
                        } else {
                          selectedItems.clear();
                        }
                      });
                    },
                  ),
                  const Text('Select All'),
                  const Spacer(),
                  Text('${searchResults.length} results'),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Results List
            Expanded(
              child: Card(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final path = searchResults[index];
                    return ListTile(
                      leading: Checkbox(
                        value: selectedItems.contains(path),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value!) {
                              selectedItems.add(path);
                            } else {
                              selectedItems.remove(path);
                            }
                          });
                        },
                      ),
                      title: Text(
                        path,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        FileSystemEntity.typeSync(path) == FileSystemEntityType.directory
                            ? 'Folder'
                            : 'File',
                      ),
                    );
                  },
                ),
              ),
            ),

            // Delete Button
            if (searchResults.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton.icon(
                  onPressed: isDeleting ? null : (selectedItems.isEmpty ? null : deleteSelected), // Disable button when deleting
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: Text(
                    'Delete Selected (${selectedItems.length})',
                    style: const TextStyle(color: Colors.red),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                  ),
                ),
              ),
              // Progress Indicator
              if (isDeleting)
                const Center(
                  child: CircularProgressIndicator(),
                ),
          ],
        ),
      ),
    );
  }
}
