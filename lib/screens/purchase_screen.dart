import 'package:flutter/material.dart';

import '../models.dart';
import '../services/firestore_service.dart';
import '../utils.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key, required this.event});
  final EventItem event;

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _qty = TextEditingController(text: '1');
  bool _saving = false;

  int get _quantity => int.tryParse(_qty.text.trim()) ?? 0;
  int get _max => widget.event.available < 10 ? widget.event.available : 10;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _qty.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await FirestoreService.instance.buyTickets(
        event: widget.event,
        buyerName: _name.text.trim(),
        email: _email.text.trim(),
        quantity: _quantity,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Compra registrada')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo completar la compra: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    return Scaffold(
      appBar: AppBar(title: const Text('Comprar boletos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(e.name, style: Theme.of(context).textTheme.titleLarge),
          Text('${e.venue} · ${fmtDate.format(e.date)}'),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Nombre completo'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Correo electrónico'),
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return 'Campo obligatorio';
                    return isValidEmail(t) ? null : 'Correo no válido';
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _qty,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad de boletos (máx. $_max)',
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    final n = int.tryParse(v?.trim() ?? '');
                    if (n == null) return 'Ingresa un número entero';
                    if (n < 1 || n > _max) return 'Debe estar entre 1 y $_max';
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Total: ${fmtMoney.format(e.price * _quantity)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _saving ? null : _submit,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: const Text('Confirmar compra'),
          ),
        ],
      ),
    );
  }
}
