#!/usr/bin/env python3
# coding: utf-8

# In[2]:


myfile="data1.dat"
with open(myfile,"r") as fh:
    for line in fh:
        print(line)


# In[3]:


myfile="data1.dat"
fh = open(myfile,"r")


# In[4]:


genes = ['SOD1','CDC11','YFG1']
print(genes)
sort_genes = sorted(genes)
print(sort_genes)
numbers = [141, 7, 90, 3, 13]
print("unsorted",numbers)
numbers.sort()
print("sorted",numbers)
print("reversed",sorted(numbers,reverse=True))


# In[6]:


numbers = [141, 7, 90, 3, 13]
print(numbers)
numbers.sort(reverse=True)
print(numbers)


# In[11]:


alphanumbers = ['141', '7.2', '90', '7.5','3', '13']
print("Alphanumeric unsorted strings",alphanumbers)
print("Alpha sorted numbers",sorted(alphanumbers))
print("Numberic sorted",sorted(alphanumbers,key=float))


# In[13]:


from datetime import datetime

dates = ['3-Jan-2016', '4-Mar-2015', '2-Aug-1999', '1-May-2000']
print(dates)
dates.sort()
print(dates)

#newdates = [ datetime.strptime(d,"%d-%b-%Y") for d in dates ]
newdates = []      
for str in dates:
    newdates.append(datetime.strptime(str,'%d-%b-%Y'))
print(newdates)
newdates.sort()
print(newdates)

for n in newdates:
    print(datetime.strftime(n,"%Y-%b-%d"))
    
#    print(datetime.strftime(n,"%Y-%b-%d")," OR ", 
#        datetime.strftime(n,"%Y-%m-%d"), " OR ",
#        datetime.strftime(n,"%A, %b %d, %Y"), " OR ",
#        datetime.strftime(n,"%c")
#        )


# In[15]:


DNA='AAAACCGTAG'
#for let in DNA:
#    print(let)

for let in reversed(DNA):
    print(let)
    


# In[16]:


things = {}      # an empty dictionary
listofstuff = [] # an empty array
print(things)
things = {'diane': 10, 'jack': 13}
print(things)
print(things['diane'])
things['billy'] = 15 # assign a new key/value pair
# if you have a list of pairs of things
strangerthings = dict([('Will', 12), ('Jim', 44), ('Joyce', 45), ('Eleven',11),('Lucas',10)])
print(strangerthings['Eleven'])


# In[18]:


print(strangerthings)
strangerthings['Will'] = 16
print(strangerthings)


# In[24]:


strangerthings = dict([('Will', 12), ('Jim', 44), ('Joyce', 45), ('Eleven',11),('Lucas',10)])
for name in strangerthings:
    print(name, 'they are',strangerthings[name])
    if ( name != "Will" ):
        strangerthings[name] += 5
    
print("====")
for name in strangerthings:
    print(name, 'they are',strangerthings[name])


# In[28]:


print("\t".join(["NAME", "AGE"]))
for name in strangerthings:
    print("\t".join([name,"%d"%(strangerthings[name])]))


# In[36]:



trees = {'oak':  ['0.5','100','190'],
         'maple': ['0.75','170','270'],
        }
print("\t".join(["SPECIES", 'leafsize','avg-height','max-age']))
for name in trees:
    line = [name]
    line.extend(trees[name])
    #print(len(line))
    #print(line)
    print("\t".join(line))


# In[40]:


DNA="AACACGAGT"
for base in DNA:
    print(base)


# In[47]:


def average(list):
    count=0
    sumval  = 0
    for item in list:
        count += 1
        sumval   += item
    return sumval / count

nums = [100,200,300,150,110,99,40]
avg = average(nums)
print("avg is {}".format(avg))


# In[ ]:




