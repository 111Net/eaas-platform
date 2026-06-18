from app.db.database import SessionLocal
from app.models.models import Provider, Client, Device

db = SessionLocal()

# -------------------
# PROVIDERS
# -------------------
providers = [
    Provider(provider_code="P001", company_name="SolarGrid Energy Ltd", contact_person="Adewale Johnson", email="adewale.johnson@solargrid-demo.com", phone="+2348001001001", service_type="Solar Installation"),
    Provider(provider_code="P002", company_name="GreenVolt Solutions Ltd", contact_person="Chika Okafor", email="chika.okafor@greenvolt-demo.com", phone="+2348001001002", service_type="Solar & Battery Systems"),
    Provider(provider_code="P003", company_name="BrightPower Technologies", contact_person="Musa Ibrahim", email="musa.ibrahim@brightpower-demo.com", phone="+2348001001003", service_type="Smart Metering"),
    Provider(provider_code="P004", company_name="EcoSun Services Ltd", contact_person="Kemi Adebayo", email="kemi.adebayo@ecosun-demo.com", phone="+2348001001004", service_type="Solar Maintenance"),
    Provider(provider_code="P005", company_name="Nova Energy Systems", contact_person="Emeka Nwosu", email="emeka.nwosu@novaenergy-demo.com", phone="+2348001001005", service_type="Energy-as-a-Service"),
]

# -------------------
# DEVICES
# -------------------
devices = [
    Device(device_code="D001", device_type="ESP32 Smart Meter", manufacturer="Espressif", connectivity="WiFi"),
    Device(device_code="D002", device_type="Eastron SDM120", manufacturer="Eastron", connectivity="Modbus RTU"),
    Device(device_code="D003", device_type="Eastron SDM630", manufacturer="Eastron", connectivity="Modbus RTU"),
    Device(device_code="D004", device_type="Hybrid Inverter", manufacturer="Deye", connectivity="WiFi"),
    Device(device_code="D005", device_type="Solar Inverter", manufacturer="Growatt", connectivity="WiFi"),
    Device(device_code="D006", device_type="Battery Monitoring Unit", manufacturer="Pylontech", connectivity="RS485"),
    Device(device_code="D007", device_type="Smart Energy Monitor", manufacturer="Shelly", connectivity="WiFi"),
    Device(device_code="D008", device_type="ESP32 Gateway", manufacturer="Espressif", connectivity="WiFi/Ethernet"),
    Device(device_code="D009", device_type="Battery Controller", manufacturer="Victron", connectivity="Bluetooth"),
    Device(device_code="D010", device_type="Smart Meter", manufacturer="Custom EaaS", connectivity="MQTT"),
]

# -------------------
# INSERT
# -------------------
db.add_all(providers)
db.add_all(devices)

db.commit()
db.close()

print("EAAS SEED COMPLETE")
