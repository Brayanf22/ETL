import pandas as pd
from google.colab import files
from IPython.display import display
import subprocess

def transform_data(url):
    print("📥 Extrayendo datos desde la URL...")
    try:
        df = pd.read_csv(url, encoding='utf-8')
    except UnicodeDecodeError:
        df = pd.read_csv(url, encoding='utf-8-sig')

    print("✅ Datos extraídos correctamente")
    print("\n📋 TABLA ORIGINAL (primeras 5 filas):")
    display(df.head())

    # Transformación
    print("\n🔄 Transformando datos...")
    df = df.dropna(how='all')
    original_columns = df.columns.tolist()
    df.columns = [col.strip().lower().replace(" ", "_") for col in df.columns]

    df["anio_liberacion"] = 2025
    if 'month_of_release' in df.columns:
        df['month_of_release'] = 2025

    print("\n🔍 Cambios realizados:")
    print(f"- Columnas renombradas: {original_columns} → {df.columns.tolist()}")
    print("- Añadida columna 'anio_liberacion' = 2025")
    if 'month_of_release' in df.columns:
        print("- Actualizado 'month_of_release' a 2025")

    print("\n📊 TABLA TRANSFORMADA (primeras 5 filas):")
    display(df.head())

    # Guardar resultados
    output_file = "datos_transformados.csv"
    df.to_csv(output_file, index=False)
    return output_file

def generate_requirements():
    print("\n📦 Generando requirements.txt...")
    # Ejecutar pip freeze y guardar en requirements.txt
    with open('requirements.txt', 'w') as f:
        subprocess.run(['pip', 'freeze'], stdout=f)

    print("✅ requirements.txt generado:")
    !cat requirements.txt
    return "requirements.txt"

def generate_dockerfile(csv_file, req_file):
    dockerfile_content = f'''# Dockerfile para el ETL con datos transformados
FROM python:3.9-slim

WORKDIR /app

# Copiar requirements e instalar dependencias
COPY {req_file} .
RUN pip install -r {req_file}

# Copiar archivo CSV transformado
COPY {csv_file} /data/datos_transformados.csv

# Comandos para usar el CSV en contenedores
CMD ["bash", "-c", "echo 'Datos transformados disponibles en /data/datos_transformados.csv' && python -c \"import pandas as pd; df = pd.read_csv('/data/datos_transformados.csv'); print(df.head())\""]
'''

    with open('Dockerfile', 'w') as f:
        f.write(dockerfile_content)

    print("\n🐳 Dockerfile generado:")
    !cat Dockerfile

    # Crear archivo comprimido con todo
    !tar -czf etl_package.tar.gz {csv_file} {req_file} Dockerfile
    return "etl_package.tar.gz"

# Configuración
url = "https://www.stats.govt.nz/assets/Uploads/International-migration/International-migration-February-2025/Download-data/international-migration-february-2025-estimated-migration-by-age-sex.csv"

# Ejecutar ETL
csv_output = transform_data(url)

# Generar requirements.txt
req_output = generate_requirements()

# Generar Dockerfile con el CSV y requirements
package_file = generate_dockerfile(csv_output, req_output)

# Descargar paquete completo
print("\n⬇️ Descargando paquete completo (CSV + requirements.txt + Dockerfile)...")
files.download(package_file)
print("🎉 ¡Proceso completado!")
