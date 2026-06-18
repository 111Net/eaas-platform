import random
import time

def generate_fake_clients():
    return [
        {"name": "Alpha Energy Ltd", "usage": random.randint(50, 500)},
        {"name": "GreenCo Farms", "usage": random.randint(20, 300)},
        {"name": "Lagos Industrial Hub", "usage": random.randint(100, 900)}
    ]
