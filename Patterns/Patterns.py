
# coding: utf-8

# In[3]:


import re
message="The cat curled up on the couch for a catnap"
newmsg = re.sub(r'cat',r'dog',message)
print(message)
print(newmsg)
# only replace first instance
newmsg = re.sub(r'cat',r'dog',message,1)
print(newmsg)


# In[4]:


import itertools, sys, re, os
Chr8="http://sgd-archive.yeastgenome.org/sequence/S288C_reference/chromosomes/fasta/chr08.fsa"
PREsite="GAATGT"
PREsite="TGAAAC"
Chr8File="chr08.fsa"
if not os.path.exists(Chr8File):
    os.system("curl -O {}".format(Chr8))

# define what a header looks like in FASTA format
def isheader(line):
    return line[0] == '>'

def aspairs(f):
    seq_id = ''
    sequence = ''
    for header,group in itertools.groupby(f, isheader):
        if header:
            line = next(group)
            seq_id = line[1:].split()[0]
        else:
            sequence = ''.join(line.strip() for line in group)
            yield seq_id, sequence


# In[7]:


import itertools, sys, re, os
Chr8="http://sgd-archive.yeastgenome.org/sequence/S288C_reference/chromosomes/fasta/chr08.fsa"

PREsite=r'TGA[AT]AC' #    TGAAAC OR TGATAC
PREsite=r'TGA(AT|TA|GC)AC' # TGAATAC   TGATAAC 
REPLACE='PREPRE'
Chr8File="chr08.fsa"
if not os.path.exists(Chr8File):
    os.system("curl -O {}".format(Chr8))

# define what a header looks like in FASTA format
def isheader(line):
    return line[0] == '>'

def aspairs(f):
    seq_id = ''
    sequence = ''
    for header,group in itertools.groupby(f, isheader):
        if header:
            line = next(group)
            seq_id = line[1:].split()[0]
        else:
            sequence = ''.join(line.strip() for line in group)
            yield seq_id, sequence

with open(Chr8File,"rt") as fh:
    seqs = aspairs(fh)
    for seqinfo in seqs:
        seqstr = seqinfo[1].lower()
        newseq=re.sub(PREsite,REPLACE,seqstr,flags=re.IGNORECASE)
        print(newseq)


# In[9]:


string="TREEBRANCH IS brown"

if "own" in string:
    print("own is in there")

if "TREE" in string:
    print("tree is in there")
else:
    print("tree is not in there")


# In[22]:


import re
m = re.search("(([Aa]B)*)C","AcBAcBacBCDED")
if m:
    print("Group 0",m.group(0))
    print("Group 1",m.group(1))
    print("The repeat is {} long".format(len(m.group(1))))
    print("Group 2",m.group(2))


# In[28]:


m=re.search('\d bird', '8 birds') # true
if m:
    print("yes")
m=re.search('\d bird$', '8 birds') # false
if m:
    print("yes")
else:
    print("no")
m=re.search('^\d bird', '8 birds') # true
if m:
    print("yes")
m=re.search('\d bird', '10 birds') # false
if m:
    print("yes")
else:
    print("no")


# In[36]:


m = re.search("\.\s*$","This is my message.  ")
if m:
    print("Yes it has a period")
else:
    print("Does not end well")


# In[46]:


start =0
words="TITLE: The quick brown thesaurus is thEtheThe tenthe"
pattern=re.compile(r'([Tt]h[eE])')
m = pattern.search(words)
while( m ): # test if there was a match
    #  process this match
    matchlen = len(m.group(1))    
    print("The match is {} starts at {} ends at {}".format(m.group(1),
                                                           m.start(),
                                                           m.end()))                                                                  
    start = m.end()+1 # update the starting place to search from
    m = pattern.search(words,start) # run the match 


# In[65]:


# grep -c
dburl="https://ftp.ncbi.nlm.nih.gov/pub/UniVec/UniVec_Core"
dbname="UniVec_Core"
if not os.path.exists(dbname):
    os.system("curl -o {} {}".format(dbname,dburl))

# this script is matching the number of lines that
# start with '>' - eg the number of sequence in a FastA format file
with open(dbname,"r") as fh:
    counter = 0
    phagecounter = 0
    # for counting sequences
    seqstartpattern = re.compile('^>')
    # match for phage
    phage = re.compile(r"\s+phage\s+",flags=re.IGNORECASE)
    print(phage)
    for line in fh:
        m = seqstartpattern.search(line)
        if m:
            counter += 1
            pg = phage.search(line)
            if pg:
                phagecounter +=1
    print("There are {} lines that match".format(counter))
    print("There are {} phage vector sequences".format(phagecounter))


# In[71]:


EcoRI   = "GAATTC"
EcoRII  = "CC[AT]GG"

RestrictionEnzymes = [EcoRI, EcoRII]
DNA = "ACAGACGAGAGAATTCGGCCTGGTAGAT"
for RE in RestrictionEnzymes:
    pattern = re.compile(RE)
    match = pattern.search(DNA)
    count = pattern.findall(DNA)
    print(RE,"matches", len(count), "sites")
    for ct in count:
        print(ct)

print("//")


# In[72]:


import re
message="The cat curled up on the couch for a catnap"
newmsg = re.sub(r'cat',r'dog',message)
print(message)
print(newmsg)
# only replace first instance
newmsg = re.sub(r'cat',r'dog',message,1)
print(newmsg)


# In[81]:


protein="MCCW*SIXL.L"
print(re.sub(r'[\*\.X]','',protein))

aln="AATTC--AGTCTAAGT-TGA.T" # one line
print(re.sub(r'\.','-',aln))

tree="(A:10.01(B:3.00,C:2))"
print(re.sub(r':\d+(.\d+)?',"",tree))


# In[ ]:




