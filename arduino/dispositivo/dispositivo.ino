#include <EmonLib.h>    // https://www.arduinolibraries.info/libraries/emon-lib
#include <ESP8266WiFi.h>  
#include <PubSubClient.h> 
#include <ArduinoJson.h> // https://github.com/bblanchon/ArduinoJson/releases/tag/v5.0.7


//atualize SSID e senha WiFi
const char* ssid = "IBMHackatruckIoT";
const char* password = "IOT2017IBM";

//D4 only for Lolin board
#define LED_BUILTIN D4

EnergyMonitor emon1;              // Variável para usar a biblioeca emonLib
int rede = 220.0;                 // Tensao da rede eletrica Nordeste
int pino_sct = A0;                // Pino do sensor SCT entrada (analógica) do Arduino.
int porta_rele = D1;              // Controle do rele

//Atualize os valores de Org, device type, device id e token
#define ORG "mf1d9p"
#define DEVICE_TYPE "nodemcu"
#define DEVICE_ID "nodemcu09"
#define TOKEN "12345678"


//broker messagesight server
char server[] = ORG ".messaging.internetofthings.ibmcloud.com";
char topic[] = "iot-2/evt/status/fmt/json";
const char cmdTopic[] = "iot-2/cmd/rele/fmt/json";
char authMethod[] = "use-token-auth";
char token[] = TOKEN;
char clientId[] = "d:" ORG ":" DEVICE_TYPE ":" DEVICE_ID;


float Irms = 0.0;
char IrmsString[6];
float potencia = 0.0;
char potenciaString[6];
bool statusRele = false;
String statusDispositivo = "1";


WiFiClient wifiClient;

void callback(char* topic, byte* payload, unsigned int payloadLength) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < payloadLength; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();

  // Switch on the LED if an 1 was received as first character
  if (payload[0] == '1') {
    digitalWrite(porta_rele, HIGH);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because
    // it is acive low on the ESP-01)
    statusDispositivo = "0";
    
  } else {
    digitalWrite(porta_rele, LOW);  // Turn the LED off by making the voltage HIGH
    statusDispositivo = "1";
  }
  Serial.println("CALLBACK");
}

PubSubClient client(server, 1883, callback, wifiClient);


void setup() {
  Serial.begin(115200);
  Serial.println();
  Serial.println("Iniciando...");


  Serial.print("Conectando na rede WiFi "); Serial.print(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("[INFO] Conectado WiFi IP: ");
  Serial.println(WiFi.localIP());

  //Pino, calibracao - Cur Const= Ratio/BurdenR. 1800/62 = 29. 
  emon1.current(pino_sct, 29);
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(porta_rele, OUTPUT);

  mqttConnect();
}

void serialPrintResults(String payload, int length) {
  int ValorADC;

  Serial.print(F("\nData length: "));
  Serial.println(length);

  Serial.print("Sending payload: ");
  Serial.println(payload);

  //Mostra o valor da corrente
  Serial.print("Corrente : ");
  Serial.print(Irms); // Irms

  //Calcula e mostra o valor da potencia
  Serial.print(" Potencia : ");
  Serial.println(potencia);

  //Serial.print("Status: ");
  //Serial.println(statusDispositivo);

  delay(1000);
}

void mqttConnect() {
  //Checa se a conexão caiu
  if (!!!client.connected()) {
    Serial.print("Reconnecting client to ");
    Serial.println(server);
    while (!!!client.connect(clientId, authMethod, token)) {
      Serial.print(".");
      delay(500);
    }
    if (client.subscribe(cmdTopic)) {
      Serial.println("subscribe to responses OK");
    } else {
      Serial.println("subscribe to responses FAILED");
    }
  }
}


void controlPower() {
  // Informa para o usuário se o dispositivo está ligado ou desligado
  if(statusRele) 
  {
    statusDispositivo = "1";
    statusRele = false;
    digitalWrite(porta_rele, LOW); //Desliga rele
    delay(1000);
   
  } 
  
  else 
  {
    statusDispositivo = "0";
    statusRele = true;
    digitalWrite(porta_rele, HIGH); //Liga rele
    delay(1000);
  }
}

void publishData() {

    //Calcula a corrente  
  Irms = emon1.calcIrms(1480);
  potencia = Irms * rede;
  
  // Conversao Floats para Strings
  char TempString[32];  //  array de character temporario

  // dtostrf( [Float variable] , [Minimum SizeBeforePoint] , [sizeAfterPoint] , [WhereToStoreIt] )
  dtostrf(Irms, 2, 1, TempString);
  String IrmsString =  String(TempString);
  dtostrf(potencia, 2, 1, TempString);
  String potenciaString = String(TempString);
  // Prepara JSON para IOT Platform
  int length = 0;

  //Envia o Json 
  String payload = "{\"d\":{\"corrente\":\"" + String(IrmsString) + "\" , \"potencia\":\"" + String(potenciaString) + "\" , \"status\":\"" + String(statusDispositivo) + "\"}}";
  length = payload.length();

  //Função para mostrar os resultados no serial monitor
  serialPrintResults(payload, length);
    
    if (client.publish(topic, (char*) payload.c_str())) {
    Serial.println("Publish ok");
    //digitalWrite(LED_BUILTIN, LOW);
    delay(500);
    //digitalWrite(LED_BUILTIN, HIGH);
    delay(500);
  } else {
    Serial.println("Publish failed");
    Serial.println(client.state());
  }
}

void loop() {
  if(!client.loop()) {
    mqttConnect();  
  }
  //controlPower();
  publishData();
  
  
  /*Função para receber informação do app
   * getUserInfo(localization, status)
  */

}
