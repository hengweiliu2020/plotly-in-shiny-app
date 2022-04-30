#spider.py
import matplotlib.pyplot as plt
import pandas as pd

df = pd.read_sas('adtr.sas7bdat')
df2=df[(df["PARQUAL"]==b'INVESTIGATOR') & (df['PARAMCD']==b'SUMDIAM') & 
(df['ANL01FL']==b'Y')]
df2=df2.assign(ADY2=df2['ADY']/(365.25/12))

df2.loc[df2['ABLFL']==b'Y','ADY2']=0
df2.loc[df2['ABLFL']==b'Y','PCHG']=0
df2.set_index('ADY2',inplace=True)
df2.groupby('SUBJID')['PCHG'].plot(color='red', marker='o')

plt.title('Spider Plot', fontsize=9)
plt.xlabel('Treatment Duration (months)', fontsize=9)
plt.ylabel('Percent Change from Baseline in Sum of Diameters', fontsize=9)

plt.grid(True)
plt.show()
