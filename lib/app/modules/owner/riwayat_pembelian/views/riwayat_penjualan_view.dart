import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiwayatPenjualanView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          'Produk Manajemen',
          style: GoogleFonts.poppins(color: Colors.white),
          ),
        actions: [
          
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(width: 10), 
            Center(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Pilih Tanggal',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    
                  }
                },
              ),
            ),
            SizedBox(width: 20), 
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 10, 
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('${index + 1} name'), 
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              
                            },
                            child: Checkbox(
                              value: index.isEven,
                              onChanged: (bool? value) {
                               
                              },
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  
                                },
                                child: Text('Detail Penjualan'),
                              ),
                              TextButton(
                                onPressed: () {
                                 
                                },
                                child: Text('Detail Konsumen'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
