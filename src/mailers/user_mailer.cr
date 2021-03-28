class UserMailer < Quartz::Composer
  def sender
    address email: "xpaste@xpaste.pro", name: "xPaste"
  end

  def initialize(name : String, email : String)
    to email: email, name: name # Can be called multiple times to add more recipients

    subject "Welcome to xPaste"

    text render("mailers/welcome_mailer.text.ecr")
    html render("mailers/welcome_mailer.html.slang", "mailer-layout.html.slang")
  end
end
