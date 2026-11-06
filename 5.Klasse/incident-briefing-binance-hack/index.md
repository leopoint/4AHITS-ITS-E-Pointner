---
title: "Incident-Report: Der Binance-Hack vom 29. Oktober 2026"
---

# Incident-Report: Der Binance-Hack vom 29. Oktober 2026

**Namen:** Martin Haberl, Leo Pointner  
**Klasse:** 5AHITS  
**Fach:** ITSE (IT-Sicherheit), Theorie  
**Datum des Briefings:** 27. November 2026  
**Stand der Recherche:** 6. November 2026 (die Untersuchung läuft noch, Zahlen können sich ändern)

---

## 1. Zusammenfassung

Am 29. Oktober 2026 stahlen Angreifer innerhalb von rund 20 Minuten Kryptowährungen im Wert von etwa 6,3 Milliarden US-Dollar aus den Hot Wallets von Binance, der größten Kryptobörse der Welt. Es ist der größte bekannte Krypto-Diebstahl überhaupt, rund viermal so groß wie der Bybit-Hack vom Februar 2025. Der Angriff begann Monate vorher mit Social Engineering: Ein Binance-Entwickler wurde über ein gefälschtes Bewerbungsgespräch dazu gebracht, Schadsoftware auf seinem Arbeitsrechner auszuführen. Von dort arbeiteten sich die Angreifer bis zum internen Signierdienst der Wallets vor und nutzten unter anderem die Ethereum-Funktion EIP-7702, um eine Hot Wallet an einen eigenen Smart Contract zu delegieren. Blockchain-Analysefirmen und das FBI schreiben den Angriff der nordkoreanischen Gruppe TraderTraitor (Teil des Lazarus-Umfelds) zu; Binance ersetzt die Verluste der Kundschaft aus eigenen Mitteln.

## 2. Zeitablauf

Alle Zeiten in UTC. Angaben stammen überwiegend aus dem Incident-Bericht von Binance, wie ihn CoinDesk und TheStreet wiedergeben.

| Zeitpunkt | Ereignis |
|---|---|
| Juni 2026 | Wallet-DevOps-Ingenieur „A" installiert auf der Suche nach einem KI-Coding-Tool eine manipulierte Homebrew-Version. Binance bemerkt das, tauscht den Laptop und ändert Zugangsdaten. Die Angreifer wissen nun aber, wer im Wallet-Team arbeitet. |
| September 2026 | Software-Ingenieur „B" wird auf einer seriösen Jobplattform von einem angeblichen „Projektleiter" angesprochen. Nach einem Video-Interview mit einer falschen HR-Person und einem zweiten Gespräch mit einem angeblichen CEO soll er eine Programmier-„Aufgabe" auf seinen Arbeitsrechner laden. |
| September/Oktober | Die Aufgabe enthält laut Binance Zero-Day-Malware, die den Endpoint-Schutz umgeht. Sie ersetzt das Tool `pyenv` durch eine manipulierte Version und baut eine Verbindung zu einem Server der Angreifer auf. |
| 20. Oktober | Über Rechner B übernehmen die Angreifer mithilfe eines internen KI-Tools von Binance die Rechner von A und eines weiteren Wallet-Ingenieurs „C". Auf A's Rechner finden sie ein Token, mit dem man Software auf Firmensysteme ausrollen kann. |
| 28. Oktober | Die Wallet des Angreifers wird über drei kleine Abhebungen von Tornado Cash (einem Mixer) mit Gebühren-Guthaben versorgt (laut TRM Labs). |
| 29. Okt., 17:15 | Login auf Rechner C. In 2 h 41 min rollen die Angreifer mit A's Zugangsdaten einen Container aus und starten ein Skript gegen den Wallet-Signierdienst. |
| 29. Okt., 20:05 | Erste Abflüsse: 233 Mio. XRP aus fünf Hot Wallets, danach SOL, OP und 18.270 BTC. |
| 29. Okt., ca. 20:20 | Über den Signierdienst wird eine EIP-7702-Delegation gesetzt. Die Hot Wallet „Binance 14" wird an einen Sweeper-Contract der Angreifer delegiert und in einer Transaktion geleert (u. a. ca. 167.000 ETH und 1,6 Mrd. USDT). |
| 29. Okt., ab 21:01 | Tether beginnt, Wallets der Angreifer einzufrieren, Circle folgt drei Minuten später. Binance stoppt Handel, Ein- und Auszahlungen. |
| 29. Okt., bis 23:56 | Trotz gestoppter Auszahlungen fließt weiter Geld ab, weil die Delegation on-chain liegt und nicht im Binance-System. Wegen der MPC-Architektur der Wallet ist ein Widerruf nur mit einem Sonderverfahren möglich. |
| 30. Okt., 00:10 | Binance entfernt die Delegation von der Wallet „Binance 14". Der Abfluss ist gestoppt. |
| 30. Okt. | TRM Labs und Chainalysis ordnen den Angriff TraderTraitor (Nordkorea) zu. Binance sagt zu, alle Verluste selbst zu tragen. |
| 31. Okt. | Das FBI veröffentlicht die Warnung „North Korea Responsible for $6 Billion+ Binance Attack" mit Wallet-Adressen. Binance meldet, dass rund 90–98 % der fehlenden Bestände bereits aufgefüllt sind. |
| 1. Nov. | Erste Auszahlungen (ETH, USDT, USDC) laufen wieder. |
| 3. Nov. | Binance stellt in einem Medienbriefing die Angriffskette vor (Fake-Jobinterview). |

