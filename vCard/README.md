# vCard
[English](README.md)

![Static Badge](https://img.shields.io/badge/Wikimedia_Projects-Wikivoyage-cornflowerblue?style=flat&link=https%3A%2F%2Fwww.wikimedia.org%2F&link=https%3A%2F%2Fwww.wikivoyage.org%2F)
![Static Badge](https://img.shields.io/badge/Wikivoyage-lightgray?style=flat&logo=wikivoyage&logoColor=black&labelColor=cornflowerblue&link=https%3A%2F%2Fwww.wikivoyage.org%2F)
![GitHub repo size](https://img.shields.io/github/repo-size/sousakak/WikivoyageModules)

----
In 2023, we Japanese community decided to replace Listing templates to vCard, which is a new version that is fully compatible. You can see the local discussion at the [project chat](https://w.wiki/89x5), and here is the code storage of files of vCard and related ones. This also includes modules' documentation pages and some of JavaScript linked to vCard.

## Progress
There are many tasks, such as translations, localizations, and so on. The original page of the alteration is as follows (*t*: translation; *l*: localization):

- [ ] core *t*, *l*
  - [ ] [Module:VCard/Cards](core/Cards.lua) *t*
  - [x] [Module:VCard/i18n](core/i18n.lua) ~~*t*~~ ~~*l*~~
  - [ ] [Module:VCard/Params](core/Params.lua) *t*
  - [x] [Module:VCard/Qualifiers](core/Qualifiers.lua) ~~*t*~~
  - [ ] [Module:VCard/Subtypes](core/Subtypes.lua) *l*
  - [ ] [Module:VCard/Unesco](core/Unesco.lua) ~~*t*~~ *l*
- [x] Coordinates
  (*Already exist in javoy*)
  - [x] [Module:Coordinates](https://w.wiki/8HiE)
  - [x] [Module:Coordinates/i18n](https://w.wiki/8HiG)
- [ ] CountryData
  - [ ] [Module:CountryData](CountryData/CountryData.lua)
  - [ ] [Module:CountryData/Geography](CountryData/Geography.lua) *t*
  - [x] [Module:CountryData/Currencies](CountryData/Currencies.lua)
- [ ] Exchange rate
  (*Compete with local ones*)
- [x] [Module:Languages](./Languages.lua)
- [ ] Marker
  - [x] [Module:Marker utilities](MarkerUtilities/Marker_utilities.lua)
  - [ ] [Module:Marker utilities/i18n](MarkerUtilities/i18n.lua) *t*
  - [x] [Module:Marker utilities/Maki icons](MarkerUtilities/Maki_icons.lua)
- [ ] [Module:Wikidata_utilities](./Wikidata_utilities.lua)

### Tasks
|    Status    |                Content                |
|:-------------|:--------------------------------------|
|    Unimpl    |       Translations (see above)        |
|    On hold   | Display of links to external services |
|    Unimpl    |        Impl of Listing Editor         |
|    Unimpl    |         Impl of Listing Info          |

### Unclearness
- What do lines 126-130 of [Module:Marker Utilities/i18n](MarkerUtilities/i18n.lua) mean?
- The system of the statuses in Japanese Wikivoyage is different from German one. How can I fix this? (on l.291 of [Module:Marker Utilities/i18n](MarkerUtilities/i18n.lua))
- The WD ID [Q2145615](https://www.wikidata.org/w/index.php?title=Q2145615) was merged into [Q7673285](https://www.wikidata.org/w/index.php?title=Q7673285), [Q11964531](https://www.wikidata.org/w/index.php?title=Q11964531) was merged into [Q1210069](https://www.wikidata.org/w/index.php?title=Q1210069) and [Q1824143](https://www.wikidata.org/w/index.php?title=Q1824143) was merged into [Q2334804](https://www.wikidata.org/w/index.php?title=Q2334804), so I think these need to be upded (on l.32, 36 and 68 of [Module:VCard/Qualifiers](core/Qualifiers.lua))
- We already have the Exchangerate module, but the functions are different from German ones. Can they be integrated or do they have to be created separately?
- [Module:Languages](./Languages.lua) is not in the list "Wikivoyage:VCard/Installation#Localization": doesn't this need to be translated?

## Lisence
All modules in this storage are from German Wikivoyage, and these all are imported and edited under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.en) ([full text](../LICENSE)).

Here are all of the import sources: 
- [Module:Marker utilities](https://w.wiki/89y2): revision as of 14:38, 6 October 2023 by [RolandUnger](https://de.wikivoyage.org/wiki/User:RolandUnger)
- [Module:Marker utilities/i18n](https://w.wiki/89$N): revision as of 13:29, 5 October 2023 by [RolandUnger](https://de.wikivoyage.org/wiki/User:RolandUnger)
- [Module:Marker Utilities/Maki icons](https://w.wiki/8HiA): Revision as of 14:56, 25 June 2023 by [RolandUnger](https://de.wikivoyage.org/wiki/User:RolandUnger)
- [Module:VCard/Cards](https://w.wiki/89xq): revision as of 02:07, 27 September 2022 by [RolandUnger](https://de.wikivoyage.org/wiki/User:RolandUnger)
- [Module:VCard/i18n](https://w.wiki/89zS): revision as of 17:18, 8 October 2023 by [RolandUnger](https://de.wikivoyage.org/wiki/User:RolandUnger)
- [Module:VCard/Params](https://w.wiki/89zb): revision as of 14:43, 4 October 2023 by [RolandUnger](https://de.wikivoyage.org/wiki/User:RolandUnger)
- [Module:VCard/Qualifiers](https://w.wiki/8ErD): Revision as of 19:57, 29 October 2023 by [DerFussi](https://de.wikivoyage.org/wiki/User:DerFussi)
- [Module:VCard/Subtypes](https://w.wiki/8K9q): Revision as of 13:47, 12 October 2023 by [RolandUnger](https://de.wikivoyage.org/wiki/User:RolandUnger)
- [Module:VCard/Unesco](https://w.wiki/8KAr): Revision as of 23:51, 18 February 2023 by [RolandUnger](https://de.wikivoyage.org/wiki/User:RolandUnger)
- [Module:CountryData](https://w.wiki/8KAy): Revision as of 14:17, 7 July 2023 by [RolandUnger](https://de.wikivoyage.org/wiki/User:RolandUnger)
- [Module:CountryData/Geography](https://w.wiki/8KB8): Revision as of 13:55, 7 July 2023 by [RolandUnger](https://de.wikivoyage.org/wiki/User:RolandUnger)
- [Module:CountryData/Currencies](https://w.wiki/8KBT): Revision as of 17:02, 29 June 2022 by [RolandUnger](https://de.wikivoyage.org/wiki/User:RolandUnger)
- [Module:Wikidata_utilities](https://w.wiki/8Hib): Revision as of 13:58, 13 June 2023 by [RolandUnger](https://de.wikivoyage.org/wiki/User:RolandUnger)
- [Module:Languages](https://w.wiki/8Mrj): Revision as of 13:54, 11 June 2023 by [RolandUnger](https://de.wikivoyage.org/wiki/User:RolandUnger)

Some modules below already exist in javoy:
- [Module:Coordinates](https://w.wiki/8HiE)
  - [Module:Coordinates/i18n](https://w.wiki/8HiG)
