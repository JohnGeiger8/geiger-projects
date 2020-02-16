#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 13 17:16:30 2020

@author: JohnGeiger

Web Scraper for finding job listings

TO DO:
    - Add job link
    -
"""

import requests
import os
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

    jobs = []
    jobLinks = []
    companies = []
    locations = []

    # Parse through the HTML results to get all the job items
    resultsParameters = {"class": ["results__container",
                                   "results__container--two-pane"]}
    resultsContainer = soupParser.find("div", resultsParameters)

    jobItemParameters = {"class": ["result-card", "job-result-card",
                                   "result-card--with-hover-state"]}
    jobItems = resultsContainer.findAll("li", jobItemParameters)

    # Retrieve desired information from each job item
    for jobItem in jobItems:

        jobLink = jobItem.find("a", {"class":["result-card__full-card-link"]})
        company = jobItem.find("h4", {"class":["result-card__subtitle",
                                               "job-result-card__subtitle"]})
        location = jobItem.find("span", 
                                   {"class":["job-result-card__location"]})

        jobs.append(jobLink.text)
        jobLinks.append(jobLink.get("href"))
        companies.append(company.text)
        locations.append(location.text)

    return (jobs, jobLinks, companies, locations)





jobs, jobLinks, companies, locations = retrieve_LinkedIn_Jobs(
        jobDescription="Software engineer",
        jobLocation="Madison, Wisconsin, United States")

print("Jobs:")
for job, link, company, location in zip(jobs, jobLinks, companies, locations):
    print(job, "with", company, "in", location, ".  Apply at", link, "\n")
