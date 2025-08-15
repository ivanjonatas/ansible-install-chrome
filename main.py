from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import random

# Configuração
video_id = "nGFp4WLPHs4"
url = f"https://youtu.be/{video_id}"

options = Options()
options.add_argument("--headless")
options.add_argument("--disable-gpu")
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")

# Inicializar navegador
driver = webdriver.Chrome(options=options)
driver.get(url)
print("Página carregada:", driver.title)

# Aguardar um pouco
time.sleep(3)

# Scroll para baixo e cima
driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
time.sleep(3)
driver.execute_script("window.scrollTo(0, 0);")

# Tentar pular anúncio (se existir)
try:
    skip_ads_button = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.CLASS_NAME, 'ytp-ad-skip-button-container'))
    )
    skip_ads_button.click()
    print("Anúncio pulado.")
except:
    print("Nenhum anúncio para pular.")

# Tentar clicar no botão play (caso necessário)
try:
    play_button = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, '[data-title-no-tooltip="Play"]'))
    )
    play_button.click()
    print("Botão Play clicado.")
except:
    print("Nenhum botão Play necessário (vídeo pode já estar tocando).")

# Simular assistir por 30 segundos
sleep_time = random.randint(60, 90)

print(f"Assistindo por {sleep_time} segundos...")
time.sleep(sleep_time)

# Fechar navegador
driver.quit()
print("Navegador fechado.")
