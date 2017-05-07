#
#30-Day Chart
#

$PriceData = [System.Collections.Specialized.OrderedDictionary]@{}

$Data = (Invoke-RestMethod -Method Get -Uri 'https://api.coindesk.com/v1/bpi/historical/close.json' -ContentType 'application/json').bpi | Out-String

$Data = $Data.Trim() -split "`r`n" 

foreach ($Item in $Data)
{
    $line = $Item -split ':'
    $PriceData.Add($line[0], $line[1])
}

[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.Datavisualization")


$Chart = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
$Chart.Width = 650
$Chart.Height = 400

$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$Chart.ChartAreas.Add($ChartArea)


[void]$Chart.Titles.Add('Bitcoin Price History (30 day)')
$ChartArea.AxisX.Title = 'Date'
$ChartArea.AxisY.Title = 'Price (USD)'
$Chart.Titles[0].Font = New-Object System.Drawing.Font('Arial', 18, [System.Drawing.FontStyle]::Bold)
$ChartArea.AxisX.TitleFont = New-Object System.Drawing.Font('Arial', 12)
$ChartArea.AxisY.TitleFont = New-Object System.Drawing.Font('Arial', 12)
$ChartArea.AxisY.Interval = 50
$ChartArea.AxisX.Interval = 1
$ChartArea.AxisY.IsStartedFromZero = 0


[void]$Chart.Series.Add('Price')
$Chart.Series['Price'].ChartType = "Line"
$Chart.Series['Price'].BorderWidth = 3
$Chart.Series['Price'].ChartArea = "ChartArea1"
$Chart.Series['Price'].Color = "#62B5CC"
$Chart.Series['Price'].Points.DataBindXY($PriceData.Keys, $PriceData.Values)


$Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
    [System.Windows.Forms.AnchorStyles]::Right -bor 
    [System.Windows.Forms.AnchorStyles]::Top -bor 
    [System.Windows.Forms.AnchorStyles]::Left
$Form = New-Object Windows.Forms.Form
$Form.Text = "Bitcoin 30-day Price Chart"
$Form.Width = 660
$Form.Height = 440
$Form.Controls.Add($Chart)
$Form.Add_Shown({ $Form.Activate() })
$Form.ShowDialog()

#
# Current selected market exchange rates
#

$ExchangeRates = @()

$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

$CoinbaseBuy = Invoke-RestMethod -Uri https://coinbase.com/api/v1/prices/buy
$CoinbaseSell = Invoke-RestMethod -Uri https://coinbase.com/api/v1/prices/sell
$CoinbaseRates = New-Object PSObject -property  @{BuyPrice = $Coinbasebuy.total.amount; SellPrice = $Coinbasesell.total.amount; Exchange = "Coinbase"}
$ExchangeRates += $CoinbaseRates

$CampBXRates = Invoke-RestMethod -Uri http://campbx.com/api/xticker.php
$BX = New-Object PSObject -property  @{BuyPrice = $CampBXRates."Best Ask"; SellPrice =  $CampBXRates."Best Bid"; Exchange = "Camp BX"}
$ExchangeRates += $BX

$BTCERates = Invoke-RestMethod -Uri https://btc-e.com/api/2/btc_usd/ticker
$BTCE = New-Object PSObject -property  @{BuyPrice = $BTCERates.ticker.buy; SellPrice = $BTCERates.ticker.sell; Exchange = "BTC-E"}
$ExchangeRates += $BTCE

$BitStampRates = Invoke-RestMethod -Uri https://www.bitstamp.net/api/v2/ticker/btcusd
$BitStamp = New-Object PSObject -property @{BuyPrice = $BitStampRates.bid; SellPrice = $BitStampRates.ask; Exchange = "BitStamp"}
$ExchangeRates += $BitStamp

#no value names on reponses
$BitFinexRates = Invoke-RestMethod -Uri https://api.bitfinex.com/v2/ticker/tBTCUSD
$BitFinex = New-Object PSObject -property @{BuyPrice = $BitFinexRates.}

#Print Rates - needs graph
$ExchangeRates




#Candlestick  - needs more... candle. 
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.Datavisualization")


$Chart = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
$Chart.Width = 650
$Chart.Height = 400

$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$Chart.ChartAreas.Add($ChartArea)

[void]$Chart.Titles.Add('Bitcoin Exchange Candlestick')