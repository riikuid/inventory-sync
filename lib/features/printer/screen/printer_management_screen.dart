// lib/features/printer/presentation/screens/printer_management_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/utils/custom_back_button.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import '../../../core/styles/color_scheme.dart';
import '../bloc/printer_cubit.dart';

class PrinterManagementScreen extends StatefulWidget {
  const PrinterManagementScreen({super.key});

  @override
  State<PrinterManagementScreen> createState() =>
      _PrinterManagementScreenState();
}

class _PrinterManagementScreenState extends State<PrinterManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-check koneksi saat masuk screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrinterCubit>().checkConnection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        leading: CustomBackButton(),
        title: Text(
          'Manajemen Printer',
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocConsumer<PrinterCubit, PrinterState>(
        listener: (context, state) {
          // Show snackbar untuk error
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<PrinterCubit>().checkConnection();
              await context.read<PrinterCubit>().scanPrinters();
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. STATUS CARD
                _buildStatusCard(context, state),

                const SizedBox(height: 20),

                // 2. CONNECTED PRINTER (jika ada)
                if (state.selectedDevice != null) ...[
                  _buildConnectedPrinterCard(context, state),
                  const SizedBox(height: 20),
                ],

                // 3. AVAILABLE DEVICES
                _buildAvailableDevicesSection(context, state),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<PrinterCubit>().scanPrinters();
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.refresh, color: Colors.white),
        label: const Text(
          'Scan Ulang',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // STATUS CARD
  Widget _buildStatusCard(BuildContext context, PrinterState state) {
    final isConnected = state.isConnected;
    final statusColor = isConnected ? Colors.green : Colors.orange;
    final statusIcon = isConnected ? Icons.check_circle : Icons.warning_amber;
    final statusText = isConnected
        ? 'Printer Terhubung'
        : 'Belum Terhubung ke Printer';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Icon(statusIcon, size: 48, color: statusColor),
          const SizedBox(height: 12),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.statusMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // CONNECTED PRINTER CARD
  Widget _buildConnectedPrinterCard(BuildContext context, PrinterState state) {
    final device = state.selectedDevice!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bluetooth_connected,
                  color: Colors.green,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Printer Aktif',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      device.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'AKTIF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tag,
                  size: 16,
                  color: AppColors.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'MAC: ${device.macAdress}',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: AppColors.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final confirm = await _showDisconnectDialog(context);
                    if (confirm == true && context.mounted) {
                      context.read<PrinterCubit>().disconnect();
                    }
                  },
                  icon: const Icon(Icons.link_off, size: 18),
                  label: const Text('Putuskan'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await context.read<PrinterCubit>().reconnect();
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Reconnect'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // AVAILABLE DEVICES SECTION
  Widget _buildAvailableDevicesSection(
    BuildContext context,
    PrinterState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Printer Tersedia',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              '${state.availableDevices.length} device',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (state.availableDevices.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.bluetooth_searching,
                  size: 48,
                  color: AppColors.onSurface.withOpacity(0.3),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tidak ada printer ditemukan',
                  style: TextStyle(
                    color: AppColors.onSurface.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pastikan Bluetooth aktif dan\nprinter sudah di-pairing',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.onSurface.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        else
          ...state.availableDevices.map((device) {
            final isConnected =
                state.selectedDevice?.macAdress == device.macAdress;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isConnected
                      ? Colors.green.withOpacity(0.5)
                      : AppColors.border,
                  width: isConnected ? 2 : 1,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isConnected
                        ? Colors.green.withOpacity(0.1)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isConnected
                        ? Icons.bluetooth_connected
                        : Icons.bluetooth_disabled,
                    color: isConnected ? Colors.green : AppColors.primary,
                    size: 24,
                  ),
                ),
                title: Text(
                  device.name,
                  style: TextStyle(
                    fontWeight: isConnected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  device.macAdress,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: AppColors.onSurface.withOpacity(0.5),
                  ),
                ),
                trailing: isConnected
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'AKTIF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.onSurface.withOpacity(0.3),
                      ),
                onTap: isConnected
                    ? null
                    : () {
                        context.read<PrinterCubit>().connect(device);
                      },
              ),
            );
          }).toList(),
      ],
    );
  }

  Future<bool?> _showDisconnectDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Putuskan Koneksi?'),
        content: const Text(
          'Apakah Anda yakin ingin memutuskan koneksi dengan printer ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Putuskan'),
          ),
        ],
      ),
    );
  }
}
