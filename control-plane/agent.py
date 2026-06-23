import subprocess
import requests

EAAS_ROOT = "/opt/eaas"

def check_watchdog():
    result = subprocess.getoutput("systemctl is-active eaas-storage-watchdog.service")
    return "active" in result

def check_docker():
    result = subprocess.getoutput("systemctl is-active docker")
    return "active" in result

def system_health():
    try:
        r = requests.get("http://localhost:8000/health", timeout=2)
        return r.status_code == 200
    except:
        return False

def recover():
    print("🧠 EAAS v3: Recovery triggered")

    if not check_watchdog():
        subprocess.call(["systemctl", "restart", "eaas-storage-watchdog.service"])

    if not system_health():
        subprocess.call(["bash", "/opt/eaas/start-eaas.sh"])

    if not check_docker():
        subprocess.call(["systemctl", "restart", "docker"])

def run():
    if not system_health():
        recover()
    else:
        print("✅ EAAS healthy")

if __name__ == "__main__":
    run()
