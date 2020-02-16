#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Feb 14 16:59:15 2020

@author: JohnGeiger

Web Scraper Unit tests

"""

from JobWebScraper import retrieve_LinkedIn_Jobs


class TestWebScraper:
    
    def test_linkedIn_scrape(self):
        
        jobs, jobLinks, companies, locations = retrieve_LinkedIn_Jobs(
                            jobDescription="Software engineer",
                            jobLocation="Madison, Wisconsin, United States")
        
        size = len(jobs)
        
        if len(jobLinks) != size or len(companies) != size or len(locations) != size:
            assert False
        
        else:
            assert True