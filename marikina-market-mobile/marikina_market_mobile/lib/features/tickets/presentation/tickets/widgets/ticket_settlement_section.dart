import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/ticket_status.dart';
import 'package:marikina_market_mobile/core/utils/image_picker_util.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/community_service_progress.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/submit_community_service_log_params.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_receipt_proof.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/penalty_type.dart';

class TicketSettlementSection extends StatelessWidget {
  final int ticketId;
  final PenaltyType penaltyType;
  final TicketStatus ticketStatus;
  final int? requiredHours;
  final TicketReceiptProof? receiptProof;
  final bool isReceiptSubmitted;
  final CommunityServiceProgress? communityServiceProgress;
  final bool isLoading;
  final bool isLoaded;
  final bool isSubmitting;
  final VoidCallback onRetryLoad;
  final ValueChanged<File> onSubmitReceipt;
  final ValueChanged<SubmitCommunityServiceLogParams>
  onSubmitCommunityServiceLog;

  const TicketSettlementSection({
    required this.ticketId,
    required this.penaltyType,
    required this.ticketStatus,
    required this.onSubmitReceipt,
    required this.onSubmitCommunityServiceLog,
    required this.onRetryLoad,
    this.requiredHours,
    this.receiptProof,
    this.isReceiptSubmitted = false,
    this.communityServiceProgress,
    this.isLoading = false,
    this.isLoaded = false,
    this.isSubmitting = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (penaltyType == PenaltyType.communityService) {
      return CommunityServiceLogSection(
        ticketId: ticketId,
        requiredHours: requiredHours,
        ticketStatus: ticketStatus,
        progress: communityServiceProgress,
        isLoading: isLoading,
        isLoaded: isLoaded,
        isSubmitting: isSubmitting,
        onRetryLoad: onRetryLoad,
        onSubmit: onSubmitCommunityServiceLog,
      );
    }

    return SettlementReceiptSection(
      ticketStatus: ticketStatus,
      receiptProof: receiptProof,
      isReceiptSubmitted: isReceiptSubmitted,
      isLoading: isLoading,
      isLoaded: isLoaded,
      isSubmitting: isSubmitting,
      onRetryLoad: onRetryLoad,
      onSubmit: onSubmitReceipt,
    );
  }
}

class SettlementReceiptSection extends StatefulWidget {
  final TicketStatus ticketStatus;
  final TicketReceiptProof? receiptProof;
  final bool isReceiptSubmitted;
  final bool isLoading;
  final bool isLoaded;
  final bool isSubmitting;
  final VoidCallback onRetryLoad;
  final ValueChanged<File> onSubmit;

  const SettlementReceiptSection({
    required this.ticketStatus,
    required this.onSubmit,
    required this.onRetryLoad,
    this.receiptProof,
    this.isReceiptSubmitted = false,
    this.isLoading = false,
    this.isLoaded = false,
    this.isSubmitting = false,
    super.key,
  });

  @override
  State<SettlementReceiptSection> createState() =>
      _SettlementReceiptSectionState();
}

class _SettlementReceiptSectionState extends State<SettlementReceiptSection> {
  XFile? _receipt;
  bool _submissionSucceeded = false;

  Future<void> _attachReceipt() async {
    final photo = await _selectPhoto();
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

  Future<XFile?> _selectPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from photos'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return null;

    return ImagePickerUtil.pickImage(
      context: context,
      source: source,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.rear,
    );
  }

