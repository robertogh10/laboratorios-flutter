import 'package:flutter/material.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/payment_method.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/primary_button.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({
    required this.methods,
    required this.selectedMethodId,
    required this.billingSameAsShipping,
    required this.onCancel,
    required this.onMethodPressed,
    required this.onBillingPressed,
    required this.onContinue,
    super.key,
  });

  final List<PaymentMethod> methods;
  final String selectedMethodId;
  final bool billingSameAsShipping;
  final VoidCallback onCancel;
  final ValueChanged<String> onMethodPressed;
  final VoidCallback onBillingPressed;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final cards = methods.where((method) => method.id != 'apple-pay').toList();
    final applePay = methods.firstWhere((method) => method.id == 'apple-pay');

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
                    onTap: onCancel,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF0A7CFF),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Checkout',
                  style: TextStyle(
                    color: Color(0xFF202129),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _CheckoutSteps(),
                    const SizedBox(height: 45),
                    const Text(
                      'Choose a payment method',
                      style: TextStyle(
                        color: Color(0xFF202129),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "You won't be charged until you review the order on the\nnext page",
                      style: TextStyle(
                        color: Color(0xFF737780),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 36),
                    _PaymentCardGroup(
                      cards: cards,
                      selectedMethodId: selectedMethodId,
                      billingSameAsShipping: billingSameAsShipping,
                      onMethodPressed: onMethodPressed,
                      onBillingPressed: onBillingPressed,
                    ),
                    const SizedBox(height: 18),
                    _ApplePayTile(
                      method: applePay,
                      selected: selectedMethodId == applePay.id,
                      onPressed: () => onMethodPressed(applePay.id),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            PrimaryButton(label: 'Continue', onPressed: onContinue),
          ],
        ),
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

class _PaymentCardGroup extends StatelessWidget {
  const _PaymentCardGroup({
    required this.cards,
    required this.selectedMethodId,
    required this.billingSameAsShipping,
    required this.onMethodPressed,
    required this.onBillingPressed,
  });

  final List<PaymentMethod> cards;
  final String selectedMethodId;
  final bool billingSameAsShipping;
  final ValueChanged<String> onMethodPressed;
  final VoidCallback onBillingPressed;

  @override
  Widget build(BuildContext context) {
    final selected = cards.any((card) => card.id == selectedMethodId);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 19, 18, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE1E4EA)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _RadioCircle(selected: selected),
              const SizedBox(width: 10),
              const Text(
                'Credit Card',
                style: TextStyle(
                  color: Color(0xFF737780),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          ...cards.map(
            (method) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: _CardMethodTile(
                method: method,
                selected: selectedMethodId == method.id,
                onPressed: () => onMethodPressed(method.id),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Color(0xFF0A7CFF), size: 22),
              SizedBox(width: 9),
              Text(
                'Add new card',
                style: TextStyle(
                  color: Color(0xFF0A7CFF),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: onBillingPressed,
            child: Row(
              children: [
                _CheckboxSquare(selected: billingSameAsShipping),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'My billing address is the same as my shipping\naddress',
                    style: TextStyle(
                      color: Color(0xFF737780),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardMethodTile extends StatelessWidget {
  const _CardMethodTile({
    required this.method,
    required this.selected,
    required this.onPressed,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 106,
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF4FF) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFFEAF4FF) : const Color(0xFFE1E4EA),
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    method.title,
                    style: const TextStyle(
                      color: Color(0xFF202129),
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    method.subtitle,
                    style: const TextStyle(
                      color: Color(0xFF737780),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check, color: Color(0xFF0A7CFF), size: 24),
          ],
        ),
      ),
    );
  }
}

class _ApplePayTile extends StatelessWidget {
  const _ApplePayTile({
    required this.method,
    required this.selected,
    required this.onPressed,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE1E4EA)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _RadioCircle(selected: selected),
            const SizedBox(width: 13),
            Text(
              method.title,
              style: const TextStyle(
                color: Color(0xFF737780),
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  const _RadioCircle({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 21,
      height: 21,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF0A7CFF) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? const Color(0xFF0A7CFF) : const Color(0xFFC8CDD6),
          width: 2,
        ),
      ),
      child: selected
          ? const Center(
              child: SizedBox(
                width: 7,
                height: 7,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class _CheckboxSquare extends StatelessWidget {
  const _CheckboxSquare({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF0A7CFF) : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: selected ? const Color(0xFF0A7CFF) : const Color(0xFFC8CDD6),
        ),
      ),
      child: selected
          ? const Icon(Icons.check, color: Colors.white, size: 16)
          : null,
    );
  }
}
