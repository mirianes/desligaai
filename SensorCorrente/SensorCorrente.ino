//Programa : Medidor de energia elétrica com Arduino e SCT-013
//Autor : FILIPEFLOP
 
//Baseado no programa exemplo da biblioteca EmonLib
 
#include "EmonLib.h" 
 
EnergyMonitor emon1;
 
//Tensao da rede eletrica Nordeste
int rede = 220.0;
//Pino do sensor SCT entrada (analógica) do Arduino.
int pino_sct = 1;
//Porta ligada ao pino IN1 do modulo
int porta_rele1 = 7;
//Porta ligada ao pino IN2 do modulo
int porta_rele2 = 8;

 
void setup() 
{
  Serial.begin(9600);   
  //Pino, calibracao - Cur Const= Ratio/BurdenR. 1800/62 = 29. 
  emon1.current(pino_sct, 29);
  //Define pinos para o rele como saida
  pinMode(porta_rele1, OUTPUT); 
  pinMode(porta_rele2, OUTPUT);
} 
  
void loop() 
{ 
  //Calcula a corrente  
  double Irms = emon1.calcIrms(1480);
  //Mostra o valor da corrente
  Serial.print("Corrente : ");
  Serial.print(Irms); // Irms
   
  //Calcula e mostra o valor da potencia
  Serial.print(" Potencia : ");
  Serial.println(Irms*rede);
  delay(1000);

  digitalWrite(porta_rele1, LOW);  //Liga rele 1
  digitalWrite(porta_rele2, HIGH); //Desliga rele 2
  delay(2000);
  digitalWrite(porta_rele1, HIGH); //Desliga rele 1
  digitalWrite(porta_rele2, LOW);  //Liga rele 2
  delay(2000);
}
