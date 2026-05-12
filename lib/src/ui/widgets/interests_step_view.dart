import 'package:flutter/material.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/interest.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/primary_button.dart';

class InterestsStepView extends StatelessWidget {
  const InterestsStepView({
    required this.interests,
    required this.onInterestPressed,
    required this.onNext,
    super.key,
  });

  final List<Interest> interests;
  final ValueChanged<String> onInterestPressed;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(38, 51, 38, 20 + bottomPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ProgressBar(),
            const SizedBox(height: 62),
            Text(
              'Personalise your\nexperience',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'Choose your interests.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 57),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final interest = interests[index];
                  return _InterestTile(
                    interest: interest,
                    onPressed: () => onInterestPressed(interest.id),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: interests.length,
              ),
            ),
            const SizedBox(height: 26),
            PrimaryButton(label: 'Next', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 11,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF8E36FF), width: 3),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: Container(
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF0A7CFF),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InterestTile extends StatelessWidget {
  const _InterestTile({required this.interest, required this.onPressed});

  final Interest interest;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: interest.selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(13),
          child: Ink(
            height: 66,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: interest.selected ? const Color(0xFFEAF4FF) : Colors.white,
              border: Border.all(
                color: interest.selected
                    ? const Color(0xFFEAF4FF)
                    : const Color(0xFFD5D7DB),
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    interest.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (interest.selected)
                  const Icon(Icons.check, color: Color(0xFF0A7CFF), size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
