import pandas as pd

import display
def transform_and_show(url):
    # Leer los datos desde la URL
    try:
        df = pd.read_csv(url, encoding='utf-8')
    except UnicodeDecodeError:
        df = pd.read_csv(url, encoding='utf-8-sig')

    # Eliminar filas completamente vacías
    df = df.dropna(how='all')

    # Renombrar columnas: espacios → guiones bajos, minúsculas
    df.columns = [col.strip().lower().replace(" ", "_") for col in df.columns]

    # Agregar columna de año y actualizar mes si existe
    df["anio_liberacion"] = 2025
    if 'month_of_release' in df.columns:
        df['month_of_release'] = 2025

    # Mostrar solo la tabla final transformada
    display(df.head())

# Ejecutar
url = "https://www.stats.govt.nz/assets/Uploads/International-migration/International-migration-February-2025/Download-data/international-migration-february-2025-estimated-migration-by-age-sex.csv"
transform_and_show(url)
