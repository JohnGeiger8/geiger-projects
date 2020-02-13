#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 13 17:16:30 2020

@author: JohnGeiger

Web Scraper for finding job listings

"""

import requests
from bs4 import BeautifulSoup

# Create parameters for the job search, then create the request
linkedInParameters = {"keywords": "software engineer", 
                      "location": "Madison Wisconsin United States"}
linkedInRequest = requests.get("https://www.linkedin.com/jobs/search/", 
                               params=linkedInParameters)

# Create a Beautiful Soup variable that we'll use to parse the request
soupParser = BeautifulSoup(linkedInRequest.content, "lxml")
print(soupParser.prettify())