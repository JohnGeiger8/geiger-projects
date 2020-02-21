#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 13 17:16:30 2020

@author: JohnGeiger

Web Scraper for finding job listings from LinkedIn and Indeed

Disclaimer: Created purely for learning and experience purposes. This script
    should not actually be used for collecting data from LinkedIn or Indeed
    without first reviewing their terms of service.

"""

import requests
from bs4 import BeautifulSoup


class JobWebScraper:
    """ Used to scrape job sites for open positions """

    validJobSites = ["LinkedIn", "Indeed"]
    jobSite = ""

    def __init__(self, jobSite):

        if jobSite not in self.validJobSites:
            raise ValueError
        else:
            self.jobSite = jobSite

    def retrieve_LinkedIn_jobs(self, jobDescription, jobLocation="USA"):
        """ Get LinkedIn search results for the described job """

        # Items that will be returned
        jobs, jobLinks, companies, locations = [], [], [], []

        searchParameters = {"keywords": jobDescription,
                            "location": jobLocation}
        url = "https://www.linkedin.com/jobs/search/"

        # Fetch the webpage's html
        request = requests.get(url, params=searchParameters)

        soupParser = BeautifulSoup(request.content, "html5lib")

        # Parse through the HTML results to get all the job items
        parameters = {"class": ["results__list"]}
        results = soupParser.find("section", parameters)

        jobItemParameters = {"class": ["result-card", "job-result-card",
                                       "result-card--with-hover-state"]}
        jobItems = results.findAll("li", jobItemParameters)

        # Retrieve desired information from each job item
        for jobItem in jobItems:

            jobLink = jobItem.find("a",
                                   {"class": ["result-card__full-card-link"]})
            company = jobItem.find("h4", {"class":
                                          ["result-card__subtitle",
                                           "job-result-card__subtitle"]})
            location = jobItem.find("span",
                                    {"class": ["job-result-card__location"]})

            jobs.append(jobLink.text)
            jobLinks.append(jobLink.get("href").strip())
            companies.append(company.text)
            locations.append(location.text)

        return (jobs, jobLinks, companies, locations)

    def retrieve_Indeed_jobs(self, jobDescription, jobLocation="USA"):
        """ Get Indeed search results from the BeatifulSoup object """

        jobs, companies, locations = [], [], []

        searchParameters = {"q": jobDescription, "l": jobLocation}
        url = "https://www.indeed.com/jobs"

        # Fetch the webpage's html
        request = requests.get(url, params=searchParameters)

        soupParser = BeautifulSoup(request.content, "html5lib")

        # Parse through the HTML results to get all the job items
        results = soupParser.find("table", id="resultsBody")
        jobItemParameters = {"class": ["jobsearch-SerpJobCard", "unifiedRow",
                                       "row", "result"]}
        jobItems = results.findAll("div", jobItemParameters)

        # Retrieve desired information from each job item
        for jobItem in jobItems:

            jobLink = jobItem.find("a", {"class":
                                         ["jobtitle", "turnstileLink"]})
            company = jobItem.find("span", {"class": ["company"]})
            location = jobItem.find("div", {"class": ["recJobLoc"]})

            jobs.append(jobLink.text)
            companies.append(company.text[1:])  # Skip the first character: \n
            locations.append(location.get("data-rc-loc"))

        return (jobs, companies, locations)
