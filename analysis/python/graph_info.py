import snap
import plfit
import argparse
from operator import itemgetter
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

def load_graph(inputFile, outputFile):
    User = set()
    Business = set()
    Edge = set()
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            row = line.strip('\n').split('\t')
            uid = int(row[0])
            bid = int(row[1])
            e = (uid, bid)
            User.add(uid)
            Business.add(bid)
            Edge.add(e)
    with open(outputFile, 'a') as fout:
        fout.write("\nGraph Info: \n")
        fout.write("\tNumber of Users: " + str(len(User)) + "\n")
        fout.write("\tNumber of Businesses: " + str(len(Business)) + "\n")
        fout.write("\tNumber of Reviews: " + str(len(Edge)) + "\n")
    return User, Business, Edge

def getDegreeToCount(G):
    """ get (degree, count-of-node, fraction-of-node) sequences
    """
    N = G.GetNodes()
    DegToCntV = snap.TIntPrV()
    snap.GetDegCnt(G, DegToCntV)
    degreeV = [ e.GetVal1() for e in DegToCntV ]
    countV = [ e.GetVal2() for e in DegToCntV ]
    normCountV = [ k / float(N) for k in countV ]
    D = {'degreeV': degreeV, 'countV': countV, 'normCountV': normCountV}
    return D

def loglog_plot(G, outfile, isLoglog = True):
    """ Log-log plot for the degree distributions
    """
    pp = PdfPages(outfile)
    plt.figure()
    plt.clf()
    
    clr = 'red'
    lbl = 'review graph'
    D = getDegreeToCount(G)
    degreeV = D['degreeV']
    normCountV = D['normCountV']
    plt.loglog(degreeV, normCountV, color = clr, label = lbl)

    # add legend, etc
    plt.legend()
    plt.title('Degree Distribution', fontsize=18)
    plt.xlabel('degree')
    plt.ylabel("fraction of nodes")
    plt.grid()
    pp.savefig()
    pp.close()

def plfitDegreeDistr(G, outputFile):
    """ Power-law fit degree distribution
    """
    # fit with power-law
    D = getDegreeToCount(G)
    degreeV = D['degreeV']
    countV = D['countV']
    L = []
    for i in range(len(degreeV)):
        t = [ degreeV[i] ] * countV[i]
        L.extend(t)
    fit = plfit.plfit(L)
    
    # plfit fitted parameters
    with open(outputFile, 'a') as fout:
        fout.write("\nplfit fitted parameters:\n")
        fout.write("\txmin = " + str(fit._xmin) + "\n")
        fout.write("\talpha = " + str(fit._alpha) + "\n")

def clustCf(G, outputFile):
    cf = snap.GetClustCf(G)
    with open(outputFile, 'a') as fout:
        fout.write("\nclustering coefficient:\n")
        fout.write("\tcf = " + str(cf) + "\n")
    
def topWCC(G, outputFile, n=5):
    WccSzCnt = snap.TIntPrV()
    snap.GetWccSzCnt(G, WccSzCnt)
    Cnt = WccSzCnt.Len()
    L = []
    for i in range (Cnt):
        e = (WccSzCnt[i].Val1.Val, WccSzCnt[i].Val2.Val)
        L.append(e)

    # sort and get top 10    
    L = sorted(L, key=itemgetter(0), reverse=True)
    with open(outputFile, 'a') as fout:
        fout.write("\nWCC Info: \n")
        fout.write("\tWccSzCnt.Len(): " + str(Cnt) + "\n")
        m = min(n, Cnt)
        for i in range(m):
            e = L[i]
            fout.write("\tWccSzCnt[" + str(i) + "] = (" + str(e[0]) + "," + str(e[1]) + ")\n")
    
def main(args):
    ub_review_edges_file = args.ub_review_edges
    degree_dist_info_file = args.degree_dist_info
    degree_dist_plot_file = args.degree_dist_plot

    # load graph
    G = snap.LoadEdgeList(snap.PUNGraph, ub_review_edges_file, 0, 1)

    # plot
    loglog_plot(G, degree_dist_plot_file)

    # graph info
    snap.PrintInfo(G, "yelp-review-stats", degree_dist_info_file, False)

    # plift
    plfitDegreeDistr(G, degree_dist_info_file)
    
    # clustering coefficient
    clustCf(G, degree_dist_info_file)
    
    # wcc
    topWCC(G, degree_dist_info_file)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp data')
    parser.add_argument('--ub_review_edges', metavar='FILE', required = True, help='ub_review_edges file')
    parser.add_argument('--degree_dist_info', metavar='FILE', required = True, help='degree_dist_info')
    parser.add_argument('--degree_dist_plot', metavar='FILE', required = True, help='degree_dist_plot')
    args = parser.parse_args()
    main(args)
    