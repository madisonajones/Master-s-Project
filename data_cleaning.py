import pandas as pd

def cleaning_data(df):
    ''' This function cleans the data, filters by years I want to use, changes column names,
    Returns cleaned dataset.'''
    # clean_df = df.dropna(axis ='rows')
    clean_df = df[df['Year'].isin([2018,2019,2021,2022])]
    clean_df = clean_df.rename({'DBN': 'dbn',
                                'School Name': 'school_name',
                                'Number Tested': "number_tested",
                                'Mean Scale Score':"mean_scale_score",
                                'Num Level 1': "level_1_count", 
                                'Pct Level 1': "level_1_percentage",
                                'Num Level 2':'level_2_count',
                                'Pct Level 2': 'level_2_percentage',
                                'Num Level 3':"level_3_count",
                                'Pct Level 3': 'level_3_percentage',
                                'Num Level 4':'level_4_count',
                                'Pct Level 4': 'level_4_percentage',
                                'Num Level 3 and 4': "level_3_4_count",
                                'Pct Level 3 and 4': 'level_3_4_percentage'},axis = 'columns')
    return clean_df


def change_variable_type(df,columns):
    ''' This function converts numerical columns to int64. Initially, percentages and numbers 
    are objects.'''
    for col in columns:
        df[col] = pd.to_numeric(df[col], errors = 'coerce')
    return df