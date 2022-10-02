# hydrogel_pore_size_statistics
size distribution + hypothesis testing

Scripts developed in Python 3.8 to locate and calculate pore characteristics and then perform hydrogel spatial analysis. 

## Ripley-k

The Ripley-K function is a popular method to provide an overview of cluster patterns within the data[43]. This functioning can be used to evaluate spatial stochastic process along a line (1D), points in a plan surface (2D) data, or 3D data. The Ripley-K function is a second-order statistical property that delineates the variation of point density per area (the first order) in the domain of interest. 

$$ Eq.1 \quad\quad\quad\quad k(r)=\frac{E(r)}{ \lambda} $$

$$ Eq.2 \quad\quad\quad\quad k(r)=\frac{1}{n} \displaystyle\sum_{1}^{n} Npi (r)/ \lambda$$

k(r) describes the characteristics of the point density at multiple distances or radiuses indicated by r. Where λ is the point density (number of points per unit of area = Npi/A) and E is the number of points falling in a circle with the radius of r of each point. To distinguish whether a certain point pattern is clustered or not, the Ripley-K function of the given pattern is compared with the homogeneous Poisson point process, known as the complete state of randomness (CSR). The expected value of k(r) for the CSR state is an exponential function of radius:


$$ Eq.3 \quad\quad\quad\quad k(r)=\pi r^2$$

At each radius, if the Ripley-K function of the sample crosses over the reference CSR curve, it can be concluded that the sample has some structures with higher density than CSR. Thus, it is considered a positively clustered structure. While the negative deviation of sample Ripley-K values from the CSR curve indicates the sparsity of the data over the space domain. In case the sample k values are closely following the CSR curve, the structure is categorized as an ideally uniform structure.

## Radial pair correlation 

The radial pair correlation is one of the correlation-based clustering methods used for understanding the variation of dispersion patterns in the space domain. The radial pair correlation function is a measure of changing density and structure relative to an arbitrary point. The amplitude of the function shows the extent of correlation between the reference point and the point density observed within the distance r. That is “if pairs for the reference point can be found at distance r then the correlation increases in the relative distance (r)”. The more the value of pair correlation for a sample is closer to 1, the less the data are correlated to each other at a determined distance means the homogeneous dispersion (closer to CSR). However, the vertex in the data shows a distinct highly ordered structure within that distance from each point.

  ![image](https://user-images.githubusercontent.com/113156852/193439173-185fa645-337b-45cf-90c7-a4ed39ac3c89.png)

## Network/graph-based analysis 

Graphs are strong mathematical tools employed to investigate the interaction and relation between the objects or entities of a system[46]. Graph theory can be used for the localization of specific structures based on predefined criteria e.g., distance or number of neighboring points. In the clustering context, the entities are the data points that are represented as graph nodes, and the connectivity between the points is defined as edges. Graph-based clusters were formed based on a connectivity matrix. The connectivity matrix is used to construct various simple or complex graphs to study the data points.The spectral clustering was applied to localize different clusters in the constructed graphs.

![image](https://user-images.githubusercontent.com/113156852/193439416-f216a55f-14f7-4d1e-9f7b-bbd1160287d8.png)




