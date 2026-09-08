import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/connectivity_service.dart';

/// Tarjeta que muestra en vivo si el teléfono tiene señal/conexión y de
/// qué tipo (Wi-Fi, datos móviles, etc.), usando [ConnectivityService].
class SignalStatusCard extends StatefulWidget {
  const SignalStatusCard({super.key, required this.service});

  final ConnectivityService service;

  @override
  State<SignalStatusCard> createState() => _SignalStatusCardState();
}

class _SignalStatusCardState extends State<SignalStatusCard> {
  StreamSubscription<SignalStatus>? _subscription;
  SignalStatus? _status;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitial();
    _subscription = widget.service.statusStream.listen(
      (status) {
        if (mounted) {
          setState(() {
            _status = status;
            _loading = false;
            _error = null;
          });
        }
      },
      onError: (Object error) {
        if (mounted) {
          setState(() {
            _loading = false;
            _error = 'No se pudo consultar la red';
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    try {
      final status = await widget.service.checkNow();
      if (mounted) {
        setState(() {
          _status = status;
          _loading = false;
          _error = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'No se pudo consultar la red';
        });
      }
    }
  }

  IconData _iconFor(SignalStatus status) {
    switch (status) {
      case SignalStatus.wifi:
        return Icons.wifi;
      case SignalStatus.mobile:
        return Icons.signal_cellular_alt;
      case SignalStatus.ethernet:
        return Icons.settings_ethernet;
      case SignalStatus.vpn:
        return Icons.vpn_lock;
      case SignalStatus.bluetooth:
        return Icons.bluetooth;
      case SignalStatus.other:
        return Icons.link;
      case SignalStatus.none:
        return Icons.signal_cellular_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_loading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final status = _status ?? SignalStatus.none;
    final hasSignal = status.hasSignal;
    final color = hasSignal ? const Color(0xFF16865A) : scheme.error;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_iconFor(status), color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _error ??
                        (hasSignal
                            ? 'Conexión disponible'
                            : 'Conexión interrumpida'),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(status.label, style: textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatusChip(
                        icon: Icons.bolt,
                        label: hasSignal ? 'Activo' : 'Revisar',
                      ),
                      _StatusChip(icon: Icons.sync, label: 'Tiempo real'),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Actualizar',
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                setState(() => _loading = true);
                await _loadInitial();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: scheme.onSecondaryContainer),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
