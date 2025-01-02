import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/actions/custom_action_button.dart';
import 'package:envirosense/presentation/widgets/dialogs/custom_bottom_sheet_actions.dart';
import 'package:envirosense/presentation/widgets/dialogs/custom_bottom_sheet_header.dart';
import 'package:envirosense/presentation/widgets/core/custom_confirmation_dialog.dart';
import 'package:envirosense/presentation/widgets/core/custom_text_form_field.dart';
import 'package:envirosense/services/room_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoomActionsTab extends StatefulWidget {
  String roomName;
  final String roomId;
  final RoomService roomService;
  final Function(String) onRoomRenamed;
  final Function() onRoomRemoved;

  RoomActionsTab({
    super.key,
    required this.roomName,
    required this.roomId,
    required this.roomService,
    required this.onRoomRenamed,
    required this.onRoomRemoved,
  });

  @override
  State<RoomActionsTab> createState() => _RoomActionsTabState();
}

class _RoomActionsTabState extends State<RoomActionsTab> {
  String? _error;

  Future<void> _showRenameRoomDialog(BuildContext context) async {
    final TextEditingController inputController =
        TextEditingController(text: widget.roomName);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomBottomSheetHeader(title: 'Rename Room'),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomTextFormField(
                controller: inputController,
                labelText: 'Room Name',
                floatingLabelCustomStyle: const TextStyle(
                  color: AppColors.secondaryColor,
                ),
                textStyle: const TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            Divider(color: AppColors.accentColor.withOpacity(0.2)),
            CustomBottomSheetActions(
              onCancel: () => Navigator.pop(context),
              onSave: () async {
                if (inputController.text.isNotEmpty) {
                  await _handleRoomRename(inputController.text);
                }
              },
              saveButtonText: 'Save',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showRemoveRoomDialog(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomConfirmationDialog(
        title: 'Remove Room',
        message: 'Are you sure you want to remove ',
        highlightedText: widget.roomName,
        onConfirm: () async {
          await _handleRoomRemoval();
        },
      ),
    );
  }

  Future<void> _handleRoomRename(String newRoomName) async {
    try {
      if (widget.roomId.isEmpty) {
        throw Exception('Room id not found');
      }

      await widget.roomService.renameRoom(widget.roomId, newRoomName);
      widget.onRoomRenamed(newRoomName);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Room renamed successfully'),
          backgroundColor: AppColors.secondaryColor,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = e.toString());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to rename room: $_error'),
          backgroundColor: AppColors.secondaryColor,
        ),
      );
    }
  }

  Future<void> _handleRoomRemoval() async {
    try {
      await widget.roomService.deleteRoom(widget.roomId);

      Navigator.pop(context);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Room removed successfully'),
            backgroundColor: AppColors.secondaryColor),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to remove room: $_error'),
            backgroundColor: AppColors.secondaryColor),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomActionButton(
                icon: Icons.edit,
                label: 'Rename Room',
                onPressed: () => _showRenameRoomDialog(context),
                color: AppColors.accentColor,
                isNeutral: true,
              ),
              const SizedBox(height: 16),
              CustomActionButton(
                icon: Icons.delete_outline,
                label: 'Remove Room',
                onPressed: () => _showRemoveRoomDialog(context),
                color: AppColors.redColor,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
