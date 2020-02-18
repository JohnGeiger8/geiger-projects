#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Feb 14 16:59:15 2020

@author: JohnGeiger

Web Scraper Unit tests

"""

from JobWebScraper import JobWebScraper


class TestWebScraper:

    def test_linkedIn_scrape(self):
        
        scraper = JobWebScraper("LinkedIn")
        
        try:
            jobs, jobLinks, companies, locations = scraper.retrieve_jobs(
                            jobDescription="Software engineer",
                            jobLocation="Milwaukee, Wisconsin")
        except AttributeError as error:
            print(error)
            print("Tags are likely outdated or incorrect")
            assert False

        size = len(jobs)

        if len(jobLinks) != size or len(companies) != size or len(locations) != size:
            assert False

        else:
            assert True


    def test_indeed_scrape(self):

        scraper = JobWebScraper("Indeed")

        try:
            jobs, companies, locations = scraper.retrieve_jobs(
                            jobDescription="Software engineer",
                            jobLocation="Madison, Wisconsin, United States")

        except AttributeError as error:
            print(error)
            print("Tags are likely outdated or incorrect")
            assert False
        
        size = len(jobs)

        if len(companies) != size or len(locations) != size:
            assert False

        else:
            assert True
