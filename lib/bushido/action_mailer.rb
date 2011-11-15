module ActionMailer
  class Base
    private
    def perform_delivery_bushido(mail)
      result = Bushido::App.mail_allowed?

      puts result.inspect

      if result["success"] == true
        Bushido::SMTP.setup_action_mailer_smtp!

        unless logger.nil?
          logger.info "App allowed to send email, sending via SMTP"
          __send__("perform_delivery_smtp", mail) if perform_deliveries
        end
      end
    end
  end
end
