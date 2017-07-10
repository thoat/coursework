# coding: utf-8
x = 4
x
y = 'a'
y
x = 4.0
x
str(x)
type(x)
x = 4
type(x)
get_ipython().magic(u'pinfo type')
help(type)
l = [4, 'a']
t = (4, 'a')
t = (4, 'a', 'hello')
l[0]
t[0]
len(t)
len(l)
l[0] = 5
l
t[0] = 5
l
l.append(17)
l
t.append(17)
dir(l)
help(list)
l
for li in l:
    print li
    
for li in l:
    print(li)
    
for li in l:
    print(li)
    
help(print)
get_ipython().magic(u'pinfo print')
for li in l:
    print(li, end="")
    
l[0]
l[:1]
l[:2]
l[:1]
l[1:]
l[1:len(l)]
range(0,3)
for i in range(0,3):
    print i, l[i]
    
for i, li in enumerate(l):
    print i, li
    
enumerate(l)
list(enumerate(l))
l = [1,2,3]
l
for li in l:
    print li*li
    
p = []
for i in range(0, len(l)):

    
    f
    "
    reutnr
    pass
p = []
for li in l:
    p.append(li*li)
    
p
[li*li for li in l]
[li*li for li in l if li % 2 == 0]
l
def f(x):
    return x*x
f(30
)
[f(li) for li in l]
def f(firstargt=x):
    return x*x
f(30)
def f(firstarg = x)
def f(firstarg = x):
    return x*x
f(30)
def f(firstarg = x):
    return x*x
f(firstarg=30)
def f(x = 1):
    return x*x
f()
f(x = 30)
def f(x = 1, y):
    return x*x*y
def f(y, x = 1):
    return x*x*y
f(x = 20, y = 1)
def f(x):
    return x*x
li_squared = []
[li_squared[i] = f(li) for i, li in enumerate(l)]
l
l = [1, 'a', 'hello']
l
d = {'jake': 36, 'sid': 37}
d
d['kids'] = (3,5)
d
d.keys()
d.values()
'jake' in d
'dan' in d
'jake' in d.keys()
d.keys()
d
d.values()
help(d.values
)
for k in d:
    print k
    
d.items()
for k,v in d.items():
    print k, v
    
d.iteritems()
for k,v in d.iteritems():
    print k, v
    
for k in d:
    print k, d[k]
    
'joe'.upper()
upper('joe')
str.upper('joe')
'joe'.upper()
d
s = 'jake'
s[0].upper()
s[0].upper() + s[1:]
[k[0].upper() + k[1:] for k in d]
[(k[0].upper() + k[1:], v) for k,v in d]
[(k[0].upper() + k[1:], v) for k,v in d.items()]
dict([(k[0].upper() + k[1:], v) for k,v in d.items()])
d = {}
d['meeting'] += 1
if 'meeting' not in d:
    d['meeting'] = 0
    
d['meeting'] += 1
d
d['meeting'] += 1
d
from collections import defaultdict
d = defaultdict(int)
int()
int(14)
d
d['meeting'] += 1
d
d['meeting'] += 1
d
d = { {'spam': {'meeting': 0, 'money': 0}, {'ham': {'meeting': 0, 'money': 0} } } 

}
d = {'spam': {'meeting': 0, 'money': 0}, 'ham': {'meeting': 0, 'money': 0} }
d
d['spam']
d['spam']['meeting']
d = defaultdict(lambda x: defaultdict(int))
def create_new_defaultdict_int():
    return  defaultdict(int)
d = create_new_defaultdict_int()
d
create_new_defaultdict_int
create_new_defaultdict_int()
int
int()
d = defaultdict(create_new_defaultdict_int)
d
d['spam']['money'] += 1
d
d = defaultdict(lambda x: defaultdict(int))
'this is a sentence'
'this is a sentence'.split()
'this is a sentence'.split(",")
'this is a, sentence'.split(",")
'this is a sentence'.split()
first, second, third, fourth = 'this is a sentence'.split()
first
second
third 
fourth
get_ipython().magic(u'pinfo %save')
get_ipython().magic(u'save /tmp/intro_from_class.py 1-156')
