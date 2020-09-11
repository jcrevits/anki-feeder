# AnkiFeeder
An easier way to add Japanese/English cards to Anki. It uses Phoenix/Elixir - my new favorite fun way to make personal projects.

## Setup - AnkiFeeder
- run `mix setup`
- run `mix ecto.setup` to insert the dictionary entries and the example sentences (this will take a while)
- start the server with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Setup - Anki
- add [AnkiConnect to Anki](https://ankiweb.net/shared/info/2055492159)
- start Anki
- replace the hardcoded deck and model names with yours as well as the field names in `anki_connect.ex`

### Screenshot
![App Screenshot](/priv/screenshot.png)

## Sources
- Japanese dictionary comes from [JMdict](http://www.edrdg.org/jmdict/j_jmdict.html)
- Example sentences come from the [Tanaka Corpus](http://www.edrdg.org/wiki/index.php/Tanaka_Corpus)
