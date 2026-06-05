import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'pay_theme.dart';

/// Simple back-button app bar matching the mockups (3.1).
class PayAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  const PayAppBar({super.key, required this.title, this.subtitle, this.actions, this.onBack});

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? 64 : 84);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, PayTheme.hPad, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: PayTheme.primaryText),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(title, style: PayTheme.screenTitle),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(subtitle!, style: PayTheme.bodyMuted),
                    ),
                ],
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}

/// Rounded white card per the design system (3.1).
class PayCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  const PayCard({super.key, required this.child, this.padding, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(PayTheme.itemGap),
      decoration: BoxDecoration(
        color: color ?? PayTheme.cardSurface,
        borderRadius: BorderRadius.circular(PayTheme.cardRadius),
        border: Border.all(color: PayTheme.divider),
      ),
      child: child,
    );
  }
}

/// Primary CTA (3.1 — height 52, radius from card system).
class PayButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool loading;
  final Color? color;
  const PayButton({super.key, required this.text, this.onTap, this.loading = false, this.color});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !loading;
    return SizedBox(
      width: double.infinity,
      height: PayTheme.buttonHeight,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? PayTheme.accent,
          disabledBackgroundColor: (color ?? PayTheme.accent).withOpacity(0.4),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
              )
            : Text(text,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }
}

/// Avatar that falls back to initials when no image is available.
class PayAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  const PayAvatar({super.key, this.imageUrl, required this.name, this.size = 64});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '?'
        : name.trim().split(RegExp(r'\s+')).take(2).map((w) => w[0]).join().toUpperCase();
    return ClipOval(
      child: SizedBox(
        height: size,
        width: size,
        child: (imageUrl != null && imageUrl!.isNotEmpty)
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _initials(initials),
                placeholder: (_, __) => _initials(initials),
              )
            : _initials(initials),
      ),
    );
  }

  Widget _initials(String initials) => Container(
        color: PayTheme.accent.withOpacity(0.12),
        alignment: Alignment.center,
        child: Text(initials,
            style: TextStyle(
                color: PayTheme.accent, fontSize: size * 0.34, fontWeight: FontWeight.w600)),
      );
}

/// A label/value row used in summaries and receipts.
class PayRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;
  final Color? valueColor;
  const PayRow(this.label, this.value, {super.key, this.emphasize = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: emphasize ? PayTheme.body : PayTheme.bodyMuted),
          Text(
            value,
            style: TextStyle(
              fontSize: emphasize ? 18 : 16,
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
              color: valueColor ?? PayTheme.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-screen error / empty state with an optional retry.
class PayMessageView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final Color? iconColor;
  const PayMessageView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PayTheme.sectionGap),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: iconColor ?? PayTheme.secondaryText),
            const SizedBox(height: 16),
            Text(title, style: PayTheme.cardTitle, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message, style: PayTheme.bodyMuted, textAlign: TextAlign.center),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              PayButton(text: actionText!, onTap: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
