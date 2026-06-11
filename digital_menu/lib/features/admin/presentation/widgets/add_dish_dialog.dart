import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../menu/domain/entities/menu_category.dart';
import '../../../menu/domain/entities/dish.dart';
import '../controllers/admin_dish_cubit.dart';
import '../controllers/admin_dish_state.dart';

class AddDishDialog extends StatefulWidget {
  final List<MenuCategory> categories;
  final Dish? dish;

  const AddDishDialog({
    super.key,
    required this.categories,
    this.dish,
  });

  @override
  State<AddDishDialog> createState() => _AddDishDialogState();
}

class _AddDishDialogState extends State<AddDishDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedCategoryId;
  Uint8List? _selectedBytes;
  String? _selectedFileName;
  String? _imageError;

  @override
  void initState() {
    super.initState();
    if (widget.dish != null) {
      _nameController.text = widget.dish!.name;
      _priceController.text = widget.dish!.price.toStringAsFixed(0);
      _selectedCategoryId = widget.dish!.categoryId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        final extension = file.extension?.toLowerCase() ?? '';

        if (extension != 'jpg' &&
            extension != 'jpeg' &&
            extension != 'png' &&
            extension != 'webp') {
          setState(() {
            _imageError = 'Only JPG, PNG, and WebP formats are accepted.';
            _selectedBytes = null;
            _selectedFileName = null;
          });
        } else if (file.size > 600000) {
          setState(() {
            _imageError = 'Image must be smaller than 600 KB.';
            _selectedBytes = null;
            _selectedFileName = null;
          });
        } else if (file.bytes == null) {
          setState(() {
            _imageError = 'Could not read file data.';
            _selectedBytes = null;
            _selectedFileName = null;
          });
        } else {
          setState(() {
            _imageError = null;
            _selectedBytes = file.bytes;
            _selectedFileName = file.name;
          });
        }
      }
    } catch (e) {
      setState(() {
        _imageError = 'Error picking file: $e';
      });
    }
  }

  void _submit() {
    setState(() {
      _imageError = null;
    });

    // Run form validations
    final isFormValid = _formKey.currentState?.validate() ?? false;

    // Run manual image validation only in Add mode (KPI-14: missing photo is rejected)
    if (widget.dish == null && (_selectedBytes == null || _selectedFileName == null)) {
      setState(() {
        _imageError = 'Please upload a dish photo';
      });
      return;
    }

    if (isFormValid) {
      final price = double.tryParse(_priceController.text) ?? 0.0;
      
      if (widget.dish != null) {
        // Edit Mode
        context.read<AdminDishCubit>().editDish(
              id: widget.dish!.id,
              name: _nameController.text.trim(),
              price: price,
              categoryId: _selectedCategoryId!,
              fileName: _selectedFileName,
              fileBytes: _selectedBytes,
              existingPhotoUrl: widget.dish!.photoUrl,
              existingCreatedAt: widget.dish!.createdAt,
            );
      } else {
        // Add Mode
        context.read<AdminDishCubit>().createDish(
              name: _nameController.text.trim(),
              price: price,
              categoryId: _selectedCategoryId!,
              fileName: _selectedFileName!,
              fileBytes: _selectedBytes!,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditMode = widget.dish != null;

    return BlocListener<AdminDishCubit, AdminDishState>(
      listener: (context, state) {
        state.maybeWhen(
          success: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isEditMode ? 'Dish updated successfully!' : 'Dish added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
              ),
            );
          },
          orElse: () {},
        );
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 16,
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEditMode ? 'Edit Dish' : 'Add New Dish',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Dish Name',
                      prefixIcon: const Icon(Icons.restaurant_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the dish name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      prefixIcon: const Icon(Icons.attach_money_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the price';
                      }
                      final price = double.tryParse(value);
                      if (price == null) {
                        return 'Please enter a valid number';
                      }
                      if (price <= 0) {
                        return 'Price must be greater than zero';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategoryId,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      prefixIcon: const Icon(Icons.category_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    items: widget.categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    color: Colors.grey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: _imageError != null ? Colors.red[300]! : Colors.grey[300]!,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          if (_selectedBytes != null) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                _selectedBytes!,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _selectedFileName!,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _selectedBytes = null;
                                      _selectedFileName = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ] else if (isEditMode && widget.dish!.photoUrl.isNotEmpty) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: widget.dish!.photoUrl.startsWith('data:image')
                                  ? Image.memory(
                                      base64Decode(widget.dish!.photoUrl.split(',').last),
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: widget.dish!.photoUrl,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => const Icon(Icons.broken_image_outlined),
                                    ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.add_photo_alternate_outlined),
                              label: const Text('Change Photo'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.secondary.withAlpha(51),
                                foregroundColor: theme.colorScheme.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ] else ...[
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 48,
                              color: _imageError != null ? Colors.red[300] : Colors.grey[400],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No photo selected',
                              style: TextStyle(
                                color: _imageError != null ? Colors.red[700] : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.add_photo_alternate_outlined),
                              label: const Text('Choose Image'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.secondary.withAlpha(51),
                                foregroundColor: theme.colorScheme.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                          if (_imageError != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _imageError!,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<AdminDishCubit, AdminDishState>(
                    builder: (context, state) {
                      final isLoading = state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      );

                      return ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              isEditMode ? 'Update Dish' : 'Save Dish',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
