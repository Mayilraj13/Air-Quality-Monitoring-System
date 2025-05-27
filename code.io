#include <SoftwareSerial.h>

#include <LiquidCrystal.h>

LiquidCrystal lcd(13, 12, 6, 5, 4, 3);
/*
 D13 ==> RS
GND  ==>   R/W
D12  ==> Enable
D6   ==> DB4
D5   ==> DB5
D4   ==> DB6
D3   ==> DB7
 
*/

float t = 0;
char data = 0;

String apiKey = "XBQDVORXXGAROWDW";

SoftwareSerial ser(8, 9); // RX, TX

void setup()

{

    Serial.begin(9600);

    ser.begin(9600);

    lcd.begin(16, 2);

    lcd.setCursor(0, 0);

    lcd.print(" Welcome");

    lcd.setCursor(0, 1);

    lcd.print("   To   ");

    delay(3000);


    lcd.clear();

    lcd.setCursor(0, 0);

    lcd.print("     AIR");

    lcd.setCursor(0, 1);

    lcd.print("QUALITY MONITOR");

    delay(3000);

    ser.println("AT");

    delay(1000);

    ser.println("AT+GMR");

    delay(1000);

    ser.println("AT+CWMODE=3");
    /*
    1 = Station mode (client)
    2 = AP mode (host)
    3 = AP + Station mode (ESP8266 has a dual mode) 
    */
    delay(1000);

    ser.println("AT+RST");

    delay(5000);

    ser.println("AT+CIPMUX=1");
    /*

    0: Single connection
    1: Multiple connections (MAX 4)
 
*/
    delay(1000);

    String cmd = "AT+CWJAP=\"SSID\",\"PASSWORD\"";

    ser.println(cmd);

    delay(1000);
    ser.println("AT+CIFSR");
    delay(1000);
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("      WIFI");
    lcd.setCursor(0, 1);
    lcd.print("   CONNECTED");
}
void loop()
{
    delay(1000);
    t = analogRead(A0);
    Serial.print("Airquality = ");
    Serial.println(t);
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Air Qual: ");
    lcd.print(t);
    lcd.print(" PPM ");
    lcd.setCursor(0, 1);
    if (t <= 500) {
        lcd.print("Fresh Air");
        Serial.print("Fresh Air ");
    }
    else if (t >= 500 && t <= 1000) {
        lcd.print("Poor Air");
        Serial.print("Poor Air");
    }
    else if (t >= 1000)
    {
        lcd.print("Very Poor");
        Serial.print("Very Poor");
    }
    delay(10000);
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("  SENDING DATA");
    lcd.setCursor(0, 1);
    lcd.print("    TO CLOUD");
    esp_8266();
}
void esp_8266() {
    String cmd = "\nAT+CIPSTART=4,\"TCP\",\"";

    AT + CIPSTART = id, type, addr, port

    id: 0 - 4, id of connection
    type: String, “TCP” or“ UDP”
    addr: String, remote IP
    port: String, remote port
    cmd += "184.106.153.149";
    cmd += "\",80";
    ser.println(cmd);
    Serial.println(cmd);
    if (ser.find("Error")) {
        Serial.println("AT+CIPSTART error");
        return;
    }
    String getStr = "GET /update?api_key=";
    getStr += apiKey;
    getStr += "&field1=";
    getStr += String(t);
    getStr += "\r\n\r\n";
    cmd = "AT+CIPSEND=";
    cmd += String(getStr.length());
    ser.println(cmd);
    Serial.println(cmd);
    delay(1000);
    ser.print(getStr);
    Serial.println(getStr);
    delay(17000);
}