## 3. Betroffene Organisation und Systeme

**Binance** ist nach Handelsvolumen die größte Kryptobörse der Welt. Geleitet wird sie von den Co-CEOs Richard Teng und Yi He; Gründer ist Changpeng „CZ" Zhao.

Betroffene Systeme:

- **Entwickler-Endgeräte** (Laptops von drei Ingenieuren, darunter zwei aus dem Wallet-Team)
- **Ein internes KI-Tool**, über das die Angreifer sich seitlich zu anderen Rechnern bewegten (Lateral Movement)
- **Deployment-Infrastruktur** (ein Token, mit dem man Container auf Produktivsysteme ausrollen konnte)
- **Der Wallet-Signierdienst**, der Transaktionen für die Hot Wallets signiert. Binance nutzt dafür MPC (Multi-Party Computation): Der private Schlüssel existiert nie vollständig an einem Ort.
- **Hot Wallets** auf zehn Blockchains (u. a. Ethereum, Bitcoin, TRON, XRP Ledger, Solana, Optimism, Arbitrum, Avalanche, Polygon)

**Hintergrund: Hot und Cold Wallet.** Eine Hot Wallet ist ständig online und kann Auszahlungen automatisch ausführen. Eine Cold Wallet wird offline aufbewahrt. Börsen halten nur einen Teil der Bestände „heiß", damit Kundenauszahlungen schnell gehen. Laut Binance waren Cold Wallets nicht betroffen; es wurde auch kein privater Schlüssel gestohlen.

## 4. Angriffsvektor und ausgenutzte Schwachstelle

**CVE:** keine. Es wurde keine klassische Softwarelücke mit CVE-Nummer ausgenutzt. Die verwendete Malware soll laut Binance einen unbekannten Zero-Day enthalten haben, der aber nicht öffentlich beschrieben ist. Die Analysefirma Phoenix Security ordnet die Schwachstellen den Klassen CWE-284 (Improper Access Control) und CWE-863 (Incorrect Authorization) zu.

Die Angriffskette Schritt für Schritt (nach MITRE-ATT&CK-Logik):

