import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final double width;
  final double height;

  // Fields for additional data display (COGS and Laba Kotor)
  final String? cogsLabel;
  final String? cogsValue;
  final String? profitLabel;
  final String? profitValue;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.width = 270,
    this.height = 175,
    this.cogsLabel,
    this.cogsValue,
    this.profitLabel,
    this.profitValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title section
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 19 / 16, // line-height: 19px
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 23),

          // Value section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 17 / 14, // line-height: 17px
                    color: Color(0xFFA8A8A8),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 22 / 18, // line-height: 22px
                  color: Color(0xFF136C3A),
                ),
              ),
            ],
          ),

          // Divider (if COGS and Profit details are included)
          if (cogsLabel != null && cogsValue != null)
            Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: const Color(0xFFF0F0F0),
                ),
                const SizedBox(height: 12),

                // COGS and Profit row
                Row(
                  children: [
                    // COGS column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cogsLabel!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 17 / 14, // line-height: 17px
                              color: Color(0xFFA8A8A8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cogsValue!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 17 / 14, // line-height: 17px
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Profit column (if provided)
                    if (profitLabel != null && profitValue != null)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profitLabel!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                height: 17 / 14, // line-height: 17px
                                color: Color(0xFFA8A8A8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profitValue!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                height: 17 / 14, // line-height: 17px
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
