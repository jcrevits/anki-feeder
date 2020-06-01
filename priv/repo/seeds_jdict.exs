alias AnkiFeeder.Repo
alias AnkiFeeder.Mnemo.Term

import SweetXml

require Logger

Logger.info("== Seeding JMdict content ==")
Logger.info("Reading JMdict file")

contents =
  case File.read("JMdict.xml") do
    {:ok, content} ->
      content

    {:error, reason} ->
      IO.puts(reason)
  end

Logger.info("Parsing XML content")

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

kanji_or_reading = fn term ->
  if length(term.kanji) == 0 do
    List.first(term.reading)
  else
    List.first(term.kanji)
  end
end

term_structs =
  Enum.map(xml_content, fn term ->
    %Term{
      kanji: kanji_or_reading.(term),
      kanji_others: Enum.join(Enum.drop(term.kanji, 1), ", "),
      reading: Enum.join(term.reading, ", "),
      definition: Enum.join(term.definition, ", "),
      misc: Enum.dedup(term.misc) |> Enum.join(", ")
    }
  end)

Logger.info("Inserting content")

for term <- term_structs do
  Repo.insert!(term)
end

Logger.info("Inserted JMdict terms")