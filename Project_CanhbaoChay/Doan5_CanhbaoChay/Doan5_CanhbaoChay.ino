#include <ESP8266WiFi.h>
#include "FirebaseESP8266.h" 
#include <DNSServer.h>
#include <SD.h>
#include <WiFiManager.h>
#include <ESP8266WebServer.h>
#include "ArduinoJson.h"
#include <SimpleKalmanFilter.h>
#include <LiquidCrystal_I2C.h>
#include <Wire.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <SoftwareSerial.h>
#define ONE_WIRE_BUS D6
#define FIREBASE_HOST "https://appflutterdoan5-default-rtdb.firebaseio.com/" //Without http:// or https:// schemes
#define FIREBASE_AUTH "7fJICJWUH7ELM4U4TbwqVU63MAjoIAx5ZbmCxY5u" 
OneWire oneWire(ONE_WIRE_BUS);  
DallasTemperature sensors(&oneWire);
SimpleKalmanFilter bo_loc(2, 2, 0.001);
LiquidCrystal_I2C lcd(0x27,16,2); 
WiFiManager wifiManager;
SoftwareSerial mySerial(1,3);
// Khai báo các chân kết nối
const int mq2Pin = A0; //A0
const int buzzerPin = 15; //D8
const int ledPin1 = 16; //D0
const int ledPin2 = 14; //D5
const int button1 = 2; //D4
const int button2 = 0; //D3
const int buzzerPin2 = 13; //D7

// Giá trị ngưỡng cho mức khí độc
int smokeThreshold = 400;
bool cookingMode = true;
bool buttonState1 = false;
bool buttonState2 = false;
unsigned long timeDelay = millis();

FirebaseData firebaseData;
String path = "";

String SDT = "0886371936";
int sms;

void updateSerial()
{
  delay(500);
  while (Serial.available())
  {
    mySerial.write(Serial.read());//Forward what Serial received to Software Serial Port
  }
  while (mySerial.available())
  {
    Serial.write(mySerial.read());//Forward what Software Serial received to Serial Port
  }
}

//void init_sim800(){
//  delay(18000);
//GSMSerial.println("AT");delay(1500);// ;KIEM TRA DUONG TRUYEN
//GSMSerial.println("AT+CMGF=1"); delay(1500);/// DINH DANG DU LIEU KIEU TEXT
//GSMSerial.println("AT+CNMI=2,2,0,0,0"); delay(1500);// THIET LAP THONG BAO CHO TRUYEN NHAN
//GSMSerial.println("AT+CSAS"); delay(1500);//LUU THIET LAP
//}

void setup() {
  // Khởi tạo cổng Serial
  mySerial.begin(9600);
  Serial.begin(9600);
  Serial.println("Initializing..."); 
  delay(1000);
  // Khởi tạo chân kết nối cho các thiết bị
  pinMode(mq2Pin, INPUT);
  pinMode(buzzerPin, OUTPUT);
  pinMode(buzzerPin2, OUTPUT);
  pinMode(button1, INPUT_PULLUP);
  pinMode(button2, INPUT_PULLUP);
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
  sensors.begin(); 
  wifiManager.resetSettings();
  
  if (!wifiManager.autoConnect("AutoConecterESP8266")) {
    Serial.println("Failed to connect, we should reset as see if it connects");
    delay(3000);
    ESP.restart();
    delay(5000);
  }
  
  while(WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(500);
  }

  Serial.println("connected...yeey :)");
  Serial.println("local ip");
  Serial.println(WiFi.localIP());

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);// Kết nối tới firebase
  Firebase.reconnectWiFi(true);
  
  Wire.begin(D2,D1);
  lcd.init();
  lcd.clear();
  lcd.backlight();
  lcd.setCursor(0,0);
  lcd.print("  SMOKE SENSOR ");
  delay(1000);
  lcd.setCursor(0,1);
  lcd.print("  WARNING UP ! ");
  delay(3000); // allow the MQ-6 to warm up
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("S=");
  lcd.setCursor(9,0);
  lcd.print("T=");
  Firebase.setBool(firebaseData, "/TUDONG/BaoChayTD", cookingMode);
}


// Hàm bật, tắt còi
ICACHE_RAM_ATTR void Coi(){
  if(millis() - timeDelay > 200){
    digitalWrite(buzzerPin2, !digitalRead(buzzerPin2));
    buttonState1 = true;
    timeDelay = millis();
  }
}

