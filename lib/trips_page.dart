import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';

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

class TripsPage extends StatefulWidget {
  final String? prefilledDestination;
  
  const TripsPage({super.key, this.prefilledDestination});
  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  static final List<Booking> _bookings = [];
  DateTime? _lastWarnAt;

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

  void _showWarn(BuildContext context, String message) {
    final now = DateTime.now();
    if (_lastWarnAt != null &&
        now.difference(_lastWarnAt!) < Duration(milliseconds: 900))
      return;
    _lastWarnAt = now;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(16, 0, 16, 90),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

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
        backgroundColor: _bg,
        elevation: 0,
        title: Text(
          'Trips',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: _accent),
            onPressed: () => _openBookingForm(),
            tooltip: 'Create booking',
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.06,
            child: Image.asset('assets/img/page_bg.png', fit: BoxFit.cover),
          ),
          _bookings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.card_travel, size: 64, color: _secondary),
                      SizedBox(height: 16),
                      Text(
                        'No bookings yet. Tap + to create one.',
                        style: TextStyle(color: _secondary, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    final b = _bookings[index];
                    final dates = (b.startDate != null && b.endDate != null)
                        ? '${_fmt(b.startDate!)} → ${_fmt(b.endDate!)}'
                        : 'Dates not set';
                    return Container(
                      margin: EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _accent.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text(
                          b.packageName.isEmpty
                              ? 'Package not set'
                              : b.packageName,
                          style: TextStyle(
                            color: _primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Text(
                            '$dates\n${b.participants.length} traveler(s) • ${b.paymentMethod} • ${b.perPersonPrice} PHP / person',
                            style: TextStyle(color: _secondary, height: 1.2),
                          ),
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: _accent),
                              onPressed: () =>
                                  _openBookingForm(editIndex: index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _confirmDelete(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _accent,
        onPressed: () => _openBookingForm(),
        child: Icon(Icons.add, color: _bg),
      ),
    );
  }

  Future<void> _openBookingForm({int? editIndex}) async {
    final isEditing = editIndex != null;
    final isFromHomePage = widget.prefilledDestination != null && !isEditing;
    
    if (!isEditing && !isFromHomePage) {
      final proceed = await _showBookingConfirmationDialog();
      if (!proceed) return;
    }
    final Booking working = isEditing ? _bookings[editIndex].copy() : Booking();
    
    // Pre-fill destination if provided
    if (widget.prefilledDestination != null && !isEditing) {
      working.packageName = widget.prefilledDestination!;
      working.perPersonPrice = destinationPrices[widget.prefilledDestination!] ?? 1000;
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
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to start a new booking? You have 10 minutes to complete your booking or it will expire.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel', style: TextStyle(color: Colors.white70)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Proceed', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  static bool _isBookingComplete(Booking b) {
    if (b.packageName.trim().isEmpty) return false;
    if (b.startDate == null || b.endDate == null) return false;
    if (b.contactInfo.trim().isEmpty) return false;
    if (b.participants.isEmpty) return false;
    for (final p in b.participants) {
      if (p.firstName.trim().isEmpty || p.lastName.trim().isEmpty) return false;
    }
    if (b.paymentMethod.trim().isEmpty) return false;
    return true;
  }

  Future<void> _confirmDelete(int index) async {
    final ok =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Cancel Booking?'),
            content: Text('This will delete the booking.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
    if (ok) setState(() => _bookings.removeAt(index));
  }

  static String _fmt(DateTime d) => '${d.month}/${d.day}/${d.year}';
}

class _BookingPage extends StatefulWidget {
  final Booking booking;
  final bool isEditing;
  final int? editIndex;
  final Function(Booking) onSave;

  const _BookingPage({
    super.key,
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
    _sessionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => _timeRemaining--);
      if (_timeRemaining <= 0) {
        _sessionTimer?.cancel();
        _showSessionExpiredDialog();
      }
    });
  }

  void _showSessionExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: _TripsPageState._card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Session Expired',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Your booking session has expired. Please start a new booking session.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _TripsPageState._accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void updateBooking() => setState(() {});

  void _showWarn(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(16, 0, 16, 90),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _TripsPageState._bg,
      appBar: AppBar(
        backgroundColor: _TripsPageState._bg,
        elevation: 0,
        title: Row(
          children: [
            Text('Confirm your Booking', style: TextStyle(color: Colors.white)),
            if (!widget.isEditing) ...[
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _timeRemaining <= 30
                      ? Colors.red
                      : _TripsPageState._accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatTime(_timeRemaining),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _sessionTimer?.cancel();
            // Go back to main tabs (home page)
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.06,
            child: Image.asset('assets/img/page_bg.png', fit: BoxFit.cover),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: _BookingForm(
                    booking: b,
                    onUpdate: updateBooking,
                    onSubmit: () async {
                      if (!_TripsPageState._isBookingComplete(b)) {
                        _showWarn('Please fill out all information.');
                        return;
                      }
                      final confirmed = await _showConfirmDialog(b);
                      if (confirmed) {
                        _sessionTimer?.cancel();
                        widget.onSave(b);
                      }
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                decoration: BoxDecoration(
                  color: Color(0xFF121540),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 12,
                      offset: Offset(0, -4),
                    ),
                  ],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
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
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${b.participants.length * b.perPersonPrice} PHP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${b.perPersonPrice} PHP / person',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_TripsPageState._isBookingComplete(b)) {
                          _showWarn('Please fill out all information.');
                          return;
                        }
                        final confirmed = await _showConfirmDialog(b);
                        if (confirmed) {
                          _sessionTimer?.cancel();
                          widget.onSave(b);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 12,
                        ),
                      ),
                      child: Text('SUBMIT'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _sessionTimer?.cancel();
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB54857),
                        foregroundColor: Colors.white,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                      ),
                      child: Text('CANCEL'),
                    ),
                  ],
                ),
              ),
            ],
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
              title: Text('Confirm Your Booking'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trip Details: ${b.packageName.isEmpty ? 'Not specified' : b.packageName}',
                    ),
                    Text(
                      'Travel Dates: ${b.startDate != null ? _TripsPageState._fmt(b.startDate!) : 'N/A'} – ${b.endDate != null ? _TripsPageState._fmt(b.endDate!) : 'N/A'}',
                    ),
                    Text(
                      'Price per person: ${b.perPersonPrice} PHP',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Total Price: $total PHP',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Timer / Constraint Message',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Please complete your confirmation and payment within 10 minutes to lock in this rate.',
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Agreement Section',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'By booking, you consent to the travel agency collecting, using, and sharing your contact and personal information with airlines, hotels, and service partners solely for reservation and communication. We protect data in full compliance with the Philippine Data Privacy Act of 2012 (RA 10173).',
                    ),
                    Row(
                      children: [
                        StatefulBuilder(
                          builder: (context, setSB) {
                            return Checkbox(
                              value: agreed,
                              activeColor: _TripsPageState._accent,
                              onChanged: (v) =>
                                  setSB(() => agreed = v ?? false),
                            );
                          },
                        ),
                        Expanded(
                          child: Text(
                            'I agree to the Terms & Conditions and authorize payment of the total amount for this booking.',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!agreed) {
                      Navigator.of(context).pop(false);
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
                    style: TextStyle(color: _TripsPageState._bg),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

class _BookingForm extends StatefulWidget {
  final Booking booking;
  final VoidCallback onSubmit;
  final VoidCallback onUpdate;

  const _BookingForm({
    super.key,
    required this.booking,
    required this.onSubmit,
    required this.onUpdate,
  });

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

  InputDecoration _pillDecoration(
    String hint, {
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _TripsPageState._accent.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _TripsPageState._accent.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: _TripsPageState._accent),
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
            style: TextStyle(
              color: _TripsPageState._bg,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 10),
        Icon(icon, color: _TripsPageState._accent, size: 18),
        SizedBox(width: 6),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: _TripsPageState._primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  void _setPackageAndPrice(String value) {
    b.packageName = value;
    b.perPersonPrice = _TripsPageState.destinationPrices[value] ?? 1000;
    setState(() {});
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
                  if (textEditingValue.text.isEmpty)
                    return const Iterable<String>.empty();
                  final query = textEditingValue.text.toLowerCase();
                  return _TripsPageState.destinationPrices.keys.where(
                    (name) => name.toLowerCase().contains(query),
                  );
                },
                onSelected: (val) => _setPackageAndPrice(val),
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      if (controller.text != b.packageName)
                        controller.text = b.packageName;
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: _pillDecoration(
                          'Package / Destination Name',
                        ),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        onChanged: (v) => _setPackageAndPrice(v),
                      );
                    },
              ),
              SizedBox(height: 8),
              Text(
                'Price per person: ${b.perPersonPrice} PHP',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        _SectionCard(
          header: _stepLabel(
            2,
            'Booking Date/s',
            Icons.calendar_month_outlined,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: true,
                  onTap: () => _pickDate(isStart: true),
                  decoration: _pillDecoration(
                    'Start Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: b.startDate != null
                        ? _TripsPageState._fmt(b.startDate!)
                        : '',
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  readOnly: true,
                  onTap: () => _pickDate(isStart: false),
                  decoration: _pillDecoration(
                    'End Date',
                    suffixIcon: Icon(Icons.calendar_today),
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
          header: _stepLabel(3, 'Number of Participants', Icons.people_outline),
          child: Row(
            children: [
              _circleIconButton(
                Icons.remove,
                onPressed: () {
                  if (b.participants.length > 1) {
                    b.participants.removeLast();
                    setState(() {});
                    widget.onUpdate();
                  }
                },
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: _TripsPageState._accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${b.participants.length}',
                  style: TextStyle(
                    color: _TripsPageState._bg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              _circleIconButton(
                Icons.add,
                onPressed: () {
                  b.participants.add(Participant());
                  setState(() {});
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
            children: [
              ...List.generate(
                b.participants.length,
                (i) => _buildParticipant(
                  i,
                  isLast: i == b.participants.length - 1,
                ),
              ),
            ],
          ),
        ),
        _SectionCard(
          header: _stepLabel(5, 'Contact Information', Icons.phone_outlined),
          child: TextFormField(
            initialValue: b.contactInfo,
            keyboardType: TextInputType.phone,
            decoration: _pillDecoration(
              '+63XXX-XXX-XXXX',
              suffixIcon: Icon(Icons.phone),
            ),
            onChanged: (v) => b.contactInfo = v,
          ),
        ),
        _SectionCard(
          header: _stepLabel(6, 'Payment Method', Icons.payment_outlined),
          child: DropdownButtonFormField<String>(
            value: b.paymentMethod,
            decoration: _pillDecoration('Cash'),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            items: [
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

  Widget _circleIconButton(IconData icon, {required VoidCallback onPressed}) {
    return Ink(
      decoration: ShapeDecoration(
        color: _TripsPageState._accent.withOpacity(0.2),
        shape: CircleBorder(),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: _TripsPageState._accent),
      ),
    );
  }

  Widget _buildParticipant(int index, {required bool isLast}) {
    final p = b.participants[index];
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
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
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: p.lastName,
                  decoration: _pillDecoration('Last Name'),
                  onChanged: (v) => p.lastName = v,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 90),
                child: _AgePicker(value: p.age, onChanged: (v) => p.age = v),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: DropdownButtonFormField<String>(
                    value: p.gender,
                    style: TextStyle(fontSize: 13, color: Colors.black),
                    decoration: _pillDecoration('Gender').copyWith(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      isDense: true,
                    ),
                    items: [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (v) => p.gender = v ?? 'Male',
                  ),
                ),
              ),
            ],
          ),
          if (!isLast) ...[
            SizedBox(height: 10),
            Divider(height: 1, color: _TripsPageState._accent.withOpacity(0.3)),
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
}

class _AgePicker extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _AgePicker({super.key, required this.value, required this.onChanged});
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
  void didUpdateWidget(_AgePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _TripsPageState._accent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: NumberPicker(
        value: _currentValue,
        minValue: 1,
        maxValue: 100,
        axis: Axis.vertical,
        itemHeight: 18,
        itemWidth: 50,
        onChanged: (value) {
          setState(() => _currentValue = value);
          widget.onChanged(value);
        },
        textStyle: TextStyle(color: Colors.black54, fontSize: 12),
        selectedTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget header;
  final Widget child;
  const _SectionCard({super.key, required this.header, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _TripsPageState._card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, SizedBox(height: 10), child],
      ),
    );
  }
}
