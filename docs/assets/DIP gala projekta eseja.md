# DIP kursa gala projekts "DIP Testbed Platforma"

Autors - Krišjānis Veinbahs, st. apl. nr. kv18042.
DIP Testbed platformas klienta "spiedpogas un LED" virtuālās saskarnes demo video - [https://youtu.be/TMztKONuCRU](https://youtu.be/TMztKONuCRU)  

## Gala darba apraksts
DIP kursa gala darba ietvaros tika izstrādāts universitātes kursa darbs. Šis projekts ir "Attālinātas aparatūras pieejas nodrošināšana digitālās projektēšanas kursā".  

Šī projekta ietvaros tika izstrādāta platforma, kas sastāv no vairākām apakšsistēmām, virtuālas saskarnes attālinātai mijiedarbībai ar aparatūru platformas ietvaros kā arī pāris digitāli projekti jeb programmaparatūra, lai testētu šo platformu un virtuālās saskarnes.

## Izstrādātās komponentes

Platforma šobrīdējā izstrādes brīdī sastāv no sekojošiem moduļiem:
- Aģenti, kas nodrošina fizisku savienojumu ar aparatūru
- Klienti, kas pārvalda un lieto platformu 
- Centralizēts serveris, kas nodrošina datu pārvaldību un komunikāciju starp aģentiem un klientiem
- Datubāze, ko izmanto centralizēts serveris datu uzturēšanai

Virtuālās saskarnes šobrīdējā izstrādes brīdī:
- Teksta saskarne, kas ļauj saņemt baitus heksadecimāla teksta formātā un tos sūtīt atpakaļ
- Spiedpogu un LED grafiskā saskarne, kas ļauj redzēt saņemtos baitus kā LED gaismas un sūtīt baitus izmantojot grafiskas spiedpogas

Programmaparatūras šobrīdējā izstrādes brīdī:
- `anvyl-uart-remote` Ievaddatu baitu inkrementēšanas programma, kas saņem baitus UART seriālajā portā, pieskaita tiem viens un sūta tos atpakaļ regulārā laika intervālā, kas strādā gan simulācijā
- `button-led-virtual-interface` Bitu šiftēšanas programmaparatūra, kas iestata un atcerās bitus baitā un ļauj ar specifisku spiedpogu (baitu) ievadīšanu pārvietot šos bitus baita ietvaros un regulāri tos sūta UART seriālajā portā, kas šobrīdējā izstrādes brīdī strādā tikai simulācijā un ne Anvyl attīstītājrīkā

## Izstrādes vides arhitektūra

Zemāk pievienots attēls - aparatūras un procesu komunikācijas topoloģiskā diagramma - kas ilustrē datorus un aparatūru kā arī procesus, kas tajos darbinās, kā arī komunikāciju starp šiem procesiem. Šī ilustrācija attēlo izstrādes procesa platformas arhitektūru.  

![Aparatūras un procesu komunikācijas topoloģiskā diagramma](https://i.imgur.com/aKlQ3FW.png)  

## `button-led-virtual-interface` programmaparatūras simulācija
Zemāk pievienotajā ilustrācijā redzamas signālu viļņfrontes simulējot programmaparatūru.  
Programmaparatūras ietvaros tiek ievadītas pogas, lai  
a) pabīdītu bitus "pa labi" un "pa kreisi", tad,  
b) lai nomainītu iesatatītos bitus uz   
    1) divu bitu modeli,   
    2) četru bitu modeli,   
    3) pabīdītu četru bitu modeli,   
    4) neviena bita modeli,   
    5) visu bitu baitā modeli.  

![Simulācija](https://i.imgur.com/GkG7f4d.png)  
    
Signāli:
- `LD[0-7]` - Gaismas, kas attēlo bitu modeļus baitā
- `r_Rx_Byte` - Simulācijas UART portā noparsētā ziņa jeb baits
- `buttons` - Ievadīto spiedpogu signāls
- `T19` - Saņemtais programmaparatūras signāls (spiegpogu)
- `T20` - Izvadītais programmaparatūras signāls (LED gaismu)
- `CLK` un `i_Clock` - Pulkstenis
- u.c.