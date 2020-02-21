#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Feb 14 16:59:15 2020

@author: JohnGeiger

Web Scraper Unit tests

"""

from JobWebScraper import JobWebScraper


class TestWebScraper:
    """ Class for testing the JobWebScraper class' functions """

    def test_linkedIn_scrape(self):
        """ Test scraping of LinkedIn job site """

        scraper = JobWebScraper("LinkedIn")

        try:
            jobs, links, companies, locations = scraper.retrieve_LinkedIn_jobs(
                            jobDescription="Software engineer",
                            jobLocation="Milwaukee, Wisconsin")
        except AttributeError as error:
            print(error)
            print("Tags are likely outdated or incorrect")
            assert False

        n = len(jobs)

        if len(links) != n or len(companies) != n or len(locations) != n:
            assert False

        else:
            assert True

    def test_indeed_scrape(self):
        """ Test scraping of Indeed job site """

        scraper = JobWebScraper("Indeed")

        try:
            jobs, companies, locations = scraper.retrieve_Indeed_jobs(
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
