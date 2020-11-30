import 'package:bitcoin_ticker/networking.dart';

const String apiKey = '3D3C0E6C-0D49-41C5-9C89-E072167A343C';
const String baseUrl = 'https://rest.coinapi.io/v1';

class CoinApi {
  Future<dynamic> getExchangeRate(crypto, currency) async {
    NetworkHelper networkHelper =
        NetworkHelper('$baseUrl/exchangerate/$crypto/$currency?apikey=$apiKey');
    var exchangeRate = await networkHelper.getData();
    print("exchangeRate ::  $exchangeRate");
    return exchangeRate;
  }
}
