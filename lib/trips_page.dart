import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';

// --- DATA MODELS ---

class Participant {
  String firstName;
  String lastName;
  int age;
  String gender;

  Participant({
    this.firstName = '',
    this.lastName = '',
    this.age = 18,
    this.gender = 'Male',
  });
}

class Booking {
  String packageName;
  DateTime? startDate;
  DateTime? endDate;
  List<Participant> participants;
  String contactInfo;
  String paymentMethod;
  int perPersonPrice;
  DateTime? confirmedAt;

  Booking({
    this.packageName = '',
    this.startDate,
    this.endDate,
    List<Participant>? participants,
    this.contactInfo = '',
    this.paymentMethod = 'Cash',
    this.perPersonPrice = 1000,
    this.confirmedAt,
  }) : participants = participants ?? [Participant()];

  Booking copy() => Booking(
    packageName: packageName,
    startDate: startDate,
    endDate: endDate,
    participants: participants
        .map(
          (p) => Participant(
            firstName: p.firstName,
            lastName: p.lastName,
            age: p.age,
            gender: p.gender,
          ),
        )
        .toList(),
    contactInfo: contactInfo,
    paymentMethod: paymentMethod,
    perPersonPrice: perPersonPrice,
    confirmedAt: confirmedAt,
  );
}

// --- MAIN TRIPS PAGE WIDGET ---

class TripsPage extends StatefulWidget {
  final String? prefilledDestination;

  const TripsPage({super.key, this.prefilledDestination});
  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  static final List<Booking> _bookings = [];
  DateTime? _lastWarnAt;

  // --- UI COLORS & STYLES ---
  static const Color _bg = Color(0xFF19183B);
  static const Color _secondary = Color(0xFF708993);
  static const Color _accent = Color(0xFFA1C2BD);
  static const Color _primary = Color(0xFFE7F2EF);
  static const Color _card = Color(0xFF23224B);

  static const Map<String, int> destinationPrices = {
    'Great Wall Explorer': 1500,
    'Machu Picchu Expedition': 2200,
    'Petra Lost City Tour': 1700,
    'Colosseum & Ancient Rome': 1600,
    'Chichen Itza Wonders': 1400,
    'Christ the Redeemer & Rio Vibes': 1850,
    'Taj Mahal Romance': 1500,
    'Stonehenge Mysteries': 1300,
    'Northern Lights Hunt': 2100,
    'Pyramids of Giza Discovery': 1750,
  };

