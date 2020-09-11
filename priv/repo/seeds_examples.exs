alias AnkiFeeder.Mnemo.Example
alias AnkiFeeder.Repo

alias NimbleCSV

require Logger

NimbleCSV.define(MyParser, separator: "\t", escape: ~s("\"))

Logger.info("== Seeding Examples from CSV ==")
Logger.info("Reading CSV file")

file_content =
  case :zip.extract('priv/data/examples.zip', [:memory]) do
    {:ok, [{_filename, content}]} ->
      content

    {:error, reason} ->
      IO.puts(reason)
  end

Logger.info("Parsing CSV content")

# TODO - stream this?
parsed_content = MyParser.parse_string(file_content)

# TODO - unoptimized, needs chunked stream
for [japanese, english] <- parsed_content do
  Repo.insert!(%Example{japanese: japanese, english: english})
end

Logger.info("Inserted examples")
