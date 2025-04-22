import 'package:bolshek_pro/app/widgets/%20order_status_widget.dart';
import 'package:bolshek_pro/app/widgets/custom_alert_dialog_widget.dart';
import 'package:bolshek_pro/core/models/return_deital_response.dart';
import 'package:bolshek_pro/core/service/returnings_service.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReturnDetailPage extends StatefulWidget {
  final String orderId;

  const ReturnDetailPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<ReturnDetailPage> createState() => _ReturnDetailPageState();
}

class _ReturnDetailPageState extends State<ReturnDetailPage> {
  final ReturningsService _returningsService = ReturningsService();

  ReturnDetailRespnse? _order;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchReturnDetails();
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat("#,###.##", "ru_RU");
    return formatter.format(price).replaceAll(',', ' ');
  }

  String _formatDate(String isoDate) {
    try {
      final parsedDate = DateTime.parse(isoDate);
      final formatter = DateFormat('dd.MM.yyyy HH:mm');
      return formatter.format(parsedDate);
    } catch (e) {
      return S.of(context).error;
    }
  }

  Future<void> _fetchReturnDetails() async {
    try {
      final fetchReturns = await _returningsService.fetchSelectReturn(
        context: context,
        id: widget.orderId,
      );

      setState(() {
        _order = fetchReturns;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    if (isLoading) {
      return Scaffold(
        backgroundColor: ThemeColors.white,
        appBar: AppBar(title: Text('${s.order_prefix}')),
        body: const Center(
          child: CircularProgressIndicator(color: ThemeColors.grey4),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text('${s.order_prefix} ${widget.orderId}')),
        body: Center(child: Text('${s.error}: $errorMessage')),
      );
    }

    if (_order == null) {
      return Scaffold(
        appBar: AppBar(title: Text('${s.order_prefix} ${widget.orderId}')),
        body: Center(child: Text(s.no_order_data)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${s.order_prefix} ${_order!.reason}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            s.return_composition,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _buildOrderLineItem(_order!),
          ),
          const Divider(height: 32),
          Text(
            s.return_details,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            s.total_amount,
            '${_formatPrice((_order!.orderItem.price?.amount ?? 0) / 100)} ₸',
          ),
          _buildDetailRow(
            s.date,
            _order!.createdAt != null
                ? _formatDate(_order!.createdAt!.toIso8601String())
                : '—',
          ),
          _buildDetailRow(
            s.comment,
            _order!.comment ?? '—',
          ),
          _buildDetailRow(
            s.reason,
            _mapReason(_order!.reason),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _mapReason(String? reason) {
    final s = S.of(context);
    switch (reason) {
      case 'bad_quality':
        return s.reason_bad_quality;
      case 'damaged':
        return s.reason_damaged;
      case 'incomplete_set':
        return s.reason_incomplete_set;
      default:
        return s.reason_unknown;
    }
  }

  Future<void> _cancelItem(ReturnDetailRespnse item) async {
    final s = S.of(context);
    TextEditingController commentController = TextEditingController();

    if (!mounted) return;

    bool? confirmCancel = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            s.confirm_action,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.are_you_sure_cancel_return),
              const SizedBox(height: 15),
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: s.reason,
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child:
                  Text(s.cancel, style: TextStyle(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              onPressed: () {
                if (commentController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(s.reason)),
                  );
                } else {
                  Navigator.pop(context, true);
                }
              },
              child:
                  Text(s.confirm_cancel, style: const TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );

    if (confirmCancel != true) return;

    setState(() {
      isLoading = true;
    });

    try {
      if (item.id == null) throw Exception(s.product_id_cannot_be_null);

      final response = await _returningsService.cancelGoodReturns(
        context: context,
        id: _order?.id ?? '',
        comment: commentController.text.trim(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await _fetchReturnDetails();
      } else {
        throw Exception('${s.error_canceling_return}: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${s.error_canceling_return}: $e')),
      );
    }
  }

  Future<void> _acceptReturn() async {
    final s = S.of(context);
    if (!mounted) return;

    await showCustomAlertDialog(
      context: context,
      title: s.confirm_return,
      content: Text(s.are_you_sure_accept_return),
      confirmText: s.accept_return,
      cancelText: s.cancel,
      onConfirm: () async {
        Navigator.pop(context);
        setState(() => isLoading = true);

        try {
          await _returningsService.changeStatusReturn(
            context: context,
            id: widget.orderId,
            status: Constants.awaitingPickReturn,
          );
          await _fetchReturnDetails();
        } catch (e) {
          setState(() {
            errorMessage = e.toString();
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${s.error_accepting_return}: $errorMessage')),
          );
        }
      },
      onCancel: () => Navigator.pop(context),
    );
  }

  Future<void> _acceptGood() async {
    final s = S.of(context);
    if (!mounted) return;

    await showCustomAlertDialog(
      context: context,
      title: s.confirm_product_received,
      content: Text(s.are_you_sure_accept_product),
      confirmText: s.accept,
      cancelText: s.cancel,
      onConfirm: () async {
        Navigator.pop(context);
        setState(() => isLoading = true);

        try {
          await _returningsService.changeStatusReturn(
            context: context,
            id: widget.orderId,
            status: Constants.awaitingRefund,
          );
          await _fetchReturnDetails();
        } catch (e) {
          setState(() {
            errorMessage = e.toString();
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${s.error_accepting_return}: $errorMessage')),
          );
        }
      },
      onCancel: () => Navigator.pop(context),
    );
  }

  Widget _buildOrderLineItem(ReturnDetailRespnse item) {
    final s = S.of(context);
    final imageUrl = item.orderItem.product?.images?.isNotEmpty == true
        ? item.orderItem.product?.images?.first.url
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 80,
            minHeight: 80,
            maxWidth: 80,
            maxHeight: 80,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl?.isEmpty ?? true
                ? Image.asset('assets/icons/error_image.png', fit: BoxFit.cover)
                : Image.network(
                    imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/icons/error_image.png',
                          fit: BoxFit.cover);
                    },
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.orderItem.product?.name ?? 'Без названия',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('${s.comment}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  OrderStatusWidget(status: item.status ?? ''),
                ],
              ),
              if (item.status == 'rejected' && item.sellerRejectComment != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '${s.comment}: ${item.sellerRejectComment}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                '${s.total_amount}: ${_formatPrice((item.orderItem.price?.amount ?? 0) / 100)} ₸',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (item.status == Constants.awaitingConfirmation ||
                  item.status == Constants.createdReturn)
                OutlinedButton(
                  onPressed: () => _acceptReturn(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -2),
                  ),
                  child: Text(
                    s.accept_return,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              if (item.status == Constants.awaitingPickReturn)
                OutlinedButton(
                  onPressed: () => _acceptGood(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -2),
                  ),
                  child: Text(
                    s.accept,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              if (item.status == Constants.createdReturn ||
                  item.status == Constants.awaitingConfirmation)
                OutlinedButton(
                  onPressed: () => _cancelItem(item),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -2),
                  ),
                  child: Text(
                    s.confirm_cancel,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
