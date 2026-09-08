import 'package:flutter/material.dart';

import '../../services/connectivity_service.dart';
import '../adaptive/breakpoints.dart';
import '../widgets/signal_status_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.connectivityService});

  final ConnectivityService? connectivityService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ConnectivityService _connectivityService =
      widget.connectivityService ?? ConnectivityService();

  int _selectedIndex = 0;
  bool _compactCards = false;

  static const _destinations = [
    (
      icon: Icons.space_dashboard_outlined,
      selectedIcon: Icons.space_dashboard,
      label: 'Panel',
    ),
    (
      icon: Icons.network_check_outlined,
      selectedIcon: Icons.network_check,
      label: 'Red',
    ),
    (icon: Icons.tune_outlined, selectedIcon: Icons.tune, label: 'Ajustes'),
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = Breakpoints.of(context);
    final title = _destinations[_selectedIndex].label;
    final content = _Body(
      compactCards: _compactCards,
      connectivityService: _connectivityService,
      selectedIndex: _selectedIndex,
      screenSize: screenSize,
      onCompactChanged: (value) => setState(() => _compactCards = value),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor adaptativo - $title'),
        actions: [
          IconButton(
            tooltip: 'Cambiar densidad',
            icon: Icon(_compactCards ? Icons.view_agenda : Icons.view_compact),
            onPressed: () => setState(() => _compactCards = !_compactCards),
          ),
        ],
      ),
      bottomNavigationBar: screenSize == ScreenSize.mobile
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (i) => setState(() => _selectedIndex = i),
              destinations: [
                for (final d in _destinations)
                  NavigationDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: d.label,
                  ),
              ],
            )
          : null,
      body: screenSize == ScreenSize.mobile
          ? content
          : Row(
              children: [
                NavigationRail(
                  extended: screenSize == ScreenSize.desktop,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (i) =>
                      setState(() => _selectedIndex = i),
                  labelType: screenSize == ScreenSize.desktop
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  destinations: [
                    for (final d in _destinations)
                      NavigationRailDestination(
                        icon: Icon(d.icon),
                        selectedIcon: Icon(d.selectedIcon),
                        label: Text(d.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: content),
              ],
            ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.compactCards,
    required this.connectivityService,
    required this.selectedIndex,
    required this.screenSize,
    required this.onCompactChanged,
  });

  final bool compactCards;
  final ConnectivityService connectivityService;
  final int selectedIndex;
  final ScreenSize screenSize;
  final ValueChanged<bool> onCompactChanged;

  int get _columns {
    if (screenSize == ScreenSize.desktop) return compactCards ? 4 : 3;
    if (screenSize == ScreenSize.tablet) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenSize == ScreenSize.mobile ? double.infinity : 1120,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            child: SingleChildScrollView(
              key: ValueKey(selectedIndex),
              padding: EdgeInsets.all(
                screenSize == ScreenSize.mobile ? 14 : 20,
              ),
              child: switch (selectedIndex) {
                0 => _OverviewTab(
                  columns: _columns,
                  compactCards: compactCards,
                  connectivityService: connectivityService,
                  screenSize: screenSize,
                ),
                1 => _NetworkTab(connectivityService: connectivityService),
                _ => _SettingsTab(
                  compactCards: compactCards,
                  screenSize: screenSize,
                  onCompactChanged: onCompactChanged,
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.columns,
    required this.compactCards,
    required this.connectivityService,
    required this.screenSize,
  });

  final int columns;
  final bool compactCards;
  final ConnectivityService connectivityService;
  final ScreenSize screenSize;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _MetricCard(
        icon: Icons.devices,
        title: 'Modo de vista',
        value: screenSize.label,
        detail: screenSize.description,
      ),
      const _MetricCard(
        icon: Icons.grid_on,
        title: 'Columnas',
        value: 'Adaptables',
        detail: 'La cantidad cambia con el ancho disponible.',
      ),
      const _MetricCard(
        icon: Icons.sensors,
        title: 'Sensor',
        value: 'Conectividad',
        detail: 'Consulta inicial y escucha de cambios en vivo.',
      ),
      _MetricCard(
        icon: compactCards ? Icons.compress : Icons.expand,
        title: 'Densidad',
        value: compactCards ? 'Compacta' : 'Cómoda',
        detail: 'Ajusta la lectura del panel principal.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderBand(screenSize: screenSize),
        const SizedBox(height: 16),
        SignalStatusCard(service: connectivityService),
        const SizedBox(height: 20),
        Text('Indicadores', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final card in cards)
                SizedBox(
                  width: (constraints.maxWidth - 12 * (columns - 1)) / columns,
                  child: card,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NetworkTab extends StatelessWidget {
  const _NetworkTab({required this.connectivityService});

  final ConnectivityService connectivityService;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SignalStatusCard(service: connectivityService),
        const SizedBox(height: 16),
        const _ChecklistTile(
          icon: Icons.wifi_find,
          title: 'Detección automática',
          text:
              'Identifica Wi-Fi, datos móviles, Ethernet, VPN y otros medios.',
        ),
        const _ChecklistTile(
          icon: Icons.offline_bolt,
          title: 'Respuesta sin conexión',
          text: 'El panel cambia de color y mensaje cuando no hay señal.',
        ),
        const _ChecklistTile(
          icon: Icons.autorenew,
          title: 'Actualización manual',
          text: 'El botón de recarga fuerza una nueva lectura del sensor.',
        ),
      ],
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({
    required this.compactCards,
    required this.screenSize,
    required this.onCompactChanged,
  });

  final bool compactCards;
  final ScreenSize screenSize;
  final ValueChanged<bool> onCompactChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MetricCard(
          icon: Icons.aspect_ratio,
          title: 'Pantalla actual',
          value: screenSize.label,
          detail: screenSize.description,
        ),
        const SizedBox(height: 12),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.density_medium),
            title: const Text('Vista compacta'),
            subtitle: const Text(
              'Reduce espacio para mostrar más información.',
            ),
            value: compactCards,
            onChanged: onCompactChanged,
          ),
        ),
      ],
    );
  }
}

class _HeaderBand extends StatelessWidget {
  const _HeaderBand({required this.screenSize});

  final ScreenSize screenSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(Icons.dashboard_customize, color: scheme.onPrimaryContainer),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Panel de sensores responsivo',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    screenSize.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: scheme.tertiary),
            const SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(detail, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title),
          subtitle: Text(text),
        ),
      ),
    );
  }
}

extension on ScreenSize {
  String get label {
    switch (this) {
      case ScreenSize.mobile:
        return 'Móvil';
      case ScreenSize.tablet:
        return 'Tablet';
      case ScreenSize.desktop:
        return 'Escritorio';
    }
  }

  String get description {
    switch (this) {
      case ScreenSize.mobile:
        return 'Navegación inferior y una columna para lectura rápida.';
      case ScreenSize.tablet:
        return 'Rail lateral y dos columnas para aprovechar el espacio.';
      case ScreenSize.desktop:
        return 'Rail extendido y panel amplio para monitoreo continuo.';
    }
  }
}