1. **Aufklärung:** Durch den Vorfall im Juni wussten die Angreifer, wer im Wallet-Team arbeitet.
2. **Initialer Zugriff durch Social Engineering:** Ein fingiertes Bewerbungsverfahren (Kampagne „Contagious Interview"/„Operation Dream Job", ein bekanntes Muster nordkoreanischer Gruppen) bringt Ingenieur B dazu, eine „Programmieraufgabe" auf dem Firmenrechner auszuführen.
3. **Ausführung und Persistenz:** Die Malware ersetzt `pyenv`, ein normales Entwickler-Werkzeug, durch eine manipulierte Version. Das ist unauffällig, weil Entwickler solche Tools ständig nutzen.
4. **Lateral Movement:** Über ein internes KI-Tool, das Zugriff auf andere Entwicklerrechner hatte, gelangen die Angreifer auf die Rechner der Wallet-Ingenieure A und C.
5. **Credential Access:** Auf Rechner A liegt ein Deployment-Token mit dauerhaften Rechten für Produktivsysteme.
6. **Missbrauch des Signierdienstes:** Mit dem Token wird ein Container ausgerollt, der Auszahlungen an den Signierdienst schicken darf. Der Dienst prüfte, *wer* anfragt, aber nicht, *ob die Transaktion sinnvoll ist*. Er signierte also, was ein „vertrauenswürdiger" Aufrufer verlangte.
7. **EIP-7702-Delegation:** EIP-7702 ist eine Ethereum-Erweiterung (seit dem Pectra-Upgrade 2025), mit der eine normale Wallet ihren Code an einen Smart Contract „delegieren" kann. Die Angreifer schickten 50 solcher Autorisierungen mit aufeinanderfolgenden Nonces in einer Transaktion; eine passte. Danach konnte ihr Sweeper-Contract die Wallet „Binance 14" direkt leeren. Weil diese Berechtigung auf der Blockchain liegt, half es nicht, die Auszahlungen in den Binance-Systemen abzuschalten.

**Kernproblem:** Nicht EIP-7702 selbst ist die Ursache, sondern dass ein kompromittierter Entwickler-Laptop dauerhafte Rechte bis zu einem Signierdienst hatte, der keine inhaltliche Plausibilitätsprüfung machte.

## 5. Täter und Motiv