  @override
  void didUpdateWidget(covariant SettlementReceiptSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.receiptProof != oldWidget.receiptProof &&
        widget.receiptProof?.proofUrls.isNotEmpty == true) {
      _receipt = null;
    }
    if (oldWidget.isSubmitting &&
        !widget.isSubmitting &&
        widget.receiptProof != oldWidget.receiptProof) {
      _submissionSucceeded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedUrls = widget.receiptProof?.proofUrls ?? const <String>[];
    final isSaved =
        widget.isReceiptSubmitted ||
        savedUrls.isNotEmpty ||
        _submissionSucceeded;
    final isPaid = widget.ticketStatus == TicketStatus.paid;
    final canEdit = !isPaid && !isSaved && widget.isLoaded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SettlementHeading(
          title: 'Settlement Receipt',
          description:
              'Upload a photo of the official payment receipt to complete this ticket’s settlement record.',
        ),
        const SizedBox(height: 10),
        _settlementCard(
          child: Column(
            children: [
              if (widget.isLoading)
                const Padding(
                  padding: EdgeInsets.all(28),
                  child: CircularProgressIndicator(),
                )
              else if (!widget.isLoaded)
                _SettlementLoadError(onRetry: widget.onRetryLoad)
              else if (isSaved)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (savedUrls.isEmpty && _receipt != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.file(
                          File(_receipt!.path),
                          width: double.infinity,
                          height: 190,
                          fit: BoxFit.cover,
                        ),
                      ),
                    for (final url in savedUrls)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.network(
                            url,
                            width: double.infinity,
                            height: 190,
                            fit: BoxFit.cover,
                            errorBuilder: (_, error, stackTrace) =>
                                const _ImageLoadError(),
                          ),
                        ),
                      ),
                    const _ReadOnlyMessage(
                      text:
                          'Settlement receipt saved. This record cannot be changed.',
                    ),
                  ],
                )
              else if (isPaid)
                const _ReadOnlyMessage(
                  text:
                      'This ticket is paid. Settlement details are read-only.',
                )
              else ...[
                InkWell(
                  onTap: canEdit ? _attachReceipt : null,
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
                        ? const _PhotoPickerPrompt(
                            label: 'Tap to attach receipt photo',
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
                if (_receipt != null) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: !canEdit || widget.isSubmitting
                          ? null
                          : () => widget.onSubmit(File(_receipt!.path)),
                      icon: widget.isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.upload_outlined, size: 18),
                      label: Text(
                        widget.isSubmitting
                            ? 'Saving receipt...'
                            : 'Save Receipt',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class CommunityServiceLogSection extends StatefulWidget {
  final int ticketId;
  final int? requiredHours;
  final TicketStatus ticketStatus;
  final CommunityServiceProgress? progress;
  final bool isLoading;
  final bool isLoaded;
  final bool isSubmitting;
  final VoidCallback onRetryLoad;
  final ValueChanged<SubmitCommunityServiceLogParams> onSubmit;

  const CommunityServiceLogSection({
    required this.ticketId,
    required this.requiredHours,
    required this.ticketStatus,
    required this.onSubmit,
    required this.onRetryLoad,
    this.progress,
    this.isLoading = false,
    this.isLoaded = false,
    this.isSubmitting = false,
    super.key,
  });

  @override
  State<CommunityServiceLogSection> createState() =>
      _CommunityServiceLogSectionState();
}

class _CommunityServiceLogSectionState
    extends State<CommunityServiceLogSection> {
  final _hoursController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  XFile? _proofPhoto;
  bool _isAddingLog = false;
  int? _expandedLogIndex;

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CommunityServiceLogSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress &&
        oldWidget.isSubmitting &&
        !widget.isSubmitting) {
      _resetForm();
      _expandedLogIndex = widget.progress == null
          ? null
          : widget.progress!.entries.length - 1;
    }
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
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from photos'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    final photo = await ImagePickerUtil.pickImage(
      context: context,
      source: source,
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

  void _submitLog() {
    if (!_formKey.currentState!.validate()) return;
    final proofPhoto = _proofPhoto;
    if (proofPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attach proof documentation to continue.'),
        ),
      );
      return;
    }
    final hours = double.parse(_hoursController.text.trim());
    widget.onSubmit(
      SubmitCommunityServiceLogParams(
        ticketId: widget.ticketId,
        proofFile: File(proofPhoto.path),
        serviceDate: _selectedDate,
        hoursWorked: hours,
      ),
    );
  }

  void _resetForm() {
    _hoursController.clear();
    _proofPhoto = null;
    _selectedDate = DateTime.now();
    _isAddingLog = false;
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.progress;
    final requiredHours = progress?.hoursRequired ?? widget.requiredHours;
    final completedHours = progress?.hoursCompleted ?? 0;
    final hasRequirement = requiredHours != null && requiredHours > 0;
    final isComplete =
        progress != null && progress.hoursCompleted >= progress.hoursRequired;
    final isPaid = widget.ticketStatus == TicketStatus.paid;
    final canEdit = !isPaid && !isComplete && widget.isLoaded;
    final percentage = progress == null
        ? 0.0
        : (progress.completionPercentage / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SettlementHeading(
          title: 'Community Service Log',
          description:
              'Track hours rendered for community service against the required hours on this ticket.',
        ),
        const SizedBox(height: 10),
        _settlementCard(
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
                              ? '${_formatHours(completedHours)} of $requiredHours hrs completed'
                              : 'Community service progress is unavailable',
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
              if (widget.isLoading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                )
              else if (!widget.isLoaded)
                _SettlementLoadError(onRetry: widget.onRetryLoad)
              else if (progress == null)
                const Text(
                  'Unable to load community service entries.',
                  style: TextStyle(color: AppColors.mediumGrey),
                )
              else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_formatHours(progress.hoursCompleted)} logged',
                      style: const TextStyle(
                        color: AppColors.mediumGrey,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      '${progress.completionPercentage.round()}% of ${progress.hoursRequired} hrs',
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
                    value: percentage,
                    minHeight: 7,
                    backgroundColor: AppColors.tertiary,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${_formatHours(progress.hoursRemaining)} hrs remaining',
                    style: const TextStyle(
                      color: AppColors.mediumGrey,
                      fontSize: 11,
                    ),
                  ),
                ),
                if (progress.entries.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  for (var index = 0; index < progress.entries.length; index++)
                    _buildLogEntry(progress.entries[index], index),
                ],
              ],
              if (isPaid)
                const _ReadOnlyMessage(
                  text:
                      'This ticket is paid. Settlement details are read-only.',
                )
              else if (isComplete)
                const _ReadOnlyMessage(
                  text: 'Required community service hours are complete.',
                )
              else if (canEdit && progress != null) ...[
                const SizedBox(height: 10),
                if (_isAddingLog)
                  _buildLogForm()
                else
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _isAddingLog = true),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Service Entry'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.tertiary),
                      minimumSize: const Size(double.infinity, 38),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogEntry(CommunityServiceLog log, int index) {
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
                      DateFormat('MMM d, yyyy').format(log.serviceDate),
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
                      '${_formatHours(log.hoursWorked)}h',
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
                  _detailRow(
                    'Date',
                    DateFormat('MM/dd/yyyy').format(log.serviceDate),
                  ),
                  const SizedBox(height: 6),
                  _detailRow(
                    'Hours worked',
                    '${_formatHours(log.hoursWorked)} hours',
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      log.proofUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, error, stackTrace) =>
                          const _ImageLoadError(),
                    ),
                  ),
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
    return AbsorbPointer(
      absorbing: widget.isSubmitting,
      child: Container(
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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  hintText: 'Enter hours',
                ),
                validator: (value) {
                  final hours = double.tryParse(value?.trim() ?? '');
                  if (hours == null || hours <= 0) {
                    return 'Enter more than 0 hours.';
                  }
                  return null;
                },
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
                      ? const _PhotoPickerPrompt(
                          label: 'Tap to attach proof photo',
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
                    onPressed: () => setState(_resetForm),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _submitLog,
                      icon: widget.isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.add, size: 16),
                      label: Text(
                        widget.isSubmitting ? 'Saving...' : 'Log Hours',
                      ),
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
      ),
    );
  }
}

