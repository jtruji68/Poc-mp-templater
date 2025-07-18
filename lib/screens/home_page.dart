import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/theme_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigateToFlow(BuildContext context, String flowType) {
    Navigator.pushNamed(context, '/form', arguments: flowType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JustDigital'),
        actions: [
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.dark_mode
                : Icons.light_mode),
            tooltip: 'Cambiar tema',
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;

                return isMobile
                    ? Column(
                  children: [
                    _buildBox(context, '🏥', 'Tutelas de Salud', 'tutela_salud'),
                    _buildBox(context, '💰', 'Solicitud de Bancarrota', 'bancarrota'),
                  ],
                )
                    : Row(
                  children: [
                    Expanded(child: _buildBox(context, '🏥', 'Tutelas de Salud', 'tutela_salud')),
                    Expanded(child: _buildBox(context, '💰', 'Solicitud de Bancarrota', 'tutela_salud')),
                  ],
                );
              },
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('© 2025 JustDigital - Contacto | Términos legales'),
          ),
        ],
      ),
    );
  }

  Widget _buildBox(BuildContext context, String emoji, String label, String flowType) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    return GestureDetector(
      onTap: () => _navigateToFlow(context, flowType),
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}