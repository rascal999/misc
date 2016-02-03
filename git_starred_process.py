#!/usr/bin/env python

import requests
import json

r = requests.get('https://api.github.com/users/rascal999/starred')
if (r.ok):
    repoList = json.loads(r.text or r.content)

repoSorted = sorted(repoList,key=lambda k: k['stargazers_count'])

for repo in repoSorted:
    print(repo['name'])
    print(repo['description'])
    print(repo['stargazers_count'])
    print('###')
