import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/severity.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ordinance.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_event.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_state.dart';

class SelectOrdinanceBottomSheet extends StatefulWidget {
  final bool isWarningTicket;
  final List<Ordinance> ordinances;
  final ValueChanged<List<Ordinance>> onChanged;
  final int? vendorId;

  const SelectOrdinanceBottomSheet({
    required this.isWarningTicket,
    required this.ordinances,
    required this.onChanged,
    required this.vendorId,
    super.key
  });

  @override
  State<StatefulWidget> createState() => _SelectOrdinanceBottomSheetState();
}

class _SelectOrdinanceBottomSheetState extends State<SelectOrdinanceBottomSheet> {
  final List<Ordinance> _selectedOrdinance = [];
  List<Ordinance> _availableOrdinance = [];

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedOrdinance.addAll(widget.ordinances);
    context.read<InspectionBloc>().add(LoadOrdinanceSelection());
  }

  void _confirmSelection() {
    if (widget.vendorId == null) return;

    if (widget.isWarningTicket) {
      widget.onChanged(_selectedOrdinance);
      Navigator.pop(context, null);
      return;
    }

    context.read<InspectionBloc>().add(FineSummaryRequested(
      _selectedOrdinance.map((o) => o.id).toList(),
      widget.vendorId
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<InspectionBloc, InspectionState>(
      listener: (context, state) {
        if (state is OrdinanceSelectionLoaded) {
          setState(() {
            final ordinances = state.ordinances;
            _availableOrdinance = widget.isWarningTicket 
              ? ordinances.where((o) => o.severity == Severity.low).toList()
              : ordinances;
          });
        }

        if (state is FineSummaryLoaded) {
          widget.onChanged(_selectedOrdinance);
          Navigator.pop(context, state.summary);
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.90,
        minChildSize: 0.1,
        maxChildSize: 1,
        expand: false,
        builder:(context, scrollController) {
          return Padding(
             padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Select ordinance',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 5,),
                    TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        hintText: 'Search ordinance number or series'
                      ),
                    ),
                    const SizedBox(height: 10,),
                  
                    if (_selectedOrdinance.isNotEmpty) ...{
                      Wrap(
                        spacing: 2,
                        runSpacing: 0,
                        children: _selectedOrdinance.map((ordinance) {
                          return Chip(
                            label: Text(
                              ordinance.ordinanceNo,
                              style: const TextStyle(fontSize: 13),
                            ),
                            backgroundColor: AppColors.primary.withValues(alpha: .10),
                            side: BorderSide(color: AppColors.primary.withValues(alpha: .30)),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () => setState(() => _selectedOrdinance.remove(ordinance)),
                          );
                        }).toList(),
                      ),
                  
                      const Divider(height: 20,),
                    },
                  
                    Expanded(
                      child: BlocBuilder<InspectionBloc, InspectionState>(
                        builder:(context, state) {
                          if (state is OrdinanceSelectionLoading && _availableOrdinance.isEmpty) {
                            return SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  const SizedBox(height: 70,),
                                  const CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 5,
                                  )
                                ],
                              ),
                            );
                          }
                  
                          if (_availableOrdinance.isNotEmpty) {
                            final ordinanceList = _availableOrdinance
                              .where((o) => 
                                o.ordinanceNo.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                                o.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                              .toList();
                  
                            if (ordinanceList.isEmpty) {
                              return SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 70,),
                                    const Icon(
                                      Icons.search_off,
                                      size: 70,
                                      color: AppColors.lightGrey,
                                    ),
                                    const Text(
                                      'No ordinance found.',
                                      style: TextStyle(
                                        color: AppColors.lightGrey,
                                        fontSize: 16
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                      
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Ordinances',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                      
                                const SizedBox(height: 10,),
                  
                                Expanded(
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) => const SizedBox(height: 8,),
                                    itemCount: ordinanceList.length,
                                    itemBuilder:(context, index) {
                                      final ordinance = ordinanceList[index];
                                      bool isSelected = _selectedOrdinance.any((o) => o.id == ordinance.id);
                                  
                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isSelected ? AppColors.primary : AppColors.lightGrey,
                                            width: 2
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          onTap: () => setState(() {
                                            if (_selectedOrdinance.contains(ordinance)) {
                                              return;
                                            } else {
                                              if (widget.isWarningTicket && _selectedOrdinance.isNotEmpty) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    backgroundColor: AppColors.primary,
                                                    content: Text(
                                                      'Warnings can only have one ordinance.',
                                                      style: TextStyle(
                                                        color: AppColors.primaryLight
                                                      ),
                                                    )
                                                  )
                                                );
                                                return;
                                              }
                                              
                                              _selectedOrdinance.add(ordinance);
                                            }
                                          }),
                                  
                                          title: Text(
                                            ordinance.ordinanceNo,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                  
                                          subtitle: Text(
                                            ordinance.ordinanceCode
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                  
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.primaryLight,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                    ),
                                    onPressed: _selectedOrdinance.isEmpty ? null : () {
                                      _confirmSelection();
                                    }, 
                                    child: BlocBuilder<InspectionBloc, InspectionState>(
                                      builder:(context, state) {
                                        if (state is FineSummaryLoading) {
                                          return SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: AppColors.primaryLight,
                                            ),
                                          );
                                        }
                  
                                        return const Text(
                                          'CONFIRM SELECTION',
                                          style: TextStyle(
                                            color: AppColors.primaryLight,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                          ),
                                        );
                                      },
                                    )
                                  ),
                                )
                              ],
                            );
                          }
                      
                          return SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                const SizedBox(height: 70,),
                                const Icon(
                                  Icons.storefront,
                                  size: 70,
                                  color: AppColors.lightGrey,
                                ),
                                const Text(
                                  'Search results will appear here.',
                                  style: TextStyle(
                                    color: AppColors.lightGrey,
                                    fontSize: 16
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                ],
              ),
          );
        },
      ),
    );
  }
}