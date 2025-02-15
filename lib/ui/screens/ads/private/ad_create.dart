import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:offertree/ui/screens/dashboard/home.dart';

class AddItemDetails extends StatefulWidget {
  const AddItemDetails({super.key});

  @override
  _AddItemDetailsState createState() => _AddItemDetailsState();
}

class _AddItemDetailsState extends State<AddItemDetails> {
  final List<XFile?> selectedImages = [];
  final int maxPhotos = 6;
  String adtitle = '';
  int adprice = 0;
  String addescription = '';
  bool isLoading = false;

  String selectedCategory = 'Select Category';
  int selectedCategoryValue = 0;
  String selectedCondition = 'Select Condition';
  int selectedConditionValue = 0;
  String selectedSubcategory = 'Select Subcategory';
  int selectedSubcategoryValue = 0;

  void _showDropdownBottomSheet(
      String title, List<String> options, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Column(
                children: options.map((option) {
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      onSelect(option);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDropdownBottomSheetWithInt(
      String title, Map<String, int> options, Function(String, int) onSelect) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Column(
                children: options.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key),
                    onTap: () {
                      onSelect(entry.key, entry.value);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditableBottomSheet(
      String title, String initialValue, Function(String) onConfirm) {
    final TextEditingController controller =
        TextEditingController(text: initialValue);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              onConfirm(controller.text);
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Color(0xFF576bd6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Confirm',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPhotoGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: maxPhotos,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return _buildPhotoPlaceholder(index);
        },
      ),
    );
  }

  Widget _buildPhotoPlaceholder(int index) {
    if (index < selectedImages.length && selectedImages[index] != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(selectedImages[index]!.path),
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFF4F4F4),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.add,
            color: Color(0xFF000000),
            size: 30,
          ),
          onPressed: () async {
            if (selectedImages.length < maxPhotos) {
              final ImagePicker picker = ImagePicker();
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);

              if (image != null) {
                setState(() {
                  selectedImages.add(image);
                });
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Maximum number of photos selected'),
                ),
              );
            }
          },
        ),
      );
    }
  }

  Widget _buildSectionContainer({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, VoidCallback? onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value.isEmpty || value.startsWith('Select')
                  ? 'Add $title'
                  : value,
              style: TextStyle(
                color: value.isEmpty || value.startsWith('Select')
                    ? Colors.grey[600]
                    : Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Future<void> _postAd() async {
    setState(() {
      isLoading = true; // Start loading
    });
    const String apiUrl = 'https://offertree-backend.vercel.app/api/ads';

    final Map<String, dynamic> requestBody = {
      "title": adtitle,
      "description": addescription,
      "price": adprice,
      "categoryId": selectedCategoryValue,
      "subcategoryId": selectedSubcategoryValue,
      "userId": 3,
      "condition": selectedCondition,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ad posted successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post ad: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          'Ad Details',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildPhotoGrid(),
          _buildSectionContainer(
            title: 'Ad Title',
            children: [
              _buildInfoItem('Ad Title', adtitle, () {
                _showEditableBottomSheet('Edit Ad Title', adtitle, (newValue) {
                  setState(() {
                    adtitle = newValue;
                  });
                });
              }),
            ],
          ),
          _buildSectionContainer(
            title: 'Description',
            children: [
              _buildInfoItem('Description', addescription, () {
                _showEditableBottomSheet('Description', addescription,
                    (newValue) {
                  setState(() {
                    addescription = newValue;
                  });
                });
              }),
            ],
          ),
          _buildSectionContainer(
            title: 'Price',
            children: [
              _buildInfoItem('Price', adprice.toString(), () {
                _showEditableBottomSheet('Price', adprice.toString(),
                    (newValue) {
                  setState(() {
                    adprice = int.tryParse(newValue) ?? adprice;
                  });
                });
              }),
            ],
          ),
          _buildInfoItem('Condition', selectedCondition, () {
            _showDropdownBottomSheetWithInt(
              'Select Condition',
              {
                'New': 1,
                'Refurbished': 2,
              },
              (text, value) {
                setState(() {
                  selectedCondition = text;
                  selectedConditionValue = value;
                });
              },
            );
          }),
          _buildInfoItem('Category', selectedCategory, () {
            _showDropdownBottomSheetWithInt(
              'Select Category',
              {
                'Mobiles': 1,
                'Laptop': 2,
              },
              (text, value) {
                setState(() {
                  selectedCategory = text;
                  selectedCategoryValue = value;
                });
              },
            );
          }),
          _buildInfoItem('Subcategory', selectedSubcategory, () {
            _showDropdownBottomSheetWithInt(
              'Select Subcategory',
              {
                'Iphone': 1,
                'Windows Laptop': 2,
              },
              (text, value) {
                setState(() {
                  selectedSubcategory = text;
                  selectedSubcategoryValue = value;
                });
              },
            );
          }),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: isLoading ? null : _postAd,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF576bd6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Text(
                      'Post Ad',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
