import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme_extension.dart';
import '../models/glossary_term.dart';
import '../providers/glossary_provider.dart';

class InteractiveGlossaryText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const InteractiveGlossaryText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  State<InteractiveGlossaryText> createState() => _InteractiveGlossaryTextState();
}

class _InteractiveGlossaryTextState extends State<InteractiveGlossaryText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    _clearRecognizers();
    super.dispose();
  }

  void _clearRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  void _showTermDialog(BuildContext context, GlossaryTerm term) {
    final theme = context.themeColors;
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    final description = isEnglish ? term.descripcionEn : term.descripcionEs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            term.termino,
            style: TextStyle(
              color: theme.text,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            description,
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.isEmpty) {
      return Text('', style: widget.style);
    }

    final glossaryProvider = Provider.of<GlossaryProvider>(context);
    final terms = glossaryProvider.terms;

    if (terms.isEmpty) {
      return Text(widget.text, style: widget.style);
    }

    // Sort terms by length in descending order to avoid matching nested/shorter terms first.
    final sortedTerms = List<GlossaryTerm>.from(terms);
    sortedTerms.sort((a, b) => b.termino.length.compareTo(a.termino.length));

    // Create a regex pattern with all terms escaped and joined by '|'
    final escapedTerms = sortedTerms.map((t) => RegExp.escape(t.termino)).toList();
    final pattern = escapedTerms.join('|');

    final regex = RegExp('\\b($pattern)\\b', caseSensitive: false);
    final matches = regex.allMatches(widget.text).toList();

    if (matches.isEmpty) {
      return Text(widget.text, style: widget.style);
    }

    _clearRecognizers();
    final List<InlineSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      // Add non-matched text before this match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: widget.text.substring(lastMatchEnd, match.start),
          style: widget.style,
        ));
      }

      final matchedText = match.group(0)!;

      // Find the corresponding GlossaryTerm
      final matchedTerm = sortedTerms.firstWhere(
        (t) => t.termino.toLowerCase() == matchedText.toLowerCase(),
        orElse: () => sortedTerms.firstWhere(
          (t) => matchedText.toLowerCase().contains(t.termino.toLowerCase()),
        ),
      );

      final recognizer = TapGestureRecognizer()
        ..onTap = () => _showTermDialog(context, matchedTerm);
      _recognizers.add(recognizer);

      final theme = context.themeColors;

      spans.add(TextSpan(
        text: matchedText,
        style: (widget.style ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.bold,
          backgroundColor: const Color(0x4DFFEB3B),
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.dashed,
          decorationColor: theme.primary,
        ),
        recognizer: recognizer,
      ));

      lastMatchEnd = match.end;
    }

    // Add remaining text after last match
    if (lastMatchEnd < widget.text.length) {
      spans.add(TextSpan(
        text: widget.text.substring(lastMatchEnd),
        style: widget.style,
      ));
    }

    return RichText(
      text: TextSpan(
        style: widget.style,
        children: spans,
      ),
    );
  }
}
