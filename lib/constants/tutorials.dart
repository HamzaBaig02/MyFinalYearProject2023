
List<String> performanceIndicatorsTutorial = ['Moving average is a very effective indicator, as it helps traders find the trend without an information overflow. The basic concept is to discover what average traders are doing in the market.\nFor example, if a crypto asset’s price is above the 50-day moving average, it indicates that its buyers are more active than its sellers.Therefore, if you want to trade that cryptocurrency, you can quickly eliminate selling opportunities and consider only buying opportunities.',
'RSI evaluates the change in crypto or stock asset price over a default 14-period time frame. It is a momentum indicator that indicates overbought or oversold situations of an asset or cryptocurrency. Simply put, RSI is an oscillator that calculates high and low bands between two opposite values, while estimating the magnitude of price variation and the speed of these variations.\nGenerally, an asset is overbought when the RSI value is 70% or above, and oversold when the value is 30% or below.\nWhen an asset is overbought, it’s a clear signal of a looming downtrend. On the flip side, oversold security is a sign of an incoming upward trend.'
,'The cryptocurrency market is highly speculative in nature, which usually leads to exaggerated levels of volatility. To compensate, investors need to use technical indicators that adapt to the volatility of cryptocurrencies. One such indicator is the exponential moving average (EMA), which is designed to smooth out the effects of price volatility.\nAn exponential moving average is a technical indicator that gives greater weighting to recent prices in its calculation. As a result, EMA responds more quickly to the latest price changes, as compared to a simple moving average (SMA), which has a bigger lag. '];

String smaTrendSellers = 'price is trending below the SMA which indicates that its sellers are more active than its buyers. This means that you should consider selling.';
String smaTrendBuyers = 'price is trending above the SMA which indicates that its buyers are more active than its sellers. This means that you should consider buying.';

String emaTrendSellers = 'price is trending below the EMA which indicates that its sellers are more active than its buyers. This means that you should consider selling.';
String emaTrendBuyers = 'price is trending above the EMA which indicates that its buyers are more active than its sellers. This means that you should consider buying.';

String rsiAbove70 = 'RSI is 70 or above which indicates that the asset is overbought.';
String rsiBelow30 = 'RSI is 30 or below which indicates that the asset is overSold.';
String rsiNeutralAbove50 = 'above 50, this indicates a bullish trend is brewing.';
String rsiNeutralBelow50 = 'below 50, this indicates a bearish trend is brewing.';

List<String> performanceIndicatorAnalyzer({required double currentPrice,required int indicatorNameIndex,required double indicator,required String coinName}){

  if(indicatorNameIndex == 0 || indicatorNameIndex == 1){
    if(currentPrice < indicator)
    return ['SELL','\nCurrently $coinName $smaTrendSellers \n','${performanceIndicatorsTutorial[0]}'];
    else if (currentPrice > indicator)
      return ['BUY','\nCurrently $coinName $smaTrendBuyers \n','${performanceIndicatorsTutorial[0]}'];
  }
  else if(indicatorNameIndex == 2){
    if(indicator >= 70)
      return ['SELL','\n$coinName $rsiAbove70\n','${performanceIndicatorsTutorial[1]}'];
    else if(indicator <= 30)
      return ['BUY','\n$coinName $rsiBelow30\n','${performanceIndicatorsTutorial[1]}'];
    else{
      bool above50 = true;
      if(indicator >= 50)
        above50 = true;
      if(indicator <= 50)
        above50 = false;

      return['NEUTRAL','\nThe RSI is neutral, However it is ${above50?rsiNeutralAbove50:rsiNeutralBelow50}\n','${performanceIndicatorsTutorial[1]}'];
    }
  }
  else if(indicatorNameIndex == 3){
    if(currentPrice < indicator)
      return ['SELL','\nCurrently $coinName $emaTrendSellers \n','${performanceIndicatorsTutorial[2]}'];
    else if (currentPrice > indicator)
      return ['BUY','\nCurrently $coinName $emaTrendBuyers \n','${performanceIndicatorsTutorial[2]}'];

  }
  else{
    return ['','',''];
  }

return ['','',''];
}