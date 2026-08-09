import pandas as pd 
import os
dataPath = f'D:\\Data Track\\Data Projects\\RetailETLSSIS\\orignal_data\\Online Retail.xlsx'
dirPath = f'D:\\Data Track\\Data Projects\\RetailETLSSIS\\source_data\\'

df = pd.read_excel(dataPath)

def split_data_by_year_month(df):
    df['InvoiceDate'] = pd.to_datetime(df['InvoiceDate'])
    df['YearMonth'] = df['InvoiceDate'].dt.strftime('%Y-%m')

    for year_month,group in df.groupby('YearMonth'):
        output_path = os.path.join(dirPath, f'sales_{year_month}.csv')
        group.drop(columns = ['YearMonth']).to_csv(output_path , index=False)
        print(f'Saved data for {year_month} to {output_path}')
split_data_by_year_month(df)