ICACHE_RAM_ATTR void TuDong(){
  if ((millis() - timeDelay) > 200) {
    cookingMode = !cookingMode;
    buttonState2 = true;
    timeDelay = millis();
  }
}

//void Gsm_MakeSMS(String comment){
//  GSMSerial.print("AT+CMGS=\""); //gui tin nhan
//  GSMSerial.print(SDT);
//  GSMSerial.print("\"\r\n");
//  delay(3000);
//  GSMSerial.print(comment);
//  GSMSerial.prinzzzzzzt((char)26); // Gui Ctrl+Z hay 26 de ket thuc noi dung tin nhan va gui tin di
//  delay(3000); 
//}

void loop() {
  // Đọc giá trị từ cảm biến MQ2
  int smoke = analogRead(mq2Pin);
  smoke = bo_loc.updateEstimate(smoke);
  sensors.requestTemperatures(); 
  // In giá trị lên Serial Monitor để theo dõi
  
  lcd.setCursor(2,0);
  lcd.print(smoke);
  lcd.print("ppm");
  
  lcd.setCursor(11,0);
  lcd.print(sensors.getTempCByIndex(0));
//  lcd.print("°C");
  
  Serial.print("Nhiet Do: ");
  Serial.print(sensors.getTempCByIndex(0));
  Serial.print("°C  |");
  Serial.print("  Khoi: ");
  Serial.print(smoke);
  Serial.println("ppm");
 
  attachInterrupt(button2, Coi, FALLING);
  attachInterrupt(button1, TuDong, FALLING);

  mySerial.println("AT"); //Once the handshake test is successful, it will back to OK
  updateSerial();
  mySerial.println("AT+CMGF=1"); // Configuring TEXT mode
  updateSerial();
  mySerial.println("AT+CMGS=\"+84886371936\"");//change ZZ with country code and xxxxxxxxxxx with phone number to sms
  updateSerial();
  mySerial.print("Canh bao chay !!!"); //text content sms 
  updateSerial();
  mySerial.write(26);
  delay(1000);
  
  if (cookingMode) {
    if (smoke > smokeThreshold) {
      tone(buzzerPin, 1000);
      digitalWrite(ledPin1, HIGH);
      digitalWrite(ledPin2, LOW);
      lcd.setCursor(2,1);
      lcd.print("  CANH BAO !     ");
    } else {
      noTone(buzzerPin);
      digitalWrite(ledPin1, LOW);
      digitalWrite(ledPin2, LOW);
      lcd.setCursor(2,1);
      lcd.print("  ON DINH      ");
    }
  } else {
    if (smoke > 0) {
      noTone(buzzerPin);
      digitalWrite(ledPin1, LOW);
      digitalWrite(ledPin2, HIGH); 
      lcd.setCursor(2,1);
      lcd.print("CANH BAO GIA !    ");
//      if(sms==0){
//        Gsm_MakeSMS("Cảnh báo giả !");
//        sms=1;// giá trị này giúp việc gửi tn chỉ diễn ra 1 lần, bạn có thể tùy tỉnh
//      }
    } 
  }
  
  /////////////////////////////////////////////////////////////////////// Ghi Firebase //////////////////////////////////////////////////////////
  
  Firebase.setInt(firebaseData, path + "/TUDONG/Khoi", smoke);
  Firebase.setFloat(firebaseData, path + "/TUDONG/Nhietdo", sensors.getTempCByIndex(0));
  
  if (buttonState1){
    Firebase.setBool(firebaseData, path + "/TUDONG/BaoChayTC", digitalRead(buzzerPin2));
    buttonState1 = false;
  }
  
  if (buttonState2){
    Firebase.setBool(firebaseData, path + "/TUDONG/BaoChayTD", cookingMode);
    buttonState2 = false;
  }
  
  
  ////////////////////////////////////////////////////////////////////////// Đọc từ firebase ///////////////////////////////////////////////////////////////
  
  if (Firebase.getBool(firebaseData, path + "/TUDONG/BaoChayTC") == true){
    bool state1 = firebaseData.to<bool>();
    if(state1 == true)  digitalWrite(buzzerPin2, HIGH);
    else  digitalWrite(buzzerPin2, LOW);
  }

  if(Firebase.getBool(firebaseData, path + "/TUDONG/BaoChayTD") == true){
    bool state2 = firebaseData.to<bool>();
    cookingMode = state2;
  }
}
