import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/vendor_summary.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_event.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_state.dart';

class SearchByStallBottomSheet extends StatefulWidget {
  const SearchByStallBottomSheet({
    super.key
  });

  @override
  State<StatefulWidget> createState() => _SearchByStallBottomSheetState();
}

class _SearchByStallBottomSheetState extends State<SearchByStallBottomSheet> {
  Timer? _debouncer;

  int? selectedVendor;

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debouncer?.isActive ?? false) _debouncer!.cancel();

    _debouncer = Timer(const Duration(milliseconds: 400), () {
      if (query.isNotEmpty) {
        selectedVendor = null;
        context.read<InspectionBloc>().add(SearchByStallNumberRequested(query));
      }
    });
  }

  void _onSelectVendor(VendorSummary vendor) {
    Navigator.pop(context, vendor);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InspectionBloc, InspectionState>(
      listener:(context, state) {
        if (state is InspectionSearchError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error)
            )
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.1,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search by Stall Number',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 5,),
                  TextField(
                    onChanged: _onSearchChanged,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: 'Enter stall number'
                    ),
                  ),
                  const SizedBox(height: 10,),
        
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      SizedBox(width: 5,),
                      Icon(
                        Icons.info,
                        color: AppColors.mediumGrey,
                        size: 20,
                      ),
                      Expanded(
                        child: Text(
                          'Stall number can be found in the business permit document.',
                          style: TextStyle(
                            color: AppColors.mediumGrey,
                            fontSize: 13
                          ),
                          softWrap: true,
                        ),
                      )
                    ],
                  ),
        
                  Expanded(
                    child: BlocBuilder<InspectionBloc, InspectionState>(
                      builder:(context, state) {
                        if (state is InspectionSearchLoading) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 4,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Searching...',
                                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Looking for vendors matching that stall number.',
                                    style: TextStyle(color: AppColors.mediumGrey, fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
        
                        if (state is InspectionSearchList) {
                          final vendorsList = state.vendorList;
        
                          if (vendorsList.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: .10),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.search_off, size: 32, color: AppColors.primary),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No vendors found',
                                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'No vendors are registered under that stall number. Double check and try again.',
                                      style: TextStyle(color: AppColors.mediumGrey, fontSize: 13),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                    
                          return Column(
                            children: [
                              const SizedBox(height: 20,),
                              Row(
                                spacing: 10,
                                children: [
                                  const Text(
                                    'Matching vendors',
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: .20),
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Text(
                                      '${vendorsList.length} result${vendorsList.length > 1 ? 's' : ''}',
                                      style: const TextStyle(
                                        color: AppColors.primary
                                      ),
                                    ),
                                  )
                                ],
                              ),
                    
                              const SizedBox(height: 10,),
        
                              Expanded(
                                child: ListView.builder(
                                  itemCount: vendorsList.length,
                                  itemBuilder:(context, index) {
                                    final vendor = vendorsList[index];
                                    bool isSelected = vendor.id == selectedVendor;
                                
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
                                        onTap: () => setState(() => selectedVendor = vendor.id),
        
                                        leading: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: .50),
                                            borderRadius: BorderRadius.circular(50)
                                          ),
                                          child: Icon(
                                            Icons.storefront,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                
                                        title: Text(
                                          vendor.tradeName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                
                                        subtitle: Text(
                                          '${vendor.firstName} ${vendor.lastName}'
                                        ),
                                
                                        trailing: Icon(
                                          isSelected ? Icons.check_circle : null,
                                          color: AppColors.primary,
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
                                  onPressed: selectedVendor == null ? null : () {
                                    final vendor = vendorsList.firstWhere((v) => v.id == selectedVendor);
                                    _onSelectVendor(vendor);
                                  }, 
                                  child: const Text(
                                    'SELECT VENDOR',
                                    style: TextStyle(
                                      color: AppColors.primaryLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                    ),
                                  )
                                ),
                              )
                            ],
                          );
                        }
                    
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: .10),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.storefront_outlined, size: 32, color: AppColors.primary),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Search results will appear here',
                                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Enter a stall number above to find matching vendors.',
                                  style: TextStyle(color: AppColors.mediumGrey, fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              )
            );
          }
        ),
      ),
    );
  }
}