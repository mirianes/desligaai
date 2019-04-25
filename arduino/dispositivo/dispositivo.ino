#include <EmonLib.h>
#include <ESP8266WiFi.h>
#include <PubSubClient.h> 

//atualize SSID e senha WiFi
const char* ssid = "IBMHackatruckIoT";
const char* password = "IOT2017IBM";

//D4 only for Lolin board
#define LED_BUILTIN D4

EnergyMonitor emon1;              // Variável para usar a biblioeca emonLib
int rede = 220.0;                 // Tensao da rede eletrica Nordeste
int pino_sct = 2;                 // Pino do sensor SCT entrada (analógica) do Arduino.

//Atualize os valores de Org, device type, device id e token
#define ORG "fft8od"
#define DEVICE_TYPE "NODE-MCU"
#define DEVICE_ID "node-mcu-planta"
#define TOKEN "12345678"


//broker messagesight server
char server[] = ORG ".messaging.internetofthings.ibmcloud.com";
char topic[] = "iot-2/evt/status/fmt/json";
char authMethod[] = "use-token-auth";
char token[] = TOKEN;
char clientId[] = "d:" ORG ":" DEVICE_TYPE ":" DEVICE_ID;


float Irms = 0.0;
char IrmsString[6];
float potencia = 0.0;
char potenciaString[6];


WiFiClient wifiClient;
PubSubClient client(server, 1883, NULL, wifiClient);


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
}

void serialPrintResults(String payload, int length, float Irms, float potencia) {
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

  ValorADC = analogRead(pino_sct);   //978 -> 3,3V
  Serial.print("[Leitura ADC] ");
  Serial.println(ValorADC);

  delay(1000);
}

void loop() {

  //Checa se a conexão caiu
  if (!!!client.connected()) {
    Serial.print("Reconnecting client to ");
    Serial.println(server);
    while (!!!client.connect(clientId, authMethod, token)) {
      Serial.print(".");
      delay(500);
    }
    Serial.println();
  }

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
  String payload = "{\"d\":{\"corrente\":\"" + String(IrmsString) + "\" , \"potencia\":\"" + String(potenciaString) + "\"}}";
  length = payload.length();

  //Função para mostrar os resultados no serial monitor
  serialPrintResults(payload, length, Irms, potencia);

  if (client.publish(topic, (char*) payload.c_str())) {
    Serial.println("Publish ok");
    digitalWrite(LED_BUILTIN, LOW);
    delay(500);
    digitalWrite(LED_BUILTIN, HIGH);
    delay(500);
  } else {
    Serial.println("Publish failed");
    Serial.println(client.state());
  }
}
