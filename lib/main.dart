import 'package:flutter/material.dart';
//Nama: William Suryadinata
//NIM: 71200572
void main() {
  runApp(const MyApp());
}
class DaftarProduk extends StatefulWidget {
  @override
  _DaftarProdukState createState() => _DaftarProdukState();
}

class _DaftarProdukState extends State<DaftarProduk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KeranjangBelanja()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: produkList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        ),
        itemBuilder: (context, index){
          return GestureDetector(
            onTap:(){
              addToCart(produkList[index]);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("berhasil menambahkan keranjang belanja"),
                      duration: Duration(seconds: 1),
            ),
          );
        },
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
        children:[
          Expanded(
            child: Image.network(
              produkList[index].gambar,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            produkList[index].nama,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.0),
          ElevatedButton(
    onPressed: () {
    addToCart(produkList[index]);
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text(
    'Berhasil menambahkan ${produkList[index].nama} ke keranjang belanja!'),
    duration: Duration(seconds: 1),
        ),
      );
    },
    child: Text('Tambah ke Keranjang'),
                 ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: keranjangBelanja.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: keranjangBelanja[index].gambar,
                    placeholder: (context, url) =>
                        CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(keranjangBelanja[index].nama),
                  subtitle: Text('${keranjangBelanja[index].berat} kg'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                        },
                      ),
                      Text('${keranjangBelanja[index].jumlah}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Harga Subtotal:'),
            trailing: Text(
              "Rp ${calculateSubtotal().toStringAsFixed(0)}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text("Shipping Cost:"),
            trailing: Text(
              'Rp ${calculateShippingCost().toStringAsFixed(0)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('Total Harga:'),
            trailing: Text(
              'Rp ${calculateTotalPrice().toStringAsFixed(0)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  double calculateSubtotal() {
    double subtotal = 0.0;
    for(Produk produk in keranjangBelanja) {
      totalBerat += produk.berat * produk.jumlah;
    }
    double biayaPengiriman = 0.0;
    if (totalBerat > 0.0) {
      biayaPengiriman = 5000.0;
      biayaPengiriman *= (totalBerat / 1000.0);
    }
    return biayaPengiriman;
  }
  double calculateTotalPrice() {
    return calculateSubtotal() + calculateShippingCost();
  }
}
class Produk{
  String nama;
  String gambar;
  double berat;
  double harga;
  int jumlah;

  Produk({this.nama,this.gambar,this.berat,this.harga,this.jumlah = 1});
}
List<Produk> produkList = [
  Produk(
    nama: "bakso",
    gambar: "https://kabartuban.com/wp-content/uploads/2023/01/bakso-tetelan.jpg",
    berat: 0.5,
    harga: 5000.0),
  Produk(
    nama: "es jeruk",
    gambar: "https://bebekbkb.com/wp-content/uploads/2020/02/es-jeruk.jpg",
    berat: 0.5,
    harga: 8000.0),
  Produk(
    nama: "Taro",
    gambar: "https://images.tokopedia.net/img/cache/500-square/product-1/2019/3/13/49422932/49422932_83c4aa77-aa28-46de-a8fe-0ae09d555351_700_700.jpg",
    berat: 0.1,
    harga: 2000.0),
  Produk(
    nama: "biore",
    gambar: "https://images.soco.id/998179ae-90f9-428f-a367-16b042c16106-image-0-1612941492190",
    berat: 0.4,
    harga: 12000.0),
];

List<Produk> keranjangBelanja = [];
void addToCart(Produk produk) {
  int index = keranjangBelanja.indexWhere((p) => p.nama == produk.nama);
  if (index != -1) {
    setState(() {
      keranjangBelanja[index].jumlah++;
    });
  } else {
    setState(() {
      keranjangBelanja.add(produk);
    });
  }
}

void reduceProductAmount(Produk produk) {
  setState(() {
    if (produk.jumlah > 1) {
      produk.jumlah--;
    } else {
      keranjangBelanja.remove(produk);
    }
  });
}

void reduceProductAmount(Produk produk) {
  setState(() {
    if (produk.jumlah > 1) {
      produk.jumlah--;
    } else {
      keranjangBelanja.remove(produk);
    }
  });
}

void increaseProductAmount(Produk produk) {
  setState(() {
    produk.jumlah++;
  });
}
class KeranjangBelanja extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int subtotal = hitungSubtotal();
    int berat = hitungBerat();
    String kurir = 'JNE';
    int biayaPengiriman = 0;
    if (berat > 0) {
      biayaPengiriman = int.parse(hargaPengiriman[kurir][berat.toString()]);
    }
    int total = hitungTotal(subtotal, kurir);
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja'),
      ),
      body: keranjangBelanja.isEmpty
          ? Center(
        child: Text('Keranjang belanja kosong.'),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: keranjangBelanja.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    keranjangBelanja[index].gambar,
                    width: 50.0,
                    height: 50.0,
                  ),
                  title: Text(keranjangBelanja[index].nama),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${keranjangBelanja[index].berat} Kg'),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              reduceProductAmount(
                                  keranjangBelanja[index]);
                            },
                          ),
                          Text(keranjangBelanja[index]
                              .jumlah
                              .toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              increaseProductAmount(
                                  keranjangBelanja[index]);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Text(
                    'Rp ${(keranjangBelanja[index].harga *
                        keranjangBelanja[index].jumlah).toStringAsFixed(0)}',
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subtotal: Rp ${subtotal.toStringAsFixed(0)}',
                  SizedBox(height: 8.0),
                  Text('Berat: ${berat.toString()} Kg'),
                  SizedBox(height: 8.0),
                ),
                Text(
                  'Biaya Pengiriman (${kurir}): Rp ${biayaPengiriman
                      .toString()}',
                ),
                SizedBox(height: 8.0),
                Divider(),
                SizedBox(height: 8.0),
                Text(
                  'Total: Rp ${total.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Checkout'),
                          content: Text(
                              'Anda akan melakukan checkout dengan total pembayaran sebesar Rp ${total
                                  .toStringAsFixed(0)}.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Lakukan proses checkout
                                checkout();
                              },
                              child: Text('Checkout'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
void checkout() {
  keranjangBelanja.clear();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Checkout Berhasil'),
        content: Text('Terima kasih sudah berbelanja.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Tutup'),
          ),
        ],
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
