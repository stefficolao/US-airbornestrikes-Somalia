## Summary

This repository accompanies my Comment, "Back Again: How Airborne Strikes Against al-Shabaab Further U.S. Imperial Interests," published in the 28.1 issue of the Journal of International Law and Foreign Affairs. It contains the data and analysis discussed in the Comment, and it expands upon those discussions with additional visualizations and analyses. The Comment and accompanying Appendix are included, as well as the original code. 

The data has been pulled from Airwars, a nonprofit focused on bringing transparency and accountability to military conflicts and civilian harm (https://airwars.org). For strikes in Somalia, Airwars compiles data from U.S. and Somali news media, U.S. military statements, the Bureau of Investigative Journalism, Amnesty, U.S. government responses to Airwars’ Freedom of Information Act requests, and Somali Twitter. By aggregating a variety of sources, it is considered the comprehensive record of all possible U.S. strikes in Somalia.

From Airwars, I pulled all claims of U.S. airborne strikes against al-Shabaab or al- Qaeda, excluding claims that Airwars determined to be unsubstantiated, through August 2022. This left 333 likely U.S. airstrikes, 248 of which were claimed by AFRICOM. The remaining 85 strikes could be undeclared AFRICOM strikes, CIA strikes, or not U.S. strikes at all, though the Appendix has already excluded strike reports Airwars deemed unreliable. While there were often competing descriptions of the target, I opted for the description most favorable to the U.S., whether from a U.S. government statement or any other indication that the target included an al- Shabaab member. If a strike had high civilian casualties, but there were still grounds to believe an al-Shabaab member was present, the civilians were not considered the target (though could be considered disproportionate collateral in violation of the principle of proportionality). Of course, the claim that a target was a member of al-Shabaab member cannot be evaluated, and the U.S. determination of members is, at best, highly subjective. Thus, the data interpretations represents the most generous interpretation to the U.S.

My conclusions about whether the target was plausibly directly participating in hostilities is based on the ICRC’s guidance for interpreting direct participation in hostilities, which requires that the act must meet a certain threshold of harm to a party’s military operations or to protected persons, that the act must be designed to cause harm in support of a party to the conflict (belligerent nexus), and that there be a direct causal link between the harm and the act (https://casebook.icrc.org/glossary/direct-participation-hostilities). Activities like possessing weapons or traveling lacked direct causation of harm, as did attacking U.S. or partner forces the day prior, because there was no certainty that the members targeted were responsible for the attack. If the U.S. suspected an imminent attack or seemed to respond immediately after an attack, I considered that there was “maybe” a direct participation in hostilities claim, based on the uncertainty of the timing or credibility of a suspected threat. Only if the U.S. launched an airstrike in active conflict against al- Shabaab did I consider there to be a true claim that the target was directly participating in hostilities. This is not an evaluation of the accuracy of the direct participation in hostilities claim but whether there existed any grounds for the U.S. to claim it made a targeting decision based on direct participation in hostilities, rather than al-Shabaab membership alone.

As this analysis shows, in practice, airborne strikes against al-Shabaab individually and cumulatively violate international law. In my Comment, I also examine how the program violates international law in policy. Ultimately, I conclude that IHL does not serve as a reliable constraint on U.S. action, and moreover, these strikes are better understood as a protracted project of military imperialism rather than as unlawful counterterrorism tactics. 

## File Descriptions

| File                                 | Description                                                                                                       
|--------------------------------------|----------------------------------------------------------------------------------------------------------|
| `2024 UPDATE Somalia.pdf`            | Brief comments on the current U.S. intervention in Somalia as of publishing                              | 
| `COLAO APPENDIX REVISED.pdf`         | Data appendix, first published by JILFA here:                                                            |
| `COLAO August 2022 Revisions.pdf`    | Comment, first published by JILFA here:                                                                  |
| `DPHClaim_Strike_Count_barplot.svg`  | Bar plot showing strikes claimed by AFRICOM and all strikes                                              |
| `airwars_scraper.R`                  | Scraper used to pull data in August 2022 from Airwars                                                       |
| `barplot_code.R`                     | R code used to summarize the data by AFRICOM airborne strikes and all other airborne strikes in the data |
| `somalia_data.csv`                   | Scraped and labeled data from Airwars used in the analysis                                               |


## Data Dictionary

| Variable                             | Description                                                                                                       
|--------------------------------------|----------------------------------------------------------------------------------------------------------|
| `ID`                                 | Internal ID for each airborne strike                                                                     | 
| `Location`                           | Location of airborne strike                                                                              |
| `Date`                               | Date(s) of airborne strike(s)                                                                            |
| `Claimed by AFRICOM?`                | Whether an airborne strike was claimed by AFRICOM                                                        |
| `Description of target`              | Description of target hit by airborne strike from Airwars                                                |
| `DPH Claim?`                         | Whether there is a claim that a target was a direct participant in hostilities                           |
| `URL`                                | Link to Airwars page on each airborne strike (pulled August 2022)                                           |

