/*


   DecoratedBox(
          decoration:
              BoxDecoration(color: const Color(0xFF0E3311).withOpacity(0.0)),
          child: SizedBox(
            width: double.infinity,
            height: 50,
          ),
        ),







 return DecoratedBox(
      decoration: BoxDecoration(color: Colors.yellow),
      child: SizedBox(
        width: double.infinity,
        height: 50,
      ),
    );




  DecoratedBox(
  decoration: BoxDecoration(color: Colors.yellow),
  child: ,

  )


  Expanded(
            flex: 1,
            child: 
            ,
          )









              Rks.logger.d("--${info}");
              Rks.logger.f("**${info}");
              Rks.logger.e("++${info}");
              Rks.logger.i("//${info}");
            
 InkWell(
              onTap: () {
                setState(() {
                  inkwell='Inkwell Tapped';
                });
              }, 
              child: Container(
                  color: Colors.green,
                  width: 120,
                  height: 70,
                  child: Center(
                      child: Text(
                        'Inkwell',
                        textScaleFactor: 2,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
            ),

*/

// void _simulatePurchase(ProductDetails product) async {
//   print('🛒 Simulation d\'achat pour : ${product.id}');
//   await Future.delayed(Duration(seconds: 10));
//   final PurchaseDetails fakePurchase = PurchaseDetails(
//       purchaseID: 'test_purchase_id',
//       productID: product.id,
//       status: PurchaseStatus.purchased,
//       verificationData: PurchaseVerificationData(
//           source: "test_source",
//           localVerificationData: 'test_local_verification_data',
//           serverVerificationData: 'test_server_verification_data'),
//       transactionDate: "2021-09-01T12:00:00Z");

//   if (fakePurchase.status == PurchaseStatus.purchased) {
//     print('✅ Achat simulé réussi : ${fakePurchase.productID}');
//     _sendPurchaseToBackend(fakePurchase, product);
//   } else {
//     print('❌ Achat simulé échoué');
//   }
// }
