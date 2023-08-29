FROM gitlab-registry.nrp-nautilus.io/prp/jupyter-stack/scipy

# Install packages via conda
RUN conda install -y -c conda-forge -n base biopython pytest 
