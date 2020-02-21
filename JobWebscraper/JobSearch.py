#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Feb 17 11:40:47 2020

@author: JohnGeiger

JobSearch

Command line job searching program that uses JobWebScraper.

"""

import sys
from JobWebScraper import JobWebScraper

try:
    linkedInScraper = JobWebScraper("LinkedIn")
    indeedScraper = JobWebScraper("Indeed")

except ValueError:

    print("Exception: Value Error: Invalid job site specified")
    sys.exit(1)

keyword = input("To search for jobs, give the job name or keyword:\n")
location = input("Job location:\n")
print()

try:
    jobs, links, companies, locations = linkedInScraper.retrieve_LinkedIn_jobs(
            keyword, location)

    print("LinkedIn Jobs:")
    for job, link, company, location in zip(jobs, links, companies, locations):
        print(job, "with", company, "in " + location +
              ". Apply at", link, "\n")

    jobs, companies, locations = indeedScraper.retrieve_Indeed_jobs(keyword,
                                                                    location)

    print("Indeed Jobs:")
    for job, company, location in zip(jobs, companies, locations):
        print(job, "with", company, "in " + location + ".")

except AttributeError:

    print("Please try again later.")
