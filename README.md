yelp-sna
=============

Social Network Analysis with Yelp Academic Dataset

1. Dependencies
    
* [LIBMF](https://www.csie.ntu.edu.tw/~cjlin/libmf/)
* [Snappy](http://snap.stanford.edu/snappy/doc/tutorial/index-tut.html)
* Octave 3.8
* Python-2.7
* numpy-1.9
* Hadoop
* Pig Latin

2. Check out 

    ```
    # Cloned from https://github.com/kevinmao/yelp-sna
    cd ~
    git clone https://github.com/kevinmao/yelp-sna
    cd yelp-sna
    ```

3. Download Yelp Dataset Challenge

    ```
    # download from http://www.yelp.com/dataset_challenge
    ```

4. Unzip Yelp data

    ```
    make xunzip
    ```

5. Transform JSON format Yelp data to TSV format

    ```
    make transform
    ```

6. Split Yelp reviews into training and test sets

    ```
    make split_review
    ```

7. Map graphs into integer IDs 

    ```
    make user_keys
    make business_keys
    make user_user
    ```

8. Create user-business review data 

    ```
    make ub_review
    ```

9. Extract MaxWcc

    ```
    make get_maxwcc
    ```

10. Create core datasets

    ```
    make core_review 
    make core_review_sample # sampling
    ```

11. Create similarity scores

    ```
    make ub_similarity 
    ```

12. Create top_n candidates on Hadoop

    ```
    make top_n 
    ```

13. Link prediction 

    ```
    make link_cand_summary
    make predicted_topn
    ```

14. Create training data for matrix factorization, training and predicting

    ```
    make create_mf_data
    make mf_train
    make mf_predict
    ```

15. Create training data for matrix factorization, training and predicting

    ```
    make create_mf_data
    make mf_train
    make mf_predict
    ```
                                                                                                                                                                                                                                                                
16. Link prediction for matrix factorization

    ```
    make top_n_mf
    make mf_predicted_tp
    ```

17. Combine link prediction results 

    ```
    make precision_comb
    make combine
    ```

18. Create plots

    ```
    # degree distribution
    make degree_dist
    
    # graph statistical info
    make graph_info

    # precision, precision@n and recall 
    make octave_plot
    ```
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                