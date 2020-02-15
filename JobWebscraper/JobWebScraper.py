#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 13 17:16:30 2020

@author: JohnGeiger

Web Scraper for finding job listings

"""

import requests
from bs4 import BeautifulSoup


def retrieve_LinkedIn_Jobs(jobDescription, jobLocation="United States"):
    """ Get LinkedIn search results for the given job in the given location """

    # Create parameters for the job search, then create the request
    linkedInParameters = {"keywords": jobDescription,
                          "location": jobLocation}
    linkedInRequest = requests.get("https://www.linkedin.com/jobs/search/",
                                   params=linkedInParameters)

    # Create a Beautiful Soup variable that we'll use to parse the request
    soupParser = BeautifulSoup(linkedInRequest.content, "html.parser")

    titlesAndCompanies = soupParser.findAll("a")
    jobs = []
    companies = []

    for item in titlesAndCompanies:

        for classItem in item.get("class"):
            if classItem == "result-card__full-card-link":
                jobs.append(item)
                break
            elif classItem == "result-card__subtitle-link":
                companies.append(item)
                break

    return (jobs, companies)


jobs, companies = retrieve_LinkedIn_Jobs("Software engineer",
                                         jobLocation="Madison Wisconsin United States")

print("Jobs:")
for job, company in zip(jobs, companies):
    print(job.text, "with", company.text)
