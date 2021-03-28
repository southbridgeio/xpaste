module ApplicationHelper
  LAYOUT = "application.slang"
  @development : Bool? = Amber.env.development?
end
