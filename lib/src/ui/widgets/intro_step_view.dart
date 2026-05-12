import 'package:flutter/material.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/primary_button.dart';

class IntroStepView extends StatelessWidget {
  const IntroStepView({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 430;
        final minimumBottomHeight = (isNarrow ? 428 : 336) + bottomPadding;
        final targetTopHeight =
            constraints.maxHeight * (isNarrow ? 0.54 : 0.62);
        final topHeight = targetTopHeight.clamp(
          0.0,
          constraints.maxHeight - minimumBottomHeight,
        );
        final headlineStyle = isNarrow
            ? Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 28)
            : Theme.of(context).textTheme.headlineLarge;
        final bodyStyle = isNarrow
            ? Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16)
            : Theme.of(context).textTheme.bodyLarge;
        final title = isNarrow
            ? 'Create a prototype\nin just a few minutes'
            : 'Create a prototype in just\na few minutes';
        final subtitle = isNarrow
            ? 'Enjoy these pre-made components\nand worry only about creating the\nbest product ever.'
            : 'Enjoy these pre-made components and worry only\nabout creating the best product ever.';

        return Column(
          children: [
            SizedBox(
              height: topHeight,
              child: Container(
                width: double.infinity,
                color: const Color(0xFFEAF4FF),
                child: const Center(child: _ImagePlaceholder()),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(39, 31, 38, 20 + bottomPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _DotsIndicator(),
                    SizedBox(height: isNarrow ? 26 : 32),
                    Text(title, style: headlineStyle),
                    SizedBox(height: isNarrow ? 24 : 38),
                    Text(subtitle, style: bodyStyle),
                    const Spacer(),
                    PrimaryButton(label: 'Next', onPressed: onNext),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.image_outlined,
      color: const Color(0xFF9DCFFF).withValues(alpha: 0.82),
      size: 44,
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _Dot(color: Color(0xFF0A7CFF)),
        SizedBox(width: 10),
        _Dot(color: Color(0xFFE1E3E7)),
        SizedBox(width: 10),
        _Dot(color: Color(0xFFE1E3E7)),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: const SizedBox.square(dimension: 10),
    );
  }
}
