#!/bin/bash

# 1. Überprüfen, ob das Skript als Root ausgeführt wird
if [ "$EUID" -ne 0 ]; then
  echo "Fehler: Bitte führe dieses Skript mit Root-Rechten aus (z. B. sudo ./install_services.sh)."
  exit 1
fi

# 2. Pfad zum Skript selbst und dem parallelen 'services'-Ordner ermitteln
# Das funktioniert auch, wenn du das Skript aus einem ganz anderen Verzeichnis aufrufst
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
SOURCE_DIR="$SCRIPT_DIR/services"
SYSTEMD_DIR="/etc/systemd/system"

# Prüfen, ob der services-Ordner überhaupt existiert
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Fehler: Der Ordner '$SOURCE_DIR' existiert nicht!"
    echo "Bitte lege einen Ordner namens 'services' direkt neben diesem Skript an."
    exit 1
fi

# 3. Prüfen, ob .service-Dateien existieren (verhindert Fehler, wenn der Ordner leer ist)
shopt -s nullglob
SERVICE_FILES=("$SOURCE_DIR"/*.service)

if [ ${#SERVICE_FILES[@]} -eq 0 ]; then
    echo "Keine *.service-Dateien im Verzeichnis '$SOURCE_DIR' gefunden. Abbruch."
    exit 0
fi

echo "Gefunden: ${#SERVICE_FILES[@]} Service-Datei(en) in $SOURCE_DIR. Starte Kopiervorgang..."

# 4. Dateien kopieren und korrekte Berechtigungen setzen
for filepath in "${SERVICE_FILES[@]}"; do
    filename=$(basename "$filepath")
    echo "  -> Kopiere $filename nach $SYSTEMD_DIR"
    
    cp "$filepath" "$SYSTEMD_DIR/"
    # systemd erwartet für Service-Dateien in der Regel die Rechte 644
    chmod 644 "$SYSTEMD_DIR/$filename"
done

# 5. systemd die neuen Dateien bekannt machen
echo "Lade systemd-Konfiguration neu (daemon-reload)..."
systemctl daemon-reload

# 6. Services aktivieren (Autostart) und sofort starten
echo "Aktiviere und starte die Services..."
for filepath in "${SERVICE_FILES[@]}"; do
    filename=$(basename "$filepath")
    
    echo "  -> Enable & Start: $filename"
    systemctl enable "$filename"
    systemctl start "$filename"
done

echo "Vorgang erfolgreich abgeschlossen!"