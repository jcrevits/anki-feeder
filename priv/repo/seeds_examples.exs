
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
      Logger.error(reason)
  end

Logger.info("Parsing CSV content")

MyParser.parse_string(file_content)
|> Stream.map(fn [japanese, english] -> %{japanese: japanese, english: english} end)
|> AnkiFeeder.Utils.bulk_insert(AnkiFeeder.Mnemo.Example)

Logger.info("Inserted examples")
