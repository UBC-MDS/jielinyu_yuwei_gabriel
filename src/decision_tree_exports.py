#!/usr/bin/env python
# decision_tree_results.py


# Nov 23 2018 

#This script output the decision tree graph 

#Usage: python src/decision_tree_exports.py results/finalized_model.sav results/

import argparse
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn import tree
from sklearn.model_selection import train_test_split
import pickle
from sklearn.tree import DecisionTreeClassifier


parser=argparse.ArgumentParser()
parser.add_argument('input_file_path', help='File path of clean data for a specific city')
parser.add_argument('output_path', help='Output file to dump the finalized model')

args = parser.parse_args()
import graphviz

     
def save_and_show_decision_tree(model,class_names = ['low', 'median', 'high'],save_file_prefix = args.output_path + "Tree_graph", **kwargs):
    """
    Saves the decision tree model as a pdf and a 
    """
    feature_cols = ['minimum_nights','number_of_reviews','calculated_host_listings_count','availability_365','room_type_num']
    dot_data = tree.export_graphviz(model, out_file=None, 
                             feature_names=feature_cols,  
                             class_names=class_names,  
                             filled=True, rounded=True,  
                             special_characters=True, **kwargs)  

    graph = graphviz.Source(dot_data) 
    graph.render(save_file_prefix) 
    return graph
                    
def main():
    
    
    # set random state
    rstate = 1234

    # Get command line arguments
    input_path = args.input_file_path


    #load decision tree model that built up in the third script 
    loaded_model = pickle.load(open(input_path,'rb'))
    save_and_show_decision_tree(loaded_model)
    




if __name__ == "__main__":
    main()
    
main()

