import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/inquiry_store.dart';

class AdminInquiriesScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final VoidCallback? onBack;
  const AdminInquiriesScreen({super.key, this.scaffoldKey, this.onBack});

  @override
  State<AdminInquiriesScreen> createState() => _AdminInquiriesScreenState();
}

class _AdminInquiriesScreenState extends State<AdminInquiriesScreen> {
  InquiryStatusType? _filterStatus;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: InquiryStore.instance,
      builder: (context, _) {
        final store = InquiryStore.instance;
        final allInquiries = store.inquiries;
        final filteredList = _filterStatus == null
            ? allInquiries
            : allInquiries.where((i) => i.status == _filterStatus).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: const Color(0xFF0F4E31),
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: (widget.onBack != null || Navigator.canPop(context))
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  )
                : null,
            title: const Text(
              'Visitor Inquiries & Leads',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          body: Column(
            children: [
              // Metric summary cards
              Container(
                color: const Color(0xFF0F4E31),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    _buildSummaryCard(
                      'Total Inquiries',
                      '${allInquiries.length}',
                      Icons.mail_outline_rounded,
                      Colors.white,
                    ),
                    const SizedBox(width: 10),
                    _buildSummaryCard(
                      'New Inquiries',
                      '${store.pendingCount}',
                      Icons.mark_email_unread_rounded,
                      const Color(0xFFFBBF24),
                    ),
                    const SizedBox(width: 10),
                    _buildSummaryCard(
                      'Quoted/Booked',
                      '${allInquiries.where((i) => i.status == InquiryStatusType.quoted || i.status == InquiryStatusType.booked).length}',
                      Icons.task_alt_rounded,
                      const Color(0xFF4ADE80),
                    ),
                  ],
                ),
              ),

              // Filter Chips
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All (${allInquiries.length})', null),
                      const SizedBox(width: 8),
                      _buildFilterChip('New', InquiryStatusType.newInquiry),
                      const SizedBox(width: 8),
                      _buildFilterChip('In Progress', InquiryStatusType.inProgress),
                      const SizedBox(width: 8),
                      _buildFilterChip('Quoted', InquiryStatusType.quoted),
                      const SizedBox(width: 8),
                      _buildFilterChip('Booked', InquiryStatusType.booked),
                      const SizedBox(width: 8),
                      _buildFilterChip('Closed', InquiryStatusType.closed),
                    ],
                  ),
                ),
              ),

              // List
              Expanded(
                child: filteredList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_rounded, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              'No inquiries found under this filter',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return _buildInquiryCard(context, item);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String count, IconData icon, Color countColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white70, size: 18),
            const SizedBox(height: 6),
            Text(
              count,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: countColor,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, InquiryStatusType? status) {
    final isSelected = _filterStatus == status;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11.5,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? Colors.white : const Color(0xFF374151),
        ),
      ),
      selected: isSelected,
      selectedColor: const Color(0xFF0F4E31),
      backgroundColor: const Color(0xFFF3F4F6),
      onSelected: (val) {
        setState(() => _filterStatus = status);
      },
    );
  }

  Widget _buildInquiryCard(BuildContext context, InquiryEntry item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.status == InquiryStatusType.newInquiry
              ? const Color(0xFFF59E0B)
              : const Color(0xFFE5E7EB),
          width: item.status == InquiryStatusType.newInquiry ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Ref & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEDF5F0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.campaign_rounded, size: 16, color: Color(0xFF0F4E31)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.inquiryRef,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F4E31),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.statusDisplay,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: item.statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 20, color: Color(0xFFF3F4F6)),

            // Visitor info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF0F4E31),
                  child: Text(
                    item.visitorName.isNotEmpty ? item.visitorName.substring(0, 1).toUpperCase() : 'V',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.visitorName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${item.email} • ${item.phone}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      if (item.placeOfOrigin.isNotEmpty) ...[
                        Text(
                          '📍 ${item.placeOfOrigin}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Interest Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bookmark_outline_rounded, size: 15, color: Color(0xFF0F4E31)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${item.interestTopic} • ${item.estimatedGuests} Guests • Date: ${item.preferredDate}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (item.sourceAdvertisement.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                '📢 Source: ${item.sourceAdvertisement}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10.5,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],

            if (item.message.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Text(
                  '“${item.message}”',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFF92400E),
                    height: 1.35,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (item.status == InquiryStatusType.newInquiry) ...[
                  OutlinedButton(
                    onPressed: () {
                      InquiryStore.instance.updateStatus(item.id, InquiryStatusType.inProgress);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Inquiry ${item.inquiryRef} marked as In Progress')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1565C0),
                      side: const BorderSide(color: Color(0xFF1565C0)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Mark In Progress', style: TextStyle(fontSize: 11.5)),
                  ),
                  const SizedBox(width: 8),
                ],
                ElevatedButton.icon(
                  onPressed: () => _showStatusUpdateModal(context, item),
                  icon: const Icon(Icons.edit_note_rounded, size: 16, color: Colors.white),
                  label: const Text('Update / Quote', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F4E31),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusUpdateModal(BuildContext context, InquiryEntry item) {
    InquiryStatusType selected = item.status;
    final noteCtrl = TextEditingController(text: item.adminResponse ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Manage Inquiry: ${item.inquiryRef}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F4E31),
                  ),
                ),
                Text(
                  'Visitor: ${item.visitorName} (${item.phone})',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 16),
                const Text('Update Status', style: TextStyle(fontFamily: 'Poppins', fontSize: 12.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: InquiryStatusType.values.map((st) {
                    final isSel = selected == st;
                    return ChoiceChip(
                      label: Text(
                        _statusName(st),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.5,
                          color: isSel ? Colors.white : const Color(0xFF374151),
                        ),
                      ),
                      selected: isSel,
                      selectedColor: const Color(0xFF0F4E31),
                      onSelected: (val) {
                        if (val) setModalState(() => selected = st);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Staff Notes / Quotation Details', style: TextStyle(fontFamily: 'Poppins', fontSize: 12.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: noteCtrl,
                  maxLines: 3,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 12.5),
                  decoration: InputDecoration(
                    hintText: 'e.g. Quoted ₱2,100 for 6 pax with complimentary tablea tasting.',
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      InquiryStore.instance.updateStatus(item.id, selected, response: noteCtrl.text.trim());
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Updated ${item.inquiryRef} status successfully!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F4E31),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Save & Update Inquiry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _statusName(InquiryStatusType status) {
    switch (status) {
      case InquiryStatusType.newInquiry:
        return 'New';
      case InquiryStatusType.inProgress:
        return 'In Progress';
      case InquiryStatusType.quoted:
        return 'Quoted';
      case InquiryStatusType.booked:
        return 'Booked';
      case InquiryStatusType.closed:
        return 'Closed';
    }
  }
}
