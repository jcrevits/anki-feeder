alias AnkiFeeder.Mnemo.Example
alias AnkiFeeder.Repo

alias NimbleCSV

require Logger

NimbleCSV.define(MyParser, separator: "\t", escape: ~s("\"))

Logger.info("== Seeding Examples from CSV ==")
Logger.info("Reading CSV file")

file_content =
  case File.read("examples.tsv") do
    {:ok, content} ->
      content

    {:error, reason} ->
      IO.puts(reason)
  end

Logger.info("Parsing CSV content")

parsed_content = MyParser.parse_string(file_content)

for [japanese, english] <- parsed_content do
  Repo.insert!(%Example{japanese: japanese, english: english})
end

Logger.info("Inserted examples")
