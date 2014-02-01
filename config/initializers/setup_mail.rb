if Rails.env.development?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => "app21586386@heroku.com",
    :password       => "ulxl1po9",
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }
end