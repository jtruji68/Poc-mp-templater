import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/form_cubit.dart';
import '../cubits/pdf_cubit.dart';
import '../models/contract_form_state.dart';
import '../utils/web_download.dart'; // Your working downloadFile method

class FormPage extends StatelessWidget {
  const FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FormCubit()),
        BlocProvider(create: (_) => PdfCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('PoC Contratos/Tutelas/Documentos')),
        body: BlocListener<PdfCubit, PdfState>(
          listener: (context, state) {
            if (state is PdfSuccess) {
              downloadFile(
                Uint8List.fromList(state.pdfBytes),
                'contract.pdf',
                'application/pdf',
              );
            } else if (state is PdfFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Generación de PDF Fallida: ${state.error}')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<FormCubit, ContractFormState>(
              builder: (context, state) {
                final cubit = context.read<FormCubit>();
                final pdfCubit = context.read<PdfCubit>();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: cubit.updateFirstName,
                      decoration: const InputDecoration(labelText: 'Nombres'),
                    ),
                    TextField(
                      onChanged: cubit.updateLastName,
                      decoration: const InputDecoration(labelText: 'Apellidos'),
                    ),
                    TextField(
                      onChanged: cubit.updateEmail,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          cubit.updateDateOfBirth(picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de nacimiento',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          state.dateOfBirth != null
                              ? state.dateOfBirth!.toLocal().toString().split(' ')[0]
                              : 'Selecciona una fecha',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      value: state.permissionGiven,
                      onChanged: (bool? value) {
                        if (value != null) {
                          cubit.togglePermission(value);
                        }
                      },
                      title: const Text("Doy el permiso para X"),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: cubit.isComplete()
                          ? () async {
                        await pdfCubit.generatePdf(state);
                      }
                          : null,
                      child: const Text("Continuar"),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
