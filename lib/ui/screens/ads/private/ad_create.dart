import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItemDetails extends StatefulWidget {
  const AddItemDetails({super.key});

  @override
  _AddItemDetailsState createState() => _AddItemDetailsState();
}

class _AddItemDetailsState extends State<AddItemDetails> {
  final List<XFile?> selectedImages = [];
  final int maxPhotos = 6;
  String adtitle = '';
  String adslug = '';
  @override
  void initState() {
    super.initState();

  }

  void _showadtitleBottomSheet() {
    final TextEditingController controller =
    TextEditingController(text: adtitle);

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
                    child: const Text(
                      'Ad Title',
                      style: TextStyle(
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
                              setState(() {
                                adtitle = controller.text;
                              });
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Colors.cyan,
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
    ).then((_) {
      setState(() {});
    });
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
                    content: Text('Maximum number of photos selected')),
              );
            }
          },
        ),
      );
    }
  }

  Widget _buildSectionContainer(
      {required String title, required List<Widget> children}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String action, {bool isButton = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: ListTile(
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isButton)
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  action,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              )
            else if (title == 'Ad Title')
              Text(
                adtitle.isEmpty ? action : adtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      action,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
          ],
        ),
        onTap: title == 'Ad Title'
            ? _showadtitleBottomSheet
            : (title == 'Slug' ? _showadtitleBottomSheet : null),
      ),
    );
  }

  Widget _buildEditableSection(String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Edit',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Ad Details',
          style: Theme.of(context).textTheme.titleMedium,),
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
              _buildInfoItem('Ad Title', adtitle),
            ],
          ),
          _buildSectionContainer(
            title: 'Slug',
            children: [
              _buildInfoItem('Slug', adslug),
            ],
          ),
          _buildSectionContainer(
            title: 'Description',
            children: [
              _buildInfoItem('Description', adtitle),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
