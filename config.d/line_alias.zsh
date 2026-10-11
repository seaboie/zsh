                        ### ---------------------    LINE API Key  --------  #######

export LINE_N8N_BOT_ACCESS_TOKEN="/ZScS3Vzv4bAM+D9W3fDMFXCO5OH0TUhZlse+TfhL2eTax9X5H8dIcegokmZdpP/CnowxSQwlTrS9j5rhCzqNcHNjLTW+a35ls4BybdhgHhY7zVyggs9IkvpXRKqsuA7X1maKpzajJluj7bgHOz5WgdB04t89/1O/w1cDnyilFU="





                        ### ---------------------    LINE Reply  --------  #######

line_insight_message() {
  if [ -z "$1" ]; then
    echo "🔨 Usage: line_insight_message <date_yyyyMMdd>"
    echo "🛠️ Example: line_insight_message 20250615  # June 15, 2025"
    return 1
  fi

  if [ -z "$LINE_N8N_BOT_ACCESS_TOKEN" ]; then
    echo "Error: LINE_N8N_BOT_ACCESS_TOKEN environment variable not set!"
    return 1
  fi

  curl -sS -X GET \
    "https://api.line.me/v2/bot/insight/message/delivery?date=$1" \
    -H "Authorization: Bearer $LINE_N8N_BOT_ACCESS_TOKEN"
}