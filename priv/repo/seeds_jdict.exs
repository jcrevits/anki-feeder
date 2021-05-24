alias AnkiFeeder.Utils

import SweetXml

require Logger

Logger.info("== Seeding JMdict content ==")
Logger.info("Reading JMdict file")

contents =
  case :zip.extract('priv/data/JMdict.zip', [:memory]) do
    {:ok, [{_filename, content}]} ->
      content

    {:error, reason} ->
      Logger.error(reason)
  end

Logger.info("Parsing XML content")

kanji_or_reading = fn term ->
  if length(term.kanji) == 0 do
    List.first(term.reading)
  else
    List.first(term.kanji)
  end
end

# TODO - this uses too much memory, need to optimize it with a stream but with the XML parser :(
xml_content =
  xpath(
    contents,
    ~x"/JMdict/entry"l,
    kanji: ~x"./k_ele/keb/text()"ls,
    reading: ~x"./r_ele/reb/text()"ls,
    definition: ~x"./sense/gloss/text()"ls,
    misc: ~x"./sense/misc/text()"ls
  )

Logger.info("Preparing structs")

terms =
  Enum.map(xml_content, fn term ->
    %{
      kanji: kanji_or_reading.(term),
      kanji_others: Enum.join(Enum.drop(term.kanji, 1), ", "),
      reading: Enum.join(term.reading, ", "),
      definition: Enum.join(term.definition, ", "),
      misc: Enum.dedup(term.misc) |> Enum.join(", ")
    }
  end)

Logger.info("Inserting content")

Utils.bulk_insert(terms, AnkiFeeder.Mnemo.Term)

Logger.info("Inserted JMdict terms")
