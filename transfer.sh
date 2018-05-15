#!/usr/bin/env python3

class SpreadSheet:
    def __init__(self, sheetfile, offset, elms_mode=False):
        with open(sheetfile, 'r') as sheet:
            headers = sheet.readline().strip().split(',')
            self.columns = {}
            self.rows    = {}
            self.data    = []


            for ind, header in enumerate(headers):
                if '(' in header and ')' in header:
                    header = header.split('(')[0]
                self.columns[header] = ind

            self.id = self.columns[offset]
            for line_num,line in enumerate(sheet):
                line = line.strip().split(',')
                if elms_mode:
                    entries = [line[0]+','+line[1]] + line[2:]
                else:
                    entries = line
                self.data.append(entries)
                self.rows[entries[self.columns[offset]]] = line_num
                #self.rows[entries[0]] = line_num
                
    def add_score(self,assignment, uid, score):
        if score:
            self.data[self.rows[uid]][self.columns[assignment]] = score

    def update_assignment(self,assname, score_map):
    
        
        for (name,score) in score_map.items():
            self.add_score(assname, name, score)

    def create_assignment(self,ass_name, score_map):
        self.columns[ass_name] = len(self.columns)
        self.data[0].append('100')


        for (uid,score) in score_map.items():
            self.data[self.rows[uid]].append(score)

    def map_assignment(self,ass_name):
        scores = {}

        if ass_name not in self.columns:
            return None
        
        for person, ind in self.rows.items():
            scores[person] = self.data[ind][self.columns[ass_name]]

        return scores


    def write(self, outfile):
        with open(outfile, 'w') as out:
            out.write(','.join(sorted(self.columns, key=lambda k: self.columns[k])) + '\n')
            for line in self.data:
                out.write(','.join(line) + '\n')
    
while True:
    gradescope_n = input('Please add your gradescope file name: ')
    try:
        gradescope = SpreadSheet(gradescope_n, 'SID')
        break
    except OSError as e:
        print(e)
        print('Tried to open non-existent file.  Please try again.')

while True:
    elms_n = input('Please add your elms file name: ')
    try:
        elms = SpreadSheet(elms_n, 'SIS User ID', True)
        break
    except OSError as e:
        print(e)
        print('Tried to open non-existent file.  Please try again.')

nextline = 'dummy'

while nextline:
    nextline = input('> ').strip()
    if nextline == 'help':
        print('available commands are "write <outfile name", which writes the new file out\n' + \
            '"add ass_name", which adds the assignment from gradescope to the elms csv\n' + \
            '"update_score ass_name ", which updates the scores on an existing assignment.')

    elif len(nextline) >= 4 and nextline[:3] == 'add':
        if nextline[3] != ' ':
            print('need an assignment and uid')
            continue

        assgn = nextline[4:]
        if assgn in elms.columns:
            print('this assignment already exists')
            continue
        elif assgn not in gradescope.columns:
            print('gradescope does not have this assignment')
            continue
        
        elms.create_assignment(assgn, gradescope.map_assignment(assgn))
        print('successfully created assignment %s' % (assgn,))
        
            
    elif len(nextline) >= 6 and nextline[:5] == 'write':
        if nextline[5] != ' ':
            print('need a filename')
            continue

        fname = nextline[6:]
        try:
            elms.write(fname)
            print('successfully wrote %s' % (fname,))
        except OSError:
            print('file name invalid')
            continue
        
    elif len(nextline) >= 13 and nextline[:12] == 'update_score':
        if nextline[12] != ' ':
            print('need a file')
            continue

        assgn = nextline[13:]
        if assgn not in elms.columns:
            print('this assignment does not exist in elms')
            continue
        elif assgn not in gradescope.columns:
            print('this assignment does not exist in gradescope')
            continue

        elms.update_assignment(assgn, gradescope.map_assignment(assgn))
        print('succesfully updated %s' % (assgn,))

    elif nextline == 'debug':
        print(elms.columns)
        print(elms.rows)
        print(gradescope.columns)
        print(gradescope.rows)
