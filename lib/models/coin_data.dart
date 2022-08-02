

class CoinData {
  int rank = 0;
  String id = '';
  String name = '';
  String symbol = '';
  double value = 0;
  double percentChange = 0;
  double percentChange1h = 0;
  double percentChange7d = 0;
  double percentChange30d = 0;
  double percentChange1y = 0;
  double percentChangeatl = 0;
  double percentChangeath = 0;
  String imageUrl = '';
  double high_24h = 0;
  double low_24h = 0;
  double total_volume = 0;
  double ath = 0;
  double atl = 0;


  CoinData(
      this.rank,
      this.id,
      this.name,
      this.symbol,
      this.value,
      this.percentChange,
      this.percentChange1h,
      this.percentChange7d,
      this.percentChange30d,
      this.percentChange1y,
      this.percentChangeatl,
      this.percentChangeath,
      this.imageUrl,
      this.high_24h,
      this.low_24h,
      this.total_volume,
      this.ath,
      this.atl);


  @override
  String toString() {
    return 'CoinData{rank: $rank, id: $id, name: $name, symbol: $symbol, value: $value, percentChange: $percentChange, percentChange1h: $percentChange1h, percentChange7d: $percentChange7d, percentChange30d: $percentChange30d, percentChange1y: $percentChange1y, percentChangeatl: $percentChangeatl, percentChangeath: $percentChangeath, imageUrl: $imageUrl, high_24h: $high_24h, low_24h: $low_24h, total_volume: $total_volume, ath: $ath, atl: $atl}';
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'id': id,
      'name': name,
      'symbol': symbol,
      'value': value,
      'percentChange': percentChange,
      'percentChange1h': percentChange1h,
      'percentChange7d': percentChange7d,
      'percentChange30d': percentChange30d,
      'percentChange1y': percentChange1y,
      'percentChangeatl': percentChangeatl,
      'percentChangeath':percentChangeath,
      'imageUrl': imageUrl,
      'high_24h': high_24h,
      'low_24h': low_24h,
      'total_volume': total_volume,
      'ath': ath,
      'atl': atl,
    };
  }


  factory CoinData.fromJson(dynamic json) {
    return CoinData(
        json['rank'] as int,
        json['id'] as String,
        json['name'] as String,
        json['symbol'] as String,
        json['value'] as double,
        json['percentChange'] as double,
        json['percentChange1h'] as double,
        json['percentChange7d'] as double,
        json['percentChange30d'] as double,
        json['percentChange1y'] as double,
        json['percentChangeatl'] as double,
        json['percentChangeath'] as double,
        json['imageUrl'] as String,
        json['high_24h'] as double,
        json['low_24h'] as double,
        json['total_volume'] as double,
        json['ath'] as double,
        json['atl'] as double,
    );

  }
}
