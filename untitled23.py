import pandas as pd


def transform_and_save(url):
    # Extracción
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


# Configuración
url = "https://www.stats.govt.nz/assets/Uploads/International-migration/International-migration-February-2025/Download-data/international-migration-february-2025-estimated-migration-by-age-sex.csv"

# Ejecutar ETL
transform_and_save(url)


