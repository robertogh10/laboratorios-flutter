import 'package:flutter/material.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/primary_button.dart';

class AddCardDetails {
  const AddCardDetails({
    required this.cardholderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });

  final String cardholderName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
}

class AddCardView extends StatefulWidget {
  const AddCardView({required this.onCancel, required this.onSave, super.key});

  final VoidCallback onCancel;
  final ValueChanged<AddCardDetails> onSave;

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  final _formKey = GlobalKey<FormState>();
  final _cardholderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardholderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(29, 28, 29, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: widget.onCancel,
                    behavior: HitTestBehavior.opaque,
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF0A7CFF),
                      size: 24,
                    ),
                  ),
                ),
                const Text(
                  'Add card',
                  style: TextStyle(
                    color: Color(0xFF202129),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const _CheckoutSteps(),
            const SizedBox(height: 36),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New payment card',
                        style: TextStyle(
                          color: Color(0xFF202129),
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 23),
                      _CardPreview(
                        cardNumberController: _cardNumberController,
                        cardholderController: _cardholderController,
                        expiryController: _expiryController,
                      ),
                      const SizedBox(height: 29),
                      _CardField(
                        fieldKey: const ValueKey('cardholder-name-field'),
                        controller: _cardholderController,
                        label: 'Cardholder name',
                        textInputAction: TextInputAction.next,
                        validator: _requiredValidator,
                      ),
                      const SizedBox(height: 15),
                      _CardField(
                        fieldKey: const ValueKey('card-number-field'),
                        controller: _cardNumberController,
                        label: 'Card number',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: _cardNumberValidator,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _CardField(
                              fieldKey: const ValueKey('expiry-date-field'),
                              controller: _expiryController,
                              label: 'MM/YY',
                              keyboardType: TextInputType.datetime,
                              textInputAction: TextInputAction.next,
                              validator: _expiryValidator,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _CardField(
                              fieldKey: const ValueKey('cvv-field'),
                              controller: _cvvController,
                              label: 'CVV',
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              validator: _cvvValidator,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            PrimaryButton(label: 'Save card', onPressed: _saveCard),
          ],
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }

    return null;
  }

  String? _cardNumberValidator(String? value) {
    final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digits.length < 12) {
      return 'Invalid number';
    }

    return null;
  }

  String? _expiryValidator(String? value) {
    final trimmed = value?.trim() ?? '';
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(trimmed)) {
      return 'MM/YY';
    }

    return null;
  }

  String? _cvvValidator(String? value) {
    final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digits.length < 3) {
      return 'Invalid';
    }

    return null;
  }

  void _saveCard() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    widget.onSave(
      AddCardDetails(
        cardholderName: _cardholderController.text.trim(),
        cardNumber: _cardNumberController.text.trim(),
        expiryDate: _expiryController.text.trim(),
        cvv: _cvvController.text.trim(),
      ),
    );
  }
}

class _CheckoutSteps extends StatelessWidget {
  const _CheckoutSteps();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StepItem(done: true, label: 'Your bag'),
        _StepItem(done: true, label: 'Shipping'),
        _StepItem(number: '3', label: 'Payment', active: true),
        _StepItem(number: '4', label: 'Review'),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.label,
    this.number,
    this.done = false,
    this.active = false,
  });

  final String label;
  final String? number;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final circleColor = active
        ? const Color(0xFF0A7CFF)
        : done
        ? const Color(0xFFD8EAFF)
        : const Color(0xFFF4F6FB);
    final contentColor = active
        ? Colors.white
        : done
        ? const Color(0xFF0A7CFF)
        : const Color(0xFFC6CBD5);

    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Container(
            width: 29,
            height: 29,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: done
                  ? Icon(Icons.check, color: contentColor, size: 19)
                  : Text(
                      number ?? '',
                      style: TextStyle(
                        color: contentColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 17),
          Text(
            label,
            style: TextStyle(
              color: active ? const Color(0xFF202129) : const Color(0xFF8D929C),
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardPreview extends StatelessWidget {
  const _CardPreview({
    required this.cardNumberController,
    required this.cardholderController,
    required this.expiryController,
  });

  final TextEditingController cardNumberController;
  final TextEditingController cardholderController;
  final TextEditingController expiryController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        cardNumberController,
        cardholderController,
        expiryController,
      ]),
      builder: (context, child) {
        final lastFour = _lastFour(cardNumberController.text);
        final holder = cardholderController.text.trim().isEmpty
            ? 'Cardholder'
            : cardholderController.text.trim();
        final expiry = expiryController.text.trim().isEmpty
            ? 'MM/YY'
            : expiryController.text.trim();

        return Container(
          height: 176,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
          decoration: BoxDecoration(
            color: const Color(0xFF202129),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.white, size: 29),
                  Spacer(),
                  Text(
                    'Credit Card',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'xxxx xxxx xxxx $lastFour',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      holder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFC8CDD6),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Text(
                    expiry,
                    style: const TextStyle(
                      color: Color(0xFFC8CDD6),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _lastFour(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 4) {
      return digits.substring(digits.length - 4);
    }

    return digits.padLeft(4, '0');
  }
}

class _CardField extends StatelessWidget {
  const _CardField({
    required this.fieldKey,
    required this.controller,
    required this.label,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      style: const TextStyle(
        color: Color(0xFF202129),
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF737780),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 19,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFF0A7CFF), width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFE15B64)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFE15B64), width: 1.4),
        ),
      ),
    );
  }
}
