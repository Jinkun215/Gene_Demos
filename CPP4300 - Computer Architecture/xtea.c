unsigned long key[4] = {0xB03F8963, 0xC8AED3D5, 0xA5BE3796, 0x7E4BC438};


unsigned long v[2] = {0xAF8823DC, 0x8F383F3A};

void setup()
{
  Serial.begin(9600);


  encipher(32, v, key);
  Serial.print("Encrypt: ");
  Serial.print(v[1], HEX);
  Serial.println(v[0], HEX);
  Serial.print("Encrypt: ");
  decipher(32, v, key);
  Serial.print(v[1], HEX);
  Serial.println(v[0], HEX);
}
void loop()
{
}

void encipher(unsigned int num_rounds, uint32_t v[2], uint32_t const key[4]) {
  unsigned int i;
  uint32_t v0 = v[0], v1 = v[1], sum = 0, delta = 0x9E3779B9;
  for (i = 0; i < num_rounds; i++) {
    v0 += (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + key[sum & 3]);
    sum += delta;
    v1 += (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + key[(sum >> 11) & 3]);
  }
  v[0] = v0; v[1] = v1;
}

void decipher(unsigned int num_rounds, uint32_t v[2], uint32_t const key[4]) {
  unsigned int i;
  uint32_t v0 = v[0], v1 = v[1], delta = 0x9E3779B9, sum = delta * num_rounds;
  for (i = 0; i < num_rounds; i++) {
    v1 -= (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + key[(sum >> 11) & 3]);
    sum -= delta;
    v0 -= (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + key[sum & 3]);
  }
  v[0] = v0; v[1] = v1;
}