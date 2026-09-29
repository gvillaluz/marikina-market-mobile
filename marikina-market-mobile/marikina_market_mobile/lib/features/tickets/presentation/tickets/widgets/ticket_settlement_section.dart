import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/penalty_type.dart';

class TicketSettlementSection extends StatelessWidget {
  final PenaltyType penaltyType;
  final int? requiredHours;

  const TicketSettlementSection({
    required this.penaltyType,
    this.requiredHours,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (penaltyType == PenaltyType.communityService) {
      return CommunityServiceLogSection(requiredHours: requiredHours);
    }

    return const SettlementReceiptSection();
  }
}

class SettlementReceiptSection extends StatefulWidget {
  const SettlementReceiptSection({super.key});

  @override
  State<SettlementReceiptSection> createState() =>
      _SettlementReceiptSectionState();
}

class _SettlementReceiptSectionState extends State<SettlementReceiptSection> {
  XFile? _receipt;

  Future<void> _attachReceipt() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (!mounted || photo == null) return;

    if (await File(photo.path).length() > 5 * 1024 * 1024) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receipt photo must be 5 MB or smaller.')),
      );
      return;
    }

    setState(() => _receipt = photo);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settlement Receipt',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'Upload a photo of the official payment receipt to complete this ticket’s settlement record.',
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.lightGrey.withValues(alpha: .5),
            ),
          ),
          child: InkWell(
            onTap: _attachReceipt,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 135),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.lightGrey.withValues(alpha: .7),
                ),
              ),
              child: _receipt == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Tap to attach receipt photo',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'JPG, PNG · max 5 MB each',
                          style: TextStyle(
                            color: AppColors.mediumGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.file(
                        File(_receipt!.path),
                        fit: BoxFit.cover,
                        height: 190,
                        width: double.infinity,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class CommunityServiceLogSection extends StatefulWidget {
  final int? requiredHours;

  const CommunityServiceLogSection({required this.requiredHours, super.key});

  @override
  State<CommunityServiceLogSection> createState() =>
      _CommunityServiceLogSectionState();
}

class _CommunityServiceLogSectionState
    extends State<CommunityServiceLogSection> {
  final _hoursController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<_ServiceLog> _logs = [];
  DateTime _selectedDate = DateTime.now();
  XFile? _proofPhoto;
  bool _isAddingLog = false;
  int? _expandedLogIndex;

  int get _loggedHours => _logs.fold(0, (total, log) => total + log.hours);

  @override
  void dispose() {
    _hoursController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null && mounted) {
      setState(() => _selectedDate = selectedDate);
    }
  }

  Future<void> _attachProof() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (!mounted || photo == null) return;

    if (await File(photo.path).length() > 5 * 1024 * 1024) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proof photo must be 5 MB or smaller.')),
      );
      return;
    }

    setState(() => _proofPhoto = photo);
  }

  void _saveLog() {
    if (!_formKey.currentState!.validate()) return;

    final log = _ServiceLog(
      date: _selectedDate,
      hours: int.parse(_hoursController.text),
      description: _descriptionController.text.trim(),
      proofPhoto: _proofPhoto,
    );

    setState(() {
      _logs.add(log);
      _expandedLogIndex = _logs.length - 1;
      _isAddingLog = false;
      _selectedDate = DateTime.now();
      _hoursController.clear();
      _descriptionController.clear();
      _proofPhoto = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final requiredHours = widget.requiredHours;
    final hasRequirement = requiredHours != null && requiredHours > 0;
    final progress = hasRequirement
        ? (_loggedHours / requiredHours).clamp(0.0, 1.0)
        : 0.0;
    final progressPercent = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Community Service Log',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'Track hours rendered for community service against the required hours on this ticket.',
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.lightGrey.withValues(alpha: .5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryYellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.access_time,
                      color: AppColors.secondaryYellow,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Community Service Log',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          hasRequirement
                              ? '$_loggedHours of $requiredHours hrs completed'
                              : '$_loggedHours hrs logged · required hours unavailable',
                          style: const TextStyle(
                            color: AppColors.mediumGrey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_loggedHours logged',
                    style: const TextStyle(
                      color: AppColors.mediumGrey,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    hasRequirement
                        ? '$progressPercent% of $requiredHours hrs'
                        : '—',
                    style: const TextStyle(
                      color: AppColors.mediumGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 7,
                  backgroundColor: AppColors.tertiary,
                  color: AppColors.primary,
                ),
              ),
              if (_logs.isNotEmpty) ...[
                const SizedBox(height: 12),
                for (var index = 0; index < _logs.length; index++)
                  _buildLogEntry(index),
              ],
              const SizedBox(height: 10),
              if (_isAddingLog)
                _buildLogForm()
              else
                OutlinedButton.icon(
                  onPressed: () => setState(() {
                    _isAddingLog = true;
                    _expandedLogIndex = null;
                  }),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Service Entry'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.tertiary),
                    minimumSize: const Size(double.infinity, 38),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogEntry(int index) {
    final log = _logs[index];
    final isExpanded = _expandedLogIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.tertiary),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                setState(() => _expandedLogIndex = isExpanded ? null : index),
            borderRadius: BorderRadius.circular(9),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      DateFormat('MMM d, yyyy').format(log.date),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blueBackgroundColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${log.hours}h',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: AppColors.mediumGrey,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailRow('Date', DateFormat('MM/dd/yyyy').format(log.date)),
                  const SizedBox(height: 6),
                  _detailRow('Hours worked', '${log.hours} hours'),
                  if (log.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _detailRow('Work performed', log.description),
                  ],
                  if (log.proofPhoto != null) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(log.proofPhoto!.path),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 6),
                    const Text(
                      'No proof photo attached.',
                      style: TextStyle(
                        color: AppColors.mediumGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 105,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.mediumGrey, fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildLogForm() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.tertiary),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Date', style: TextStyle(fontSize: 11)),
            const SizedBox(height: 5),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today_outlined, size: 17),
                ),
                child: Text(DateFormat('MM/dd/yyyy').format(_selectedDate)),
              ),
            ),
            const SizedBox(height: 9),
            const Text('Hours Worked', style: TextStyle(fontSize: 11)),
            const SizedBox(height: 5),
            TextFormField(
              controller: _hoursController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                hintText: 'Enter hours',
              ),
              validator: (value) {
                final hours = int.tryParse(value?.trim() ?? '');
                if (hours == null || hours < 1) {
                  return 'Enter at least 1 hour.';
                }
                return null;
              },
            ),
            const SizedBox(height: 9),
            const Text('Work Performed', style: TextStyle(fontSize: 11)),
            const SizedBox(height: 5),
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                hintText: 'Describe the community service completed',
              ),
            ),
            const SizedBox(height: 9),
            const Text('Proof Documentation', style: TextStyle(fontSize: 11)),
            const SizedBox(height: 5),
            InkWell(
              onTap: _attachProof,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                height: 92,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.lightGrey),
                ),
                child: _proofPhoto == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            color: AppColors.primary,
                            size: 21,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Tap to attach photo',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'JPG, PNG · max 5 MB each',
                            style: TextStyle(
                              color: AppColors.mediumGrey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.file(
                          File(_proofPhoto!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 9),
            Row(
              children: [
                TextButton(
                  onPressed: () => setState(() {
                    _isAddingLog = false;
                    _selectedDate = DateTime.now();
                    _hoursController.clear();
                    _descriptionController.clear();
                    _proofPhoto = null;
                  }),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _saveLog,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Log Hours'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceLog {
  final DateTime date;
  final int hours;
  final String description;
  final XFile? proofPhoto;

  const _ServiceLog({
    required this.date,
    required this.hours,
    required this.description,
    required this.proofPhoto,
  });
}
