#include <EtherCard.h>
#include <OneWire.h>

#define CS	10//PB2	ENC28J60
#define MOSI	11//PB3	ENC28J60
#define MISO	12//PB4	ENC28J60
#define SCK	13//PB5	ENC28J60
#define TX	0//PD0	AT89C2051 RX (2)
#define N220	2//PD2	MOD220
#define F220	3//PD3	MOD220
#define T220	4//PD4	MOD220
#define W1PIN	16//PC2	1WIRE
#define KEY	17//PC3	KEY
           
OneWire ds (W1PIN);
typedef const uint8_t DeviceAddress[8];
DeviceAddress rom[9] = { 
{0x28,0x13,0x39,0x0E,0x06,0x00,0x00,0xAF},
{0x28,0x8A,0xB8,0x0C,0x06,0x00,0x00,0x89},
{0x28,0xA3,0x98,0x0D,0x06,0x00,0x00,0xDE},
{0x28,0xA7,0xC6,0x0C,0x06,0x00,0x00,0xBA},
{0x28,0x9F,0xA9,0x0E,0x06,0x00,0x00,0x8F},
{0x28,0xB2,0xEE,0xA9,0x04,0x00,0x00,0xAB},
{0x28,0xF3,0x3D,0xA9,0x04,0x00,0x00,0xF9},
{0x28,0x61,0x64,0x11,0x8D,0x9E,0xD7,0xEA},
{0x28,0x61,0x64,0x11,0x8D,0x8C,0xFF,0x76},
};
byte bufData[9];
int temp[9];
byte tx = 0;
const byte dt[] = {0,6,12,19,25,31,38,44,50,56,62,69,75,81,88,94};
const byte df[] = {0x20,0x24,0x27,0x2b,0x69,0x64,0x67,0x6b};
byte cfg[] = {25,43,46,55,90};
char var [56];

const byte mymac[] = { 0x00,0x01,0x02,0x03,0x04,0x05 };
const char website[] PROGMEM = "yfb7905i.bget.ru";
bool link = 0;
bool eth = 0;
byte Ethernet::buffer[372];

byte p = 1;
volatile byte fl = 0;

static void my_callback (byte status, word off, word len) {
 if (len == 197) {
 int c = off+len-19;
 Ethernet::buffer[off+len] = 0;
 Serial.print("CFG: ");
 Serial.println((const char*) Ethernet::buffer + c);
 for(byte i=0;i<5;i++) cfg[i] = (Ethernet::buffer[i+i+i+c+5]&15)*10 + (Ethernet::buffer[i+i+i+c+6]&15);
 Serial.print("^~~");
 for(byte i=0;i<4;i++) Serial.write(Ethernet::buffer[i+c]);
 indt();
}}

void IntD2 () {
if (fl) TXword(p);
fl=0;
}

//---------------SETUP--------------------------------
void setup() {
PORTC = 8;
PORTD|=4;
cli();
TIMSK1 = TIMSK2 = TCCR1A = TCCR2B = 0;
TCCR2A = 0x12;
OCR2A = OCR2B = 3;
TCCR2B = 1;
sei();

Serial.begin(115200);
Serial.println("\r\nBoiler-auto started");
 if (!ether.begin(sizeof Ethernet::buffer, mymac)) {
 Serial.println("ENC28J60 not found!");
 while (1);
 }

 if (!ds.reset()) {
 Serial.println("No 1WIRE sensors!");
 while (1);
 }
delay (500);
link = !ether.isLinkUp();
attachInterrupt(0,IntD2,FALLING);
}

//------------------LOOP-----------------------------
void loop() {
ds.reset();
ds.write(0xCC, 1);
ds.write(0x44, 1);
delayLoop(1000);
byte j=0;
 for ( byte i=0; i<9; i++) {
 ds.reset();
 ds.select(rom[i]);
 ds.write(0xBE, 1);
 ds.read_bytes(bufData, 9);
  if ( (bufData[0] | bufData[1]) != 0  &&  OneWire::crc8(bufData, 8) == bufData[8] ) {
  temp[i] = int(bufData[0]) | int(bufData[1] << 8);
  }
  if (temp[i]>=0) {
  var[j] = (temp[i] >> 4) / 10 | '0';
  var[j+1] = (temp[i] >> 4) % 10 | '0';
  } else {
  temp[i] = -temp[i];
  var[j] = '-';
  var[j+1] = (temp[i] >> 4) & 15 | '0';
  }
 var[j+2] = '.';
 var[j+3] = dt[temp[i] & 15] / 10 | '0';
 var[j+4] = dt[temp[i] & 15] % 10 | '0';
 var[j+5] = '+';
 j+=6;
 }
byte B = byte(temp[0] >> 4);
byte O = byte(temp[5] >> 4);
byte H = byte(temp[6] >> 4);
byte F = byte(temp[8] >> 4);
bool FI = F >= cfg[3];
bool PO = (B >= cfg[0] && H < cfg[0] && (!FI || O >= cfg[1])) || B >= cfg[4];
bool PB = FI && O < cfg[3] && (!PO || O < cfg[2]);
var[54] = (FI << 2)|(PO << 1)|PB|'0';
var[55] = 0;
Serial.println(var);
 if (link && eth) {
 ether.browseUrl(PSTR("/log.php?var="), var, website, PSTR("User-Agent: Mozilla/5.0"), my_callback);
 } else {
 indnt();
 }
p^=1;
if (fl) Serial.println("Error nul detector");
fl=1;
delayLoop(5000);
}

void delayLoop(uint32_t delayTime) {
uint32_t timerkey = millis();
uint32_t timer = timerkey + delayTime;
 while (millis() < timer) {
 ether.packetLoop(ether.packetReceive());
  if(((Serial.available() > 0 && Serial.read() == 0x0d) | !digitalRead(KEY)) && millis() >= timerkey) {
  tx++;
  if(tx>8) tx=0;
  indnt();
  timerkey = millis() + 200;
  timer+=200;
  }

  if(link != ether.isLinkUp()) {
  link = ether.isLinkUp();
  Serial.print("Link is ");
   if(link) {
   Serial.println("UP");
    if(!eth) {
     if(ether.dhcpSetup()) {
     ether.printIp("IP: ", ether.myip);
     ether.printIp("GW: ", ether.gwip);
     ether.printIp("DNS: ", ether.dnsip);
      if(ether.dnsLookup(website)) {
      ether.printIp("SRV: ", ether.hisip);
      eth=1;
      } else {
      Serial.println("DNS failed!");
      }
     } else {
     Serial.println("DHCP failed!");
   }}} else {
   Serial.println("DOWN");
}}}}

void indnt() {
Serial.print("^~~");
Serial.write(tx|0x30);
Serial.write(' ');
Serial.write(' ');
Serial.write(' ');
indt();
}

void indt() {
Serial.write(df[var[54]&15]);
byte j = tx * 6;
Serial.write(var[j]);
Serial.write(var[j+1]&0x1f);
Serial.write(var[j+3]);
Serial.write(var[j+4]);
Serial.println();
}

void TXword(byte v) {
DDRD|=8;
_delay_loop_2(16000000/4/38400-2);
 for (byte i=0;i<8;i++) {
 DDRD = DDRD&0xf7|((v&1)<<3);
 _delay_loop_2(16000000/4/38400-2);
 DDRD^=8;
 _delay_loop_2(16000000/4/38400-2);
 v>>=1;
 }
DDRD&=0xf7;
_delay_loop_2(16000000/4/38400-2);
}
