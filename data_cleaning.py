import pandas as pd

def cleaning_data(df):
    ''' This function cleans the data, filters by years I want to use, changes column names,
    Returns cleaned dataset.'''
    # clean_df = df.dropna(axis ='rows')
    clean_df = df[df['Year'].isin([2018,2019,2022])]

    # rename columns for easier use in code
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
    # convert num columns to numeric, coerce errors to NaN
    for col in columns:
        df[col] = pd.to_numeric(df[col], errors = 'coerce')
    return df



def create_school_level_data(df):
    ''' Filters data for school level information for all grades and all students. Returns new dataframe'''

    # filtering for school level data, all grades, all students
    df = df[
        (df['Report Category'].isin(['School'])) &
        (df['Grade'] == 'All Grades') &
        (df['Student Category'] == 'All Students')
    ]
    return df


def merge_data_and_poverty(schooldata, povertydata):
    ''' Cleans poverty data, adjusts column names, merges with school level data. Returns merged dataframe.'''

    # clean poverty data, filter for 2018-19 school year, adjust column names
    cols_to_keep = ['DBN','School Name','Year','% Poverty', 'Economic Need Index']
    povertydata_filtered = povertydata[
        (povertydata['Year'] == '2018-19')][cols_to_keep]
    
    # fix 0.95 value in poverty data
    povertydata_filtered['% Poverty'] = povertydata_filtered['% Poverty'].replace({'Above 95%':'0.95'})
    povertydata_filtered['Economic Need Index'] = povertydata_filtered['Economic Need Index'].replace({'Above 95%':'0.95'})

    # rename for merge in school data
    schooldata= schooldata.rename(columns = {'Geographic Subdivision':'DBN'})

    # merge school & poverty data on DBN (school identifier)
    merged = schooldata.merge(povertydata_filtered[['DBN', '% Poverty', 'Economic Need Index']],  # keep only needed columns

                              on='DBN',
                              how='left')
    
    return merged


def categorize_poverty(row):
    nyc_poverty_percent = 0.74
    if row['% Poverty'] >= nyc_poverty_percent:
        return '1'
    else:
        return '0'
    
def categorize_title_i(row):
    nyc_doe_titlei = 0.6
    if row['% Poverty'] >= nyc_doe_titlei:
        return '1'
    else:
        return '0'
    
def categorize_economic_need(row):
    nyc_economic_need_index = 0.713
    if row['Economic Need Index'] >= nyc_economic_need_index:
        return '1'
    else:
        return '0'