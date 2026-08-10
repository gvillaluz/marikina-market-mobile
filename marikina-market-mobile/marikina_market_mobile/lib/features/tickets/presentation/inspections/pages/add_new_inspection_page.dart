import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/di/dependency_injection.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/severity.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/app_primary_btn.dart';
import 'package:marikina_market_mobile/core/utils/date_formatter_util.dart';
import 'package:marikina_market_mobile/features/auth/domain/entities/user.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/fine_breakdown_item.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/fine_summary.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/inspection_form_data.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ordinance.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/vendor_summary.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/penalty_type.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/violation_type.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_event.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/form/add_photo_evidence_btn.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/form/dialogs/duplicate_warning_dialog.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/form/inspection_type_toggle.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/form/payment_type_section.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/form/bottom_sheets/select_ordinance_bottom_sheet.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/form/ticket_violation_card.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/form/violator_info_card.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class AddNewInspectionPage extends StatefulWidget {
  final User user;

  const AddNewInspectionPage({
    required this.user,
    super.key
  });

  @override
  State<StatefulWidget> createState() => _AddNewInspectionPageState();
}

class _AddNewInspectionPageState extends State<AddNewInspectionPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _stallNumberController = TextEditingController();
  final TextEditingController _tradeNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _ticketDescriptionController = TextEditingController();
  final TextEditingController _communityHrsController = TextEditingController();

  String? _photoError;
  String? _ordinanceError;
  String? _communityHrsError;
  String? _descriptionError;
  String? _vendorError;

  ViolationType _selectedType = ViolationType.warning;

  VendorSummary? _vendorSummary;
  FineSummary? _fineSummary;

  List<Ordinance> _selectedOrdinances = [];
  final List<XFile> _capturedEvidences = [];

  PenaltyType _selectedPenaltyType = PenaltyType.cashFine;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    context.read<InspectionBloc>().add(LoadOrdinances());
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void _onChangeOrdinance(List<Ordinance> ordinances) {
    setState(() {
      _selectedOrdinances = ordinances;
      if (ordinances.isNotEmpty) _ordinanceError = null;
    });
  }

  bool get _isFormEmpty {
    final isTicket = _selectedType == ViolationType.ticket;
    final hasVendorOrOrdinances = _vendorSummary != null || _selectedOrdinances.isNotEmpty;
    final hasEvidences = isTicket && _capturedEvidences.isNotEmpty;
    return !hasVendorOrOrdinances && !hasEvidences;
  }

  Future<bool> _confirmDiscard(BuildContext context) async {
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        actionsAlignment: MainAxisAlignment.center,
        titlePadding: const EdgeInsets.only(
          bottom: 0,
        ),
        contentPadding: const EdgeInsets.only(
          top: 7,
          left: 20,
          right: 20,
          bottom: 10
        ),

        icon: Icon(
          Icons.info_outline,
          size: 50,
          color: AppColors.primaryRed,
          
        ),
        title: const Text(
          'Discard Inspection?',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'Your changes will be lost if you leave this page.',
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Stay'),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: AppColors.primaryRed),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Discard'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    
    return confirmed == true;
  }

  Future<void> _handleOrdinanceSelect(BuildContext context) async {
    if (_vendorSummary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          content: const Text(
            'Please fill out vendor\'s information first.',
            style: TextStyle(color: AppColors.primaryLight),
          )
        ),
      );
      return;
    }
    
    final fineSummary = await showModalBottomSheet(
      context: context, 
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => BlocProvider(
        create: (_) => sl<InspectionBloc>(),
        child: SelectOrdinanceBottomSheet(
          isWarningTicket: _selectedType == ViolationType.warning ? true : false,
          ordinances: _selectedOrdinances,
          onChanged: _onChangeOrdinance,
          vendorId: _vendorSummary?.id,
        ),
      )
    );

    if (fineSummary != null) {
      bool hasDuplicate = false;
      List<FineBreakdownItem> duplicateOrdinances = [];
      
      setState(() {
        _fineSummary = fineSummary;

        final duplicatedSummaryIds = _fineSummary?.breakdownItems
          .where((f) => f.isDuplicate == true)
          .map((f) => f.ordinanceId)
          .toSet();

        if (duplicatedSummaryIds != null && duplicatedSummaryIds.isNotEmpty) {
          hasDuplicate = true;

          duplicateOrdinances = _fineSummary!.breakdownItems
            .where((f) => f.isDuplicate == true)
            .toList();

          _selectedOrdinances.removeWhere((o) => duplicatedSummaryIds.contains(o.id));
          _fineSummary!.breakdownItems.removeWhere((o) => o.isDuplicate);
        }
      });

      if (hasDuplicate) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            backgroundColor: AppColors.tertiaryYellow,
            leading: Icon(
              Icons.warning,
              color: AppColors.secondaryYellow,
            ),
            content: const Text(
              'Removed: Vendor already has an open ticket for this ordinance.',
              style: TextStyle(
                color: AppColors.secondaryYellow
              ),
            ), 
            actions: [
              TextButton(
                onPressed: () => showAdaptiveDialog(
                  context: context, 
                  builder: (_) => DuplicateWarningDialog(duplicateOrdinances: duplicateOrdinances)
                ),
                child: const Text(
                  'SHOW',
                  style: TextStyle(
                    color: AppColors.secondaryYellow
                  ),
                )
              )
            ]
          )
        );
      }
    }
  }

  void addEvidence(XFile photo) => setState(() {
    _capturedEvidences.add(photo);
    setState(() => _photoError = null);
  });

  void removeEvidence(int index) => setState(() => _capturedEvidences.removeAt(index));

  void _populateVendorInfo(VendorSummary vendor) {
    setState(() {
      _vendorError = null;
      _vendorSummary = vendor;
      _stallNumberController.text = vendor.stallNumber;
      _tradeNameController.text = vendor.tradeName;
      _lastNameController.text = vendor.lastName;
      _firstNameController.text = vendor.firstName;
      _middleNameController.text = vendor.middleName;
    });
  }

  void _onChangePenaltyType(PenaltyType value) {
    setState(() => _selectedPenaltyType = value);
  }

  bool _validateForm() {
    final isTicket = _selectedType == ViolationType.ticket;

    final isTextValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      _vendorError = (_vendorSummary == null &&
              _stallNumberController.text.trim().isEmpty)
          ? 'Please select a registered vendor or enter stall info.'
          : null;

      _ordinanceError = _selectedOrdinances.isEmpty
          ? 'Please select at least one ordinance.'
          : null;

      _descriptionError = _ticketDescriptionController.text.trim().isEmpty
          ? 'Description is required.'
          : null;

      _photoError = (isTicket && _capturedEvidences.isEmpty)
          ? 'At least one photo evidence is required for tickets.'
          : null;

      if (isTicket && _selectedPenaltyType == PenaltyType.communityService) {
        final hours = int.tryParse(_communityHrsController.text.trim());
        _communityHrsError = (hours == null || hours < 3)
            ? 'Minimum of 3 hours required.'
            : null;
      } else {
        _communityHrsError = null;
      }
    });

    return isTextValid &&
        _vendorError == null &&
        _ordinanceError == null &&
        _descriptionError == null &&
        _photoError == null &&
        _communityHrsError == null;
  }

  void _submit() {
    if (!_validateForm()) return;

    final isTicket = _selectedType == ViolationType.ticket;
    int? communityHrs;
    if (isTicket && _selectedPenaltyType == PenaltyType.communityService) {
      communityHrs = int.tryParse(_communityHrsController.text.trim());
    }

    context.pushNamed(
      Routes.newInspectionPreviewName, 
      extra: InspectionFormData(
        enforcerId: widget.user.userId,
        vendorSummary: _vendorSummary!, 
        fineSummary: _fineSummary,
        ordinances: _selectedOrdinances, 
        evidences: _capturedEvidences, 
        description: _ticketDescriptionController.text.trim(), 
        ticketType: _selectedType, 
        penaltyType: _selectedPenaltyType,
        communityServiceHrs: communityHrs
      ));
  }

  @override
  Widget build(BuildContext context) {
    bool isTicket = _selectedType == ViolationType.ticket;

    return PopScope(
      canPop: _isFormEmpty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _confirmDiscard(context) && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'New Inspection',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InspectionTypeToggle(
                    selected: _selectedType, 
                    onChange: (type) => setState(() {
                       _selectedType = type;
                       _selectedOrdinances = [];
                       _fineSummary = null;
                      _photoError = null;
                      _ordinanceError = null;
                      _communityHrsError = null;
                    })
                  ),
            
                  const SizedBox(height: 20,),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRowLabel('DATE:', DateTimeFormatter.getDate(DateTime.now())),
                      const SizedBox(height: 5,),
                      _buildRowLabel('MARKET ENFORCER:', '${widget.user.firstName} ${widget.user.lastName}'),
                    ],
                  ),
            
                  const SizedBox(height: 20,),
            
                  ViolatorInfoCard(
                    stallNumberController: _stallNumberController,
                    tradeNameController: _tradeNameController,
                    lastNameController: _lastNameController,
                    firstNameController: _firstNameController,
                    middleNameController: _middleNameController,
                    onVendorSelected: _populateVendorInfo,
                    errorMessage: _vendorError
                  ),
            
                  const SizedBox(height: 20,),
            
                  TicketViolationCard(
                    onPressed: _handleOrdinanceSelect,
                    ordinances: _selectedOrdinances,
                    capturedPhotos: _capturedEvidences,
                    fineSummary: _fineSummary,
                    isTicket: isTicket,
                    errorMessage: _ordinanceError
                  ),
            
                  if (_fineSummary != null && 
                      _fineSummary!.breakdownItems.isNotEmpty &&
                      isTicket && 
                      _selectedOrdinances.isNotEmpty) ...[
                    PaymentTypeSection(
                      selectedPenaltyType: _selectedPenaltyType,
                      severity: _fineSummary?.severity ?? Severity.low,
                      totalFineAmount: _fineSummary?.totalPaymentAmount ?? 0.0, 
                      onChangeType: _onChangePenaltyType,
                      communityHrsController: _communityHrsController,
                      communityHrsError: _communityHrsError,

                    ),
                    const SizedBox(height: 20,),
                  ],
            
                  const Text(
                    'DESCRIPTION'
                  ),
                  const SizedBox(height: 5,),
                  TextFormField(
                    controller: _ticketDescriptionController,
                    maxLines: 5,
                    minLines: 3,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      errorText: _descriptionError,
                      border: const OutlineInputBorder(),
                    ),
                  ),
            
                  if (isTicket) ...[
                    const SizedBox(height: 20,),
                    const Text(
                      'PHOTO EVIDENCE'
                    ),
                    const SizedBox(height: 5,),
            
                    AddPhotoEvidenceBtn(
                        photos: _capturedEvidences,
                        onPhotoAdded: (photo) => addEvidence(photo),
                        onPhotoRemoved: (index) => removeEvidence(index),
                        isInvalid: _photoError != null,
                      ),
            
                    if (_photoError != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const SizedBox(width: 15,),
                          Text(
                            _photoError!,
                            style: const TextStyle(
                              color: AppColors.primaryRed,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
            
                  const SizedBox(height: 30,),
            
                  AppPrimaryButton(
                    label: 'Submit ${isTicket ? 'Ticket': 'Warning'}', 
                    iconData: Icons.gavel, 
                    onPressed: _submit
                  ),
            
                  const SizedBox(height: 10,),
            
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryRed,
                        backgroundColor: AppColors.secondaryRed.withValues(alpha: .30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: BorderSide(
                          color: AppColors.primaryRed
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () async {
                        if (_isFormEmpty) {
                          Navigator.of(context).pop();
                        } else if (await _confirmDiscard(context) && context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }, 
                      child: const Text('Cancel')
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  Row _buildRowLabel(String label, String value) {
    return Row(
      spacing: 5,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.lightGrey
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15
          ),
        )
      ],
    );
  }
}