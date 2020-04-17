
# Predicting votes cast at a data science competition
Our team of exceptionally talented individuals recently won a data science competition called Minne MUDAC 2018, organized by the MinneAnaltyics community held on 3rd November 2018. Graduate students and professionals competed in this competition wherin teams predicted votes that would be cast for each political party in the 2018 minnesota midterm elections. 

## Index
* [Executive Summary](#the-data-science-challenge)
* [Presentation](https://github.com/RaghuveerRao/Election-Votes-Prediciton/blob/master/Presentation.pdf)
* [Clustering for Data Aggregation](https://github.com/RaghuveerRao/Election-Votes-Prediciton/blob/master/clustering.R)
* [Predicting Votes Cast](https://github.com/RaghuveerRao/Election-Votes-Prediciton/blob/master/Total%20Votes%20Prediction.ipynb)
* Appendix
  * [LinkedIn Blog Post](https://www.linkedin.com/pulse/predicting-votes-cast-data-science-competition-some-takeaways-rao/)
  * [Official Press Release](http://bit.ly/minne-mudac-page)
  * [University Press Release](https://carlsonschool.umn.edu/news/msba-team-wins-2018-minnemudac-case-competition)

![Presenting](https://github.com/RaghuveerRao/Election-Votes-Prediciton/raw/master/images/presenting2.jpeg)
> Presenting at the final leg of the competition. Part of the competition was to present complex analysis to audience of 200+ non-specialist professionals.

## The Data Science Challenge:

The challenge was to investigate the factors/characteristics that influence the number of voters who would cast a ballot in the 2018 Minnesota elections, and predict the number of votes that will be cast for each party (Democrat, Republican & Independent) for the 8 Congressional Districts, the governor and the 2 senate seats of Minnesota. That is a total of 33 variables to predict [(8 + 2 + 1) x 3], and each team was given 8 minutes to present to a panel of 3 judges, comprised of data science, business and academic professionals.

## Dataset: None

Part of the challenge was to find our own data. We started by researching factors that could affect voter turnout and party inclination. The golden source for any demographic data in any country is the census, wherein a team of hard working people count and write down characteristics of every individual in the country. This herculean task is only done once in every 10 years and within a span of 10 years the congress changes 5 times and demographics vary drastically. The United States Census Bureau also does an annual survey on a sample population, called the American Community Survey and uses this sample demographic data to estimate the demographic data across the country. Not the most accurate data for our problem but we decided to go ahead with this.

Once we obtained the past 10 years of demographic data for each of the 8 congressional districts in Minnesota from the American community survey, we discussed what other data points could affect voters. We added historical voting data, campaign financing, pre-polling surveys and twitter sentiment data of candidates.

Next, we realized that we have over 100 features or columns and this data is only available for the past 10 years (rows) for each congressional district. This means we have more variables then observations and in such a case the predictive problem would not have a unique solution unless it is further constrained. That is, there may be multiple (perhaps infinitely many) solutions that fit the data equally well. Such a problem is called 'ill-posed' or 'underdetermined' and can lead to overfitting.

To solve this challenge, we leveraged the K – Means clustering algorithm to find 10 similar districts in the United States for each of the 8 congressional districts in Minnesota based on demographic and political profile, increasing the number of observations (rows) ten-fold.

![Clustering in action](https://github.com/RaghuveerRao/Election-Votes-Prediciton/raw/master/images/cluster.jpg)
> A Tableau illustration of similar districts in USA for each of the 8 congressional districts in Minnesota.

## Analysis:

Now that data is ready we applied Random Forest regression and apart from good accuracy this algorithm provided the following advantages:

Random forest in an ensemble of decision trees. An Ensemble model is one in which the classifier is constructed by combining several different Independent base classifiers (decision trees in this case). The ensemble classifier then aggregates the individual predictions to combine them into a final prediction. Also, when different models with different error rates are combined, the error rate on the combined model generally reduces significantly.
We wanted to understand which characteristics in the data the model was relying on the most for its prediction: to identify what is causing voters to vote for Republican, Democrat or Independent. Random forest, being a tree-based method of regression, lets us extract feature importance from the data that the model believes to be significant in predicting whether a congressional district will vote for a democrat or a republican candidate.  

![Random Forest Working](https://github.com/RaghuveerRao/Election-Votes-Prediciton/raw/master/images/random-forests.png)

