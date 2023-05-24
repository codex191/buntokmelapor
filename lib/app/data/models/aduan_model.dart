class Aduan {
  final String id;
  final String judul;
  final String deskripsi;
  final String kategori;
  final String status;
  final String pengirim;
  final String tanggal;
  
  Aduan({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.kategori,
    required this.status,
    required this.pengirim,
    required this.tanggal,
  });
  
  factory Aduan.fromMap(Map<String, dynamic> data, String documentId) {
    return Aduan(
      id: documentId,
      judul: data['judul'],
      deskripsi: data['deskripsi'],
      kategori: data['kategori'],
      status: data['status'],
      pengirim: data['pengirim'],
      tanggal: data['tanggal'],
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'status': status,
      'pengirim': pengirim,
      'tanggal': tanggal,
    };
  }
}