- **Zuordnung:** TRM Labs („high confidence") und Chainalysis schreiben den Angriff der nordkoreanischen Gruppe **TraderTraitor** zu (auch Jade Sleet / UNC4899 genannt, Teil des Lazarus-Umfelds). Das FBI bestätigte dies am 31. Oktober öffentlich. Der Ermittler ZachXBT fand außerdem, dass Beute aus diesem Hack und aus einem Hack bei der Börse Bitget an derselben Adresse zusammenlief. Binance selbst nennt keinen Täter.
- **Belege für die Zuordnung:** typisches Vorgehen (Fake-Jobinterviews, Angriff auf Entwickler, schnelles Waschen über DeFi und Mixer), gleiche Muster wie beim Bybit-Hack 2025, den das FBI ebenfalls TraderTraitor zuschrieb.
- **Motiv:** finanziell. Nordkorea finanziert laut UN-Experten und US-Behörden einen erheblichen Teil seines Raketen- und Atomprogramms mit gestohlenen Kryptowährungen. Staatliche Hacker stehlen hier also für einen Staat, nicht für sich selbst.

## 6. Auswirkungen

**Finanziell**

- Gestohlen: ca. 6,3 Mrd. USD (Schätzungen 6,15–6,4 Mrd., je nach Firma und Kurszeitpunkt). Größter Einzelposten: Ethereum mit ca. 3,8 Mrd. USD; dazu 18.270 BTC (ca. 1,5 Mrd. USD).
- Eingefroren: ca. 2,7–2,85 Mrd. USD, vor allem Stablecoins (Tether ca. 1,77 Mrd. USDT, Circle ca. 825 Mio. USDC, dazu Ripple, World Liberty Financial und der Arbitrum Security Council).
- Weiterhin bei den Angreifern: nach TRM Labs rund 420.000 ETH und 18.270 BTC (ca. 2,4 Mrd. USD).
- Markt: Bitcoin fiel um rund 5 % auf unter 80.000 USD; Aktien von Coinbase und Robinhood gaben nach.

**Daten:** Nach bisherigem Stand wurden keine Kundendaten gestohlen. Es ging um Vermögenswerte, nicht um Daten.

**Betrieb:** Handel, Ein- und Auszahlungen wurden am 29. Oktober gestoppt. Auszahlungen liefen ab dem 1. November schrittweise wieder an. Eine zweite Ethereum-Hot-Wallet wurde vorsorglich pausiert, der Auszahlungsdienst neu aufgebaut.

## 7. Reaktion und Behebung

- **Eindämmung:** Stopp aller Auszahlungen, Bitte an Stablecoin-Herausgeber, die Beute einzufrieren (Tether reagierte innerhalb einer Stunde), Widerruf der EIP-7702-Delegation um 00:10 UTC.
- **Kundschaft schützen:** Binance trägt alle Verluste aus dem SAFU-Fonds („Secure Asset Fund for Users"), dem Futures-Versicherungsfonds, den eigenen Bitcoin-Reserven und dem Firmenvermögen. Bis 31. Oktober waren 90–98 % der fehlenden Bestände wieder aufgefüllt; ein aktualisierter Proof of Reserves soll das belegen.
- **Technische Behebung:** Neuaufbau des Wallet-Systems und des internen KI-Tools, Austausch der betroffenen Geräte, Sperrung aller Zugangsdaten der Ingenieure.
- **Untersuchung:** externe Sicherheitsfirmen und ein unabhängiges Security-Review; Zusammenarbeit mit FBI und US Secret Service, die Beute verfolgen.
- **Ankündigung:** ein Forschungsfonds zu KI-Sicherheit in Blockchain-Systemen. Binance gab an, 2026 bereits 57 nordkoreanische Angriffsversuche abgewehrt zu haben.

## 8. Lessons Learned und Gegenmaßnahmen

1. **Entwicklerrechner sind ein Angriffsziel ersten Ranges.** Auf Arbeitsrechnern dürfen keine fremden „Testaufgaben" ausgeführt werden. Dafür gibt es Sandboxen oder Wegwerf-VMs. Mitarbeitende brauchen Schulungen zu Fake-Recruiting.
2. **Keine dauerhaften Produktionsrechte auf Endgeräten.** Deployment-Token sollten kurzlebig sein, nur „just in time" vergeben werden und an ein zweites Gerät oder eine zweite Person gebunden sein (Vier-Augen-Prinzip).
3. **Segmentierung und Least Privilege für interne Tools.** Ein internes KI-Tool, das auf viele Rechner zugreifen kann, ist ein ideales Sprungbrett. Auch KI-Agenten brauchen minimale Rechte.
4. **Der Signierdienst muss die Absicht prüfen, nicht nur den Absender.** Regeln wie „nie an unbekannte Adressen", Betragsgrenzen pro Zeit (Velocity Limits / Circuit Breaker) und eine grundsätzliche Sperre für EIP-7702-Delegationen hätten den Schaden begrenzt.
5. **Weniger Geld in Hot Wallets und Aufteilung nach Chain.** Je weniger heiß liegt und je stärker es aufgeteilt ist, desto kleiner der maximale Schaden (Blast Radius).
6. **Notfallpläne für on-chain-Berechtigungen.** Binance musste feststellen, dass ein Stopp im eigenen System eine bereits gesetzte Delegation auf der Blockchain nicht aufhebt. Der Widerruf muss vorab geübt sein.
7. **Erkennung von Anomalien.** Die Angreifer waren monatelang im Netz. Monitoring auf ungewöhnliche Deployments und Logins (z. B. 17:15 UTC auf Rechner C) hätte sie früher entdecken können.

---

## Quellen

**Betroffene Organisation und Behörden**

- Binance: Incident-Updates auf X, 29.–31. Oktober 2026, <https://x.com/binance/status/2115993361517891592>, <https://x.com/binance/status/2116089661408108712>, <https://x.com/binance/status/2117626126214504729>
- Binance: Proof of Reserves, <https://www.binance.com/en/proof-of-reserves>
- FBI: „North Korea Responsible for $6 Billion+ Binance Attack", 31.10.2026, <https://www.fbi.gov/investigate/cyber/alerts/2026/north-korea-responsible-for-6-billion-binance-attack>

**IT-Security-Medien und Security-Firmen**

- BleepingComputer: „Binance links $6.3 billion crypto theft to compromised DevOps laptop", 30.10.2026, <https://www.bleepingcomputer.com/news/security/binance-links-63-billion-crypto-theft-to-compromised-devops-laptop/>
- Phoenix Security: „Binance $6.3B Hack: How a Compromised DevOps Laptop Reached the Hot-Wallet Signer (No CVE)", 2.11.2026, <https://phoenix.security/binance-hack-devops-laptop-hot-wallet-signer-eip-7702/>
- Cointelegraph: „North Korea linked to $6.3B Binance hack by crypto investigators" (mit Aussagen von TRM Labs, Chainalysis, ZachXBT, Blockaid), 30.10.2026, <https://cointelegraph.com/news/north-korea-linked-to-63b-binance-hack-by-crypto-investigators>
- CoinDesk: „North Korea-linked hackers infiltrated Binance for months before $6.3 billion hack", 3.11.2026, <https://www.coindesk.com/business/2026/11/03/binance-s-usd6-3-billion-hack-began-with-a-fake-job-interview-exchange-says>
- TheStreet/Yahoo Finance: „Binance says its $6.3 billion hack started with a fake job offer", 3.11.2026, <https://finance.yahoo.com/markets/crypto/articles/binance-says-6-3-billion-181834232.html>

**Nachrichtenmedien**

- ORF: „Kryptobörse gehackt: USA prüfen Vorwürfe gegen Nordkorea", 30.10.2026, <https://orf.at/stories/3446653/>
- CNBC: „$6.3 billion Binance hack is largest crypto theft on record", 29.10.2026, <https://www.cnbc.com/2026/10/29/circle-tether-freeze-funds-impacted-by-potential-binance-security-issue.html>
- Reuters: „Binance says 90% of stolen assets replenished", 31.10.2026, <https://www.reuters.com/legal/government/binance-says-90-stolen-assets-replenished-2026-10-31/>
- The Guardian: „Binance losses covered after hack, FBI blames North Korea", 1.11.2026, <https://www.theguardian.com/business/2026/nov/01/binance-losses-covered-hack-fbi-north-korea-cryptocurrency>
- Wikipedia: „2026 Binance hack" (nur zur Übersicht), <https://en.wikipedia.org/wiki/2026_Binance_hack>

---

## Mögliche Testfragen

**1. Wie verschafften sich die Angreifer den ersten Zugang zum Binance-Netzwerk, und warum war das so wirkungsvoll?**

> Durch Social Engineering: Ein Binance-Entwickler wurde über ein gefälschtes Bewerbungsverfahren dazu gebracht, eine „Programmieraufgabe" auf seinem Arbeitsrechner auszuführen, die Malware enthielt. Das war wirkungsvoll, weil Entwickler oft weitreichende Rechte haben, Code-Ausführung für sie normal ist und die Malware ein bekanntes Entwickler-Tool (`pyenv`) ersetzte und dadurch kaum auffiel.

**2. Was ist der Unterschied zwischen einer Hot Wallet und einer Cold Wallet, und welche war betroffen?**

> Eine Hot Wallet ist ständig online und kann Auszahlungen automatisch signieren; eine Cold Wallet wird offline aufbewahrt und ist dadurch viel schwerer angreifbar. Betroffen waren ausschließlich Hot Wallets von Binance auf zehn Blockchains.

**3. Warum konnte Binance den Abfluss nicht sofort stoppen, obwohl alle Auszahlungen deaktiviert wurden? Nenne eine Gegenmaßnahme.**

> Die Angreifer hatten über EIP-7702 eine Hot Wallet an ihren eigenen Smart Contract delegiert. Diese Berechtigung lag auf der Ethereum-Blockchain, nicht in Binances eigenen Systemen, und konnte wegen der MPC-Architektur nur mit einem Sonderverfahren widerrufen werden. Gegenmaßnahmen: EIP-7702-Delegationen im Signierdienst grundsätzlich sperren, Betragsgrenzen pro Zeitraum (Circuit Breaker) oder keine dauerhaften Produktionsrechte auf Entwickler-Laptops.

---

## Hinweis zur KI-Unterstützung

Recherche, Gliederung und erster Textentwurf dieses Reports wurden mit **Claude Opus 5.5** (Anthropic) erstellt. Das Team hat die Inhalte anhand der angegebenen Quellen geprüft und überarbeitet. Geschätzter KI-Anteil: 60%.
