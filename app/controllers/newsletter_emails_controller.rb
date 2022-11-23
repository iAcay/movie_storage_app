class NewsletterEmailsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sign_into_newsletter
    newsletter_email = NewsletterEmail.new(newsletter_email_params)

    if newsletter_email.save
      render json: newsletter_email, status: :ok
    else
      render json: newsletter_email, status: :unprocessable_entity
    end
  end

  private

  def newsletter_email_params
    params.require(:newsletter_email).permit(:email)
  end
end
