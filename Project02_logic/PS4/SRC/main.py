import os, os.path, re
def negative(literal):
    literal = literal.replace('(','')
    literal = literal.replace(')','')

    if literal.count('-') % 2 != 0:
        literal = literal.replace('-','')
        return  literal[0]
    else:
        literal = literal.replace('-','') 
        return '-' + literal[0]





def union(list_1, list_2):
    new_list = list_1
    for element in list_2:
        if element not in list_1:
            new_list.append(element)
    return new_list


def getLiterals(sentence):
    literals = sentence.replace(" OR ","")
    lst = []
    sign = ""
    for i in range(len(literals)):
        if(literals[i] == '-'):
            sign = '-'
            continue
        else: 
            lst.append(sign+literals[i])
            sign = ''
    lst = logicalSimplify(lst)
    return lst

def makeResolvedSentece(literals):
    sentence = ""
    for literal in literals:
        sentence += literal + " OR "
    return sentence[:(len(sentence)-4)]

def logicalSimplify(literals):
    lst = literals
    for i in range(len(lst)):
        for j in range(i+1, len(lst)):
            if(lst[i] == negative(lst[j])):
                lst = []
                return lst
            else:
                x = lst[i][len(lst[i])-1]
                y = lst[j][len(lst[j])-1]
                if x > y:
                    lst[i],lst[j] = lst[j],lst[i]
    tmp = []
    for i in range(len(lst)):
        add = True
        for j in range(i+1, len(lst)):
            if(lst[i] == lst[j]):
                add = False
        if add:
            tmp.append(lst[i])
    return tmp
    

def PL_RESOLVE(sentence1, sentence2):
    literals1 = getLiterals(sentence1)
    literals2 = getLiterals(sentence2)
    resolvable = False
    for cur1 in literals1:
        for cur2 in literals2:
            if(cur1 == negative(cur2)):
                resolvable = True
                literals1.remove(cur1)
                literals2.remove(cur2)
        if resolvable == True:
            break
    u = union(literals1,literals2)   
    res = logicalSimplify(u)
    if resolvable == True: 
        resolve =  makeResolvedSentece(res)
        if resolve == "":
            if len(u) == len(res): 
                return "{}"     #MENH DE RONG
            else : return None  #MENH DE KO CO ICH (A v TRUE)
        else:
            return resolve      #MENH DE HOP GIAI
    else:
        return None             #KHONG AP DUNG HOP GIAI




def PL_RESOLUTION(KB,alpha):
    clauses = KB.copy()
    alphaLiterals = getLiterals(alpha)
    for literal in alphaLiterals:
        negLiteral = negative(literal)
        clauses.append(negLiteral)

    new = []
    loop = True
    while(loop):
        
        generated_clauses = []
        
        for i in range(len(clauses)):
            for j in range(i+1, len(clauses)):
                resolvents = PL_RESOLVE(clauses[i],clauses[j])
                
                if resolvents is None:
                    continue
                elif  resolvents not in clauses:
                    generated_clauses = union(generated_clauses,[resolvents])
                    # print(resolvents+' & ('+ clauses[i] +")  hop giai  (" + clauses[j]+')\\\\')
                if resolvents == '{}':
                    loop = False
                new = union(new,[resolvents])
        # print(str(len(generated_clauses)))
        output.write(str(len(generated_clauses))+'\n')
        for k in range(len(generated_clauses)):
            output.write(generated_clauses[k]+'\n')

        if loop == False:
            return True
        if set(new).issubset(clauses):
            return False
        clauses = union(clauses,new)


def execute():
    KB = []
    alpha = ""

    alpha = input.readline()
    alpha = alpha[:len(alpha)-1]
    

    cnt = input.readline()
    cnt = int(cnt[:len(cnt)-1])
    for i in range(cnt):
        sentence = input.readline()
        if(sentence[len(sentence)-1] == '\n'):
            sentence = sentence[:len(sentence)-1]
        KB.append(makeResolvedSentece(getLiterals(sentence)))
    return PL_RESOLUTION(KB, alpha)
    


        
InputFiles = os.listdir('./Project02_logic/PS4/SRC/input')
for i in InputFiles:
    input = open('./Project02_logic/PS4/SRC/input/'+i,"r") 
    output = open('./Project02_logic/PS4/SRC/output/ouput'+ re.findall('\d+',i)[0]+".txt","w")

    res = execute()
    if res:
        output.write("YES")
    else:
        output.write("NO")

    input.close()
    output.close()