  @override
  void initState() {
    super.initState();
    // Auto-open booking form if destination is pre-filled
    if (widget.prefilledDestination != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openBookingForm();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _bg,
        elevation: 0,
        title: Text(
          'Your Bookings',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.06,
            child: Image.asset('assets/img/page_bg.png', fit: BoxFit.cover),
          ),
          _bookings.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    return _buildBookingCard(_bookings[index], index);
                  },
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _accent,
        onPressed: () => _openBookingForm(),
        tooltip: 'Create new booking',
        child: const Icon(Icons.add, color: _bg, size: 28),
      ),
    );
  }

  // --- UI BUILDER WIDGETS ---

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.luggage_outlined, size: 80, color: _secondary),
          const SizedBox(height: 20),
          Text(
            'Your Adventures Await!',
            style: GoogleFonts.poppins(
              color: _primary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the \'+\' button to book your next journey.',
            style: GoogleFonts.poppins(color: _secondary, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking b, int index) {
    final dates = (b.startDate != null && b.endDate != null)
        ? '${_fmt(b.startDate!)} → ${_fmt(b.endDate!)}'
        : 'Dates not set';
    final total = b.perPersonPrice * b.participants.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    b.packageName.isEmpty ? 'Package Not Set' : b.packageName,
                    style: GoogleFonts.poppins(
                      color: _primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    _circleButton(
                      Icons.edit,
                      _accent,
                      () => _openBookingForm(editIndex: index),
                    ),
                    const SizedBox(width: 8),
                    _circleButton(
                      Icons.delete,
                      Colors.redAccent,
                      () => _confirmDelete(index),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(color: _secondary, height: 24),
            _infoRow(Icons.calendar_today, dates),
            const SizedBox(height: 8),
            _infoRow(Icons.people, '${b.participants.length} Traveler(s)'),
            const SizedBox(height: 8),
            _infoRow(
              Icons.payment,
              '${b.paymentMethod} • PHP ${b.perPersonPrice} / person',
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: PHP $total',
                style: GoogleFonts.poppins(
                  color: _primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: _secondary, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(color: _secondary, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _circleButton(IconData icon, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.15),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  // --- LOGIC & NAVIGATION ---

  Future<void> _openBookingForm({int? editIndex}) async {
    final isEditing = editIndex != null;
    final isFromHomePage = widget.prefilledDestination != null && !isEditing;

    if (!isEditing && !isFromHomePage) {
      final proceed = await _showBookingConfirmationDialog();
      if (!proceed) return;
    }

    final Booking working = isEditing
        ? _bookings[editIndex!].copy()
        : Booking();

    if (widget.prefilledDestination != null && !isEditing) {
      working.packageName = widget.prefilledDestination!;
      working.perPersonPrice =
          destinationPrices[widget.prefilledDestination!] ?? 1000;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _BookingPage(
          booking: working,
          isEditing: isEditing,
          editIndex: editIndex,
          onSave: (savedBooking) {
            setState(() {
              if (isEditing) {
                _bookings[editIndex] = savedBooking
                  ..confirmedAt = DateTime.now();
              } else {
                savedBooking.confirmedAt = DateTime.now();
                _bookings.add(savedBooking);
              }
            });
            Navigator.pop(context); // Close the booking form
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment Successful / Booking Confirmed'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _showBookingConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: _card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Start Booking Session',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'You have 10 minutes to complete your booking or it will expire.',
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Proceed',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _confirmDelete(int index) async {
    final ok =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: _card,
            title: Text(
              'Cancel Booking?',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            content: Text(
              'This will permanently delete the booking.',
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'No',
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: Text(
                  'Yes, Cancel',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
    if (ok) setState(() => _bookings.removeAt(index));
  }

  static String _fmt(DateTime d) => '${d.month}/${d.day}/${d.year}';
}

// --- BOOKING FORM PAGE WIDGET ---
// (This remains a separate page for clarity)

class _BookingPage extends StatefulWidget {
  final Booking booking;
  final bool isEditing;
  final int? editIndex;
  final Function(Booking) onSave;

  const _BookingPage({
    required this.booking,
    required this.isEditing,
    this.editIndex,
    required this.onSave,
  });

  @override
  State<_BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<_BookingPage> {
  late Booking b;
  Timer? _sessionTimer;
  int _timeRemaining = 600;

  @override
  void initState() {
    super.initState();
    b = widget.booking;
    if (!widget.isEditing) _startSessionTimer();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _timeRemaining--);
        if (_timeRemaining <= 0) {
          _sessionTimer?.cancel();
          _showSessionExpiredDialog();
        }
      } else {
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void updateBooking() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _TripsPageState._bg,
      appBar: AppBar(
        backgroundColor: _TripsPageState._bg,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Confirm your Booking',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            if (!widget.isEditing) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _timeRemaining <= 30
                      ? Colors.red
                      : _TripsPageState._accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatTime(_timeRemaining),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            _sessionTimer?.cancel();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _BookingForm(booking: b, onUpdate: updateBooking),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: _TripsPageState._card,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TOTAL',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'PHP ${b.participants.length * b.perPersonPrice}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'PHP ${b.perPersonPrice} / person',
                  style: GoogleFonts.poppins(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!_isBookingComplete(b)) {
                _showWarn('Please fill out all required fields.');
                return;
              }
              final confirmed = await _showConfirmDialog(b);
              if (confirmed && mounted) {
                _sessionTimer?.cancel();
                widget.onSave(b);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: Text(
              'SUBMIT',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // --- DIALOGS AND VALIDATION ---

  void _showWarn(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 90),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSessionExpiredDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: _TripsPageState._card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Session Expired',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Your booking session has expired. Please start over.',
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close booking page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _TripsPageState._accent,
            ),
            child: Text('OK', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmDialog(Booking b) async {
    bool agreed = false;
    final total = b.participants.length * b.perPersonPrice;
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: _TripsPageState._card,
              title: Text(
                'Confirm Your Booking',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      'Package: ${b.packageName}',
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),
                    Text(
                      'Dates: ${_TripsPageState._fmt(b.startDate!)} – ${_TripsPageState._fmt(b.endDate!)}',
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Total Price: PHP $total',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Divider(height: 24),
                    Text(
                      'By booking, you consent to your information being used for reservation purposes, in compliance with the Data Privacy Act of 2012 (RA 10173).',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    StatefulBuilder(
                      builder: (context, setSB) {
                        return CheckboxListTile(
                          title: const Text(
                            'I agree to the Terms & Conditions',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          value: agreed,
                          onChanged: (v) => setSB(() => agreed = v ?? false),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: _TripsPageState._accent,
                          checkColor: _TripsPageState._bg,
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!agreed) {
                      _showWarn('Please agree to the terms to continue.');
                    } else {
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _TripsPageState._accent,
                  ),
                  child: Text(
                    'Confirm & Pay',
                    style: GoogleFonts.poppins(color: _TripsPageState._bg),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  bool _isBookingComplete(Booking b) {
    if (b.packageName.trim().isEmpty) return false;
    if (b.startDate == null || b.endDate == null) return false;
    if (b.contactInfo.trim().isEmpty) return false;
    if (b.participants.isEmpty) return false;
    for (final p in b.participants) {
      if (p.firstName.trim().isEmpty || p.lastName.trim().isEmpty) return false;
    }
    return true;
  }
}

// --- REUSABLE FORM WIDGET ---

class _BookingForm extends StatefulWidget {
  final Booking booking;
  final VoidCallback onUpdate;

  const _BookingForm({required this.booking, required this.onUpdate});

  @override
  State<_BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<_BookingForm> {
  late Booking b;

  @override
  void initState() {
    super.initState();
    b = widget.booking;
  }

  void _setPackageAndPrice(String value) {
    setState(() {
      b.packageName = value;
      b.perPersonPrice = _TripsPageState.destinationPrices[value] ?? 1000;
    });
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionCard(
          header: _stepLabel(1, 'Trip Details', Icons.map_outlined),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  final query = textEditingValue.text.toLowerCase();
                  return _TripsPageState.destinationPrices.keys.where(
                    (name) => name.toLowerCase().contains(query),
                  );
                },
                onSelected: (val) => _setPackageAndPrice(val),
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      if (controller.text != b.packageName) {
                        controller.text = b.packageName;
                      }
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: _pillDecoration(
                          'Package / Destination Name',
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        onChanged: (v) => _setPackageAndPrice(v),
                      );
                    },
              ),
              const SizedBox(height: 8),
              Text(
                'Price per person: PHP ${b.perPersonPrice}',
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
            ],
          ),
        ),
        _SectionCard(
          header: _stepLabel(2, 'Booking Dates', Icons.calendar_month_outlined),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  onTap: () => _pickDate(isStart: true),
                  decoration: _pillDecoration(
                    'Start Date',
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: b.startDate != null
                        ? _TripsPageState._fmt(b.startDate!)
                        : '',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  onTap: () => _pickDate(isStart: false),
                  decoration: _pillDecoration(
                    'End Date',
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: b.endDate != null
                        ? _TripsPageState._fmt(b.endDate!)
                        : '',
                  ),
                ),
              ),
            ],
          ),
        ),
        _SectionCard(
          header: _stepLabel(3, 'Participants', Icons.people_outline),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circleIconButton(
                Icons.remove,
                onPressed: () {
                  if (b.participants.length > 1) {
                    setState(() => b.participants.removeLast());
                    widget.onUpdate();
                  }
                },
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _TripsPageState._accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${b.participants.length}',
                  style: GoogleFonts.poppins(
                    color: _TripsPageState._bg,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _circleIconButton(
                Icons.add,
                onPressed: () {
                  setState(() => b.participants.add(Participant()));
                  widget.onUpdate();
                },
              ),
            ],
          ),
        ),
        _SectionCard(
          header: _stepLabel(
            4,
            'Participant Information',
            Icons.badge_outlined,
          ),
          child: Column(
            children: List.generate(
              b.participants.length,
              (i) =>
                  _buildParticipant(i, isLast: i == b.participants.length - 1),
            ),
          ),
        ),
        _SectionCard(
          header: _stepLabel(5, 'Contact Information', Icons.phone_outlined),
          child: TextFormField(
            initialValue: b.contactInfo,
            keyboardType: TextInputType.phone,
            decoration: _pillDecoration('+63 9XX-XXX-XXXX'),
            onChanged: (v) => b.contactInfo = v,
          ),
        ),
        _SectionCard(
          header: _stepLabel(6, 'Payment Method', Icons.payment_outlined),
          child: DropdownButtonFormField<String>(
            value: b.paymentMethod,
            decoration: _pillDecoration('Cash'),
            dropdownColor: Colors.white,
            items: const [
              DropdownMenuItem(value: 'Cash', child: Text('CASH')),
              DropdownMenuItem(value: 'Card', child: Text('CARD')),
              DropdownMenuItem(value: 'E-Wallet', child: Text('E-WALLET')),
            ],
            onChanged: (v) => b.paymentMethod = v ?? 'Cash',
          ),
        ),
      ],
    );
  }

  Widget _buildParticipant(int index, {required bool isLast}) {
    final p = b.participants[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: p.firstName,
                  decoration: _pillDecoration('First Name'),
                  onChanged: (v) => p.firstName = v,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: p.lastName,
                  decoration: _pillDecoration('Last Name'),
                  onChanged: (v) => p.lastName = v,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: _AgePicker(value: p.age, onChanged: (v) => p.age = v),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: p.gender,
                  decoration: _pillDecoration('Gender'),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (v) => p.gender = v ?? 'Male',
                ),
              ),
            ],
          ),
          if (!isLast) ...[
            const SizedBox(height: 12),
            Divider(height: 1, color: _TripsPageState._accent.withOpacity(0.3)),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart ? (b.startDate ?? now) : (b.endDate ?? now);
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 3),
      initialDate: initial,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          b.startDate = picked;
        } else {
          b.endDate = picked;
        }
      });
      widget.onUpdate();
    }
  }

  // --- REUSABLE UI HELPERS FOR THE FORM ---

  Widget _circleIconButton(IconData icon, {required VoidCallback onPressed}) {
    return Ink(
      decoration: ShapeDecoration(
        color: _TripsPageState._accent.withOpacity(0.2),
        shape: const CircleBorder(),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: _TripsPageState._accent),
        splashRadius: 24,
      ),
    );
  }

  InputDecoration _pillDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _stepLabel(int number, String title, IconData icon) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: _TripsPageState._accent,
          child: Text(
            '$number',
            style: GoogleFonts.poppins(
              color: _TripsPageState._bg,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Icon(icon, color: _TripsPageState._accent, size: 20),
        const SizedBox(width: 6),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.poppins(
            color: _TripsPageState._primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// --- CUSTOM AGE PICKER WIDGET ---

class _AgePicker extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _AgePicker({required this.value, required this.onChanged});

  @override
  State<_AgePicker> createState() => _AgePickerState();
}

class _AgePickerState extends State<_AgePicker> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return NumberPicker(
      value: _currentValue,
      minValue: 1,
      maxValue: 100,
      axis: Axis.horizontal,
      itemWidth: 35,
      haptics: true,
      onChanged: (value) {
        setState(() => _currentValue = value);
        widget.onChanged(value);
      },
      textStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
      selectedTextStyle: GoogleFonts.poppins(
        color: _TripsPageState._accent,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

// --- REUSABLE SECTION CARD WIDGET ---

class _SectionCard extends StatelessWidget {
  final Widget header;
  final Widget child;
  const _SectionCard({required this.header, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _TripsPageState._card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, const SizedBox(height: 12), child],
      ),
    );
  }
}
