require 'sinatra'   # gem 'sinatra'
require 'line/bot'  # gem 'line-bot-api'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["95b0359572c9e4cfb58af7de6328e519
"]
    config.channel_token = ENV["oQKdsxvTtfCDQYMVPJqiZEUO5UjKb1js+t5Znbi9ongpuxo5FjAPWzd8KKYrlDX0tCXvEMf4v4HuZuOF8AuMKGj60rVwn/iBY1xoYvfY1bQKNcKQ/xVl2pe8rVpXBP+HHmA8hhg6Sj0fCGG89f4a3gdB04t89/1O/w1cDnyilFU=
"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)

  events.each { |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)
      end
    end
  }

  "OK"
end
