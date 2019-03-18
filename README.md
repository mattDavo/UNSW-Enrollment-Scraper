# UNSW-Enrolment-Scraper
WIP UNSW enrolment scraper. Currently supports course enrolment, not class enrolment. Run indefinitely, checks classutil every 5 seconds.

## Usage
To wait for spots in COMP3161 in term 3, then email `myemail@unsw.edu.au` when there are spots:
```
perl enrolment_scraper.pl COMP3161 3 myemail@unsw.edu.au
```
