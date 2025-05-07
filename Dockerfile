# Dockerfile para el ETL con datos transformados
FROM python:3.9-slim

WORKDIR /app

# Copiar requirements e instalar dependencias
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copiar archivo CSV transformado
COPY datos_transformados.csv /data/datos_transformados.csv

# Comandos para usar el CSV en contenedores
CMD ["bash", "-c", "echo 'Datos transformados disponibles en /data/datos_transformados.csv' && python -c "import pandas as pd; df = pd.read_csv('/data/datos_transformados.csv'); print(df.head())""]
