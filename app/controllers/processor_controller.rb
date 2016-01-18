class ProcessorController < ApplicationController
  protect_from_forgery with: :null_session

  def receive
    result = {}
    received_hash = JSON.parse(request.body.read)
    received_update = FantasticRobot::Model::Update.new(received_hash)

    unless (received_update.message.blank?)
      message = received_update.message
      @chat = Chat.where(telegram_id: message.chat.id).first

      if (@chat.blank?) # Not registered chat
        chat_title = message.chat.title || message.chat.username || [message.chat.first_name, message.chat.last_name].join(" ")

        chat_is_group = (message.chat.type == "group")

        @chat = Chat.create(telegram_id: message.chat.id, title: chat_title, is_group: chat_is_group)

        resp = FantasticRobot::Request::SendMessage.new({
          chat_id: message.chat.id,
          text: "Hello! I'm SlackRobot, and I'm here to help you.\nIf you want to configure me, issue the /config command."
        })
      else
        resp = process_message(message) || []
      end
    end
    render json: resp
  end

  private

  def process_message msg
    return nil if (msg.text.blank?)
    return nil if (msg.from.username == "SlackRobot")

    if (msg.text == '/config' || msg.text == '/config@SlackRobot')
      return FantasticRobot::Request::SendMessage.new({
        chat_id: msg.chat.id,
        text: "You can use [this control panel](#{responses_url(chat_id: @chat.id, telegram_id: @chat.telegram_id)}) to configure my behaviour :)",
        parse_mode: "Markdown",
        disable_web_page_preview: true,
        reply_to_message_id: msg.message_id
      })
    else
      response = @chat.responses.for_js("for(var i in this.queries){ if (param.indexOf(this.queries[i]) > -1) return true; }", param: msg.text).first

      unless (response.blank?)
        # Found a valid response
        resp ||= FantasticRobot::Request::SendMessage.new({
          chat_id: msg.chat.id,
          text: response.responses.sample
        })

        resp.parse_mode = "Markdown" if (response.markdown)
        resp.reply_to_message_id = msg.message_id if (response.reply)

        return resp
      end
    end
  end
end
