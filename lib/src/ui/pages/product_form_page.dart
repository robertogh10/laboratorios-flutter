import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/auth_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/store_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/routing/app_router.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/primary_button.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  const ProductFormPage({this.productId, super.key});

  final String? productId;

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _variantController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sizesController = TextEditingController();
  final _colorsController = TextEditingController();

  String _category = 'perfect';
  bool _seeded = false;
  bool _saving = false;

  bool get _isEditing {
    return widget.productId != null && widget.productId!.isNotEmpty;
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _variantController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _sizesController.dispose();
    _colorsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authSession = ref.watch(authSessionProvider);
    final isAdmin = authSession.maybeWhen(
      data: (session) => session?.isAdmin ?? false,
      orElse: () => false,
    );

    if (authSession.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!isAdmin) {
      return _AdminOnlyView(onBack: () => context.go(AppRoutes.storeHome));
    }

    final storeState = ref.watch(storeControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: storeState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _FormErrorView(
            message: error.toString(),
            onBack: () => context.go(AppRoutes.storeHome),
          ),
          data: (state) {
            final product = _isEditing
                ? state.products.cast<Product?>().firstWhere(
                    (item) => item?.id == widget.productId,
                    orElse: () => null,
                  )
                : null;

            if (_isEditing && product == null) {
              return _FormErrorView(
                message: 'No se encontro el producto.',
                onBack: () => context.go(AppRoutes.storeHome),
              );
            }

            _seedProduct(product);

            return _ProductFormContent(
              formKey: _formKey,
              isEditing: _isEditing,
              saving: _saving,
              idController: _idController,
              nameController: _nameController,
              variantController: _variantController,
              priceController: _priceController,
              descriptionController: _descriptionController,
              sizesController: _sizesController,
              colorsController: _colorsController,
              category: _category,
              onCategoryChanged: (value) {
                setState(() {
                  _category = value;
                });
              },
              onCancel: () => context.go(AppRoutes.storeHome),
              onSave: _save,
            );
          },
        ),
      ),
    );
  }

  void _seedProduct(Product? product) {
    if (_seeded) {
      return;
    }

    _seeded = true;

    if (product == null) {
      _sizesController.text = 'S, M, L';
      _colorsController.text = '0xFF202129, 0xFFE4E6EF';
      return;
    }

    _idController.text = product.id;
    _nameController.text = product.name;
    _variantController.text = product.variant;
    _category = product.category;
    _priceController.text = product.price.toStringAsFixed(2);
    _descriptionController.text = product.description;
    _sizesController.text = product.sizes.join(', ');
    _colorsController.text = product.colors.map(_formatColor).join(', ');
  }

  Future<void> _save() async {
    final valid = _formKey.currentState?.validate() ?? false;

    if (!valid) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _saving = true;
    });

    try {
      final sizes = _splitList(_sizesController.text);
      final colors = _parseColors(_colorsController.text);
      final product = Product(
        id: _slug(_idController.text),
        name: _nameController.text.trim(),
        variant: _variantController.text.trim(),
        category: _category,
        price: double.parse(_priceController.text.trim()),
        description: _descriptionController.text.trim(),
        sizes: sizes,
        selectedSize: sizes.first,
        colors: colors,
        selectedColor: colors.first,
      );

      await ref.read(storeControllerProvider.notifier).saveProduct(product);

      if (!mounted) {
        return;
      }

      context.go(AppRoutes.storeProduct(product.id));
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar el producto: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  List<String> _splitList(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  List<int> _parseColors(String value) {
    return _splitList(value).map(_parseColor).toList();
  }

  int _parseColor(String value) {
    final trimmed = value.trim();
    final hex = trimmed.startsWith('#')
        ? 'FF${trimmed.substring(1)}'
        : trimmed.startsWith('0x')
        ? trimmed.substring(2)
        : trimmed;

    if (RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(hex)) {
      return int.parse('FF$hex', radix: 16);
    }

    if (RegExp(r'^[0-9a-fA-F]{8}$').hasMatch(hex)) {
      return int.parse(hex, radix: 16);
    }

    return int.parse(trimmed);
  }

  String _formatColor(int color) {
    return '0x${color.toUnsigned(32).toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  String _slug(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}

class _ProductFormContent extends StatelessWidget {
  const _ProductFormContent({
    required this.formKey,
    required this.isEditing,
    required this.saving,
    required this.idController,
    required this.nameController,
    required this.variantController,
    required this.priceController,
    required this.descriptionController,
    required this.sizesController,
    required this.colorsController,
    required this.category,
    required this.onCategoryChanged,
    required this.onCancel,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final bool isEditing;
  final bool saving;
  final TextEditingController idController;
  final TextEditingController nameController;
  final TextEditingController variantController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final TextEditingController sizesController;
  final TextEditingController colorsController;
  final String category;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: onCancel,
                icon: const Icon(Icons.close, size: 28),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isEditing ? 'Edit product' : 'New product',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(30, 8, 30, 24 + bottomPadding),
              children: [
                _FormTextField(
                  controller: idController,
                  label: 'Product ID',
                  enabled: !isEditing,
                  validator: _validateId,
                ),
                const SizedBox(height: 14),
                _FormTextField(
                  controller: nameController,
                  label: 'Name',
                  validator: _validateRequired,
                ),
                const SizedBox(height: 14),
                _CategoryField(value: category, onChanged: onCategoryChanged),
                const SizedBox(height: 14),
                _FormTextField(
                  controller: priceController,
                  label: 'Price',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: _validatePrice,
                ),
                const SizedBox(height: 14),
                _FormTextField(
                  controller: variantController,
                  label: 'Variant',
                  validator: _validateRequired,
                ),
                const SizedBox(height: 14),
                _FormTextField(
                  controller: descriptionController,
                  label: 'Description',
                  minLines: 3,
                  maxLines: 5,
                  validator: _validateRequired,
                ),
                const SizedBox(height: 14),
                _FormTextField(
                  controller: sizesController,
                  label: 'Sizes',
                  validator: _validateList,
                ),
                const SizedBox(height: 14),
                _FormTextField(
                  controller: colorsController,
                  label: 'Colors',
                  validator: _validateColors,
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: saving ? 'Saving...' : 'Save product',
                  onPressed: saving ? () {} : onSave,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String? _validateId(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Enter a product ID.';
    }

    if (RegExp(r'[^a-zA-Z0-9 -]').hasMatch(text)) {
      return 'Use letters, numbers, spaces or hyphens.';
    }

    return null;
  }

  static String? _validateRequired(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'This field is required.';
    }

    return null;
  }

  static String? _validatePrice(String? value) {
    final price = double.tryParse((value ?? '').trim());

    if (price == null || price <= 0) {
      return 'Enter a valid price.';
    }

    return null;
  }

  static String? _validateList(String? value) {
    final items = (value ?? '')
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty);

    if (items.isEmpty) {
      return 'Enter at least one value.';
    }

    return null;
  }

  static String? _validateColors(String? value) {
    final listError = _validateList(value);

    if (listError != null) {
      return listError;
    }

    final items = (value ?? '')
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty);

    for (final item in items) {
      final normalized = item.startsWith('#')
          ? item.substring(1)
          : item.startsWith('0x')
          ? item.substring(2)
          : item;

      final isHexColor =
          RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(normalized) ||
          RegExp(r'^[0-9a-fA-F]{8}$').hasMatch(normalized);
      final isDecimal = int.tryParse(item) != null;

      if (!isHexColor && !isDecimal) {
        return 'Use colors like 0xFF202129, #202129 or 4280295721.';
      }
    }

    return null;
  }
}

class _CategoryField extends StatelessWidget {
  const _CategoryField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: _inputDecoration(context, 'Category'),
      items: const [
        DropdownMenuItem(value: 'perfect', child: Text('Perfect for you')),
        DropdownMenuItem(value: 'summer', child: Text('For this summer')),
      ],
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}

class _FormTextField extends StatelessWidget {
  const _FormTextField({
    required this.controller,
    required this.label,
    this.enabled = true,
    this.keyboardType,
    this.minLines = 1,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final TextInputType? keyboardType;
  final int minLines;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      decoration: _inputDecoration(context, label),
    );
  }
}

class _AdminOnlyView extends StatelessWidget {
  const _AdminOnlyView({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _FormMessageView(
        title: 'Admin only',
        message: 'Necesitas permisos de administrador para editar productos.',
        onBack: onBack,
      ),
    );
  }
}

class _FormErrorView extends StatelessWidget {
  const _FormErrorView({required this.message, required this.onBack});

  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return _FormMessageView(
      title: 'No se pudo abrir el formulario',
      message: message,
      onBack: onBack,
    );
  }
}

class _FormMessageView extends StatelessWidget {
  const _FormMessageView({
    required this.title,
    required this.message,
    required this.onBack,
  });

  final String title;
  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: onBack, child: const Text('Back')),
          ],
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(BuildContext context, String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    border: _border(const Color(0xFFD5D7DB)),
    enabledBorder: _border(const Color(0xFFD5D7DB)),
    disabledBorder: _border(const Color(0xFFE1E4EA)),
    focusedBorder: _border(const Color(0xFF0A7CFF), width: 2),
    errorBorder: _border(Theme.of(context).colorScheme.error),
    focusedErrorBorder: _border(Theme.of(context).colorScheme.error, width: 2),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
  );
}

OutlineInputBorder _border(Color color, {double width = 1}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(13),
    borderSide: BorderSide(color: color, width: width),
  );
}