class _SettlementHeading extends StatelessWidget {
  final String title;
  final String description;

  const _SettlementHeading({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(description),
      ],
    );
  }
}

class _PhotoPickerPrompt extends StatelessWidget {
  final String label;

  const _PhotoPickerPrompt({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.add_a_photo_outlined, color: AppColors.primary),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'JPG, PNG · max 5 MB each',
          style: TextStyle(color: AppColors.mediumGrey, fontSize: 12),
        ),
      ],
    );
  }
}

class _ReadOnlyMessage extends StatelessWidget {
  final String text;

  const _ReadOnlyMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(color: AppColors.mediumGrey, fontSize: 12),
        ),
      ),
    );
  }
}

class _ImageLoadError extends StatelessWidget {
  const _ImageLoadError();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: AppColors.primaryLight,
      alignment: Alignment.center,
      child: const Text(
        'Unable to load photo.',
        style: TextStyle(color: AppColors.mediumGrey),
      ),
    );
  }
}

class _SettlementLoadError extends StatelessWidget {
  final VoidCallback onRetry;

  const _SettlementLoadError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Unable to load settlement details.',
          style: TextStyle(color: AppColors.mediumGrey),
        ),
        TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}

Widget _settlementCard({required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.lightGrey.withValues(alpha: .5)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .06),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );
}

String _formatHours(double hours) {
  if (hours == hours.roundToDouble()) return hours.toStringAsFixed(0);
  return hours.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
}
