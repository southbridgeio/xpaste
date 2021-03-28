class Paste < Granite::Base
  connection pg
  table pastes

  @[JSON::Field(ignore: true)]
  column id : Int64, primary: true, json_options: { ignore: true }

  @[JSON::Field(ignore: true)]
  column body : String, json_options: { ignore: true }

  @[JSON::Field(ignore: true)]
  column language : String, json_options: { ignore: true }

  column permalink : String?

  @[JSON::Field(ignore: true)]
  column auto_destroy : Bool, json_options: { ignore: true }

  @[JSON::Field(ignore: true)]
  column will_be_deleted_at : Time, json_options: { ignore: true }

  timestamps

  LANGUAGE = %i[text markdown pgsql ruleslanguage groovy mathematica ruby yaml livescript xml erlang-repl elm java lua swift
                      crystal erb processing javascript stylus brainfuck vbnet go php mercury gherkin cpp arduino applescript delphi
                      elixir objectivec lisp scss accesslog xquery pf vbscript clojure vbscript-html haskell livecodeserver properties
                      ldif r python powershell dust gradle htmlbars sql actionscript haxe kotlin json ini csp prolog bash makefile excel
                      coffeescript fsharp ebnf diff rust cmake routeros scala matlab twig typescript awk haml vim tcl dos perl
                      django shell nginx roboconf http css less c cs handlebars smalltalk erlang plaintext dns apache dart tex
                      dockerfile d]

  DEFAULT_TTL_DAYS = 365

  def auto_destroy?
    auto_destroy == true
  end

  def ttl_days
    ((will_be_deleted_at.as(Time) - Time.local).to_i / (60 * 60 * 24)).round
  end

  def ttl_days=(days)
    self.will_be_deleted_at = days.to_i <= 5000 ? days.to_i.days.from_now : 5000.days.from_now
  end

  def self.generate_token(size = 8)
    chars = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
    (0...size).map{ chars[rand(chars.size)] }.join
  end
end
