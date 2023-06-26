# Automatisches Login in das Schülernetzwerk
Dieses Skript ersetzt die Login-Seite des Schülernetzwerks, es muss nur einmal aufgesetzt werden und zum Einloggen ausgeführt werden. Es funktioniert auch über LAN/Ethernet, wird aber eher seltener von Schülern verwendet, daher der Name.

## Setup
1. Die `WIFILoginScript_HTLgkr.ps1` herunterladen und in einem Editor öffnen.
2. Bei `$username` den Benutzernamen eingeben, dem man im sonstigen Schulgebrauch verwendet.
3. Bei `$password` gibt es zwei Optionen:
  * Password im Klartext (nicht empfohlen): Der folgende Code
  ```ps
  $passwordBase64Encoded = 'YOUR_BASE64_ENCODED_PASSWORD_SEE_ABOVE'
  $password = [System.Text.Encoding]::UNICODE.GetString([System.Convert]::FromBase64String($passwordBase64Encoded))
  ```
  kann durch diesen ersetzt werden (Der Text natürlich durch das PW ersetzen):
  ```ps
  $password = 'YOUR_PASSWORD_IN_CLEAR_TEXT'
  ```
  * Password Base64 kodiert (empfohlen):
    * Öffnen einer neuen PowerShell Instanz (eingebette Version von ISE nicht empfohlen)
    * Den folgenden Befehl einfügen und dabei 'YOUR_PASSWORD_HERE' mit dem Klartext Password ersetzen:
      ```ps
      [System.Convert]::ToBase64String([System.Text.Encoding]::UNICODE.GetBytes(  'YOUR_PASSWORD_HERE' ))
      ```
      So soll es in etwa aussehen:
      ```ps
      PS C:\Users\username> [System.Convert]::ToBase64String([System.Text.Encoding]::UNICODE.GetBytes( '123456789' ))
      MQAyADMANAA1ADYANwA4ADkA
      PS C:\Users\username>
      ```
      Die Ausgabe dieses Befehls (im Beispiel `MQAyADMANAA1ADYANwA4ADkA`) kopieren und bei `YOUR_BASE64_ENCODED_PASSWORD_SEE_ABOVE` einsetzen, wie folgt:
      ```ps
      $passwordBase64Encoded = 'MQAyADMANAA1ADYANwA4ADkA'
      ```
      Das Passwort wird dann automatisch in der nächsten Zeile dekodiert und temporär in `$password` gespeichert. <br />
      WICHTIG: Das Passwort ist noch in Powershell gespeichert! Mit folgenden Befehlen kann es gelöscht werden:
      - `Clear-History` 
      - `[Microsoft.Powershell.PSConsoleReadLine]::ClearHistory()`
      - `rm (Get-PSReadLineOption).HistorySavePath`

## Ausführen / Verknüpfungen
Bei Doppelklick sollte man sich jetzt einloggen können (vorausgesetzt man ist im Schulnetzwerk).
Mehrfache Ausführungen des Skriptes sind harmlos (man bleibt eingeloggt), es versucht einen normalen Browser nachzuarmen. Trotzdem sollte man das Netzwerk nicht spammen, daher bei eigenen Skripts aufpassen.<br /><br />
Falls man das Skript als Shortcut am Startmenü / der Taskleiste haben will, muss man zum Skript eine Verknüpfung erstellen. Dann muss im Kontextmenü unter Eigenschaften > Verknüpfung > 'Ziel' der Pfad angepasst werden, von `C:\MeineSkripte\WIFIConnectorScript_HTLgkr.ps1` zu `powershell.exe -command "C:\MeineSkripte\WIFILoginScript_HTLgkr.ps1"`.
Icon, etc. kann man auch ändern. Jetzt per Rechtsklick an das Startmenü / Taskleiste hinzufügen, _Profit!_
