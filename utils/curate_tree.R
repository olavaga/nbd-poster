#' Preprocess data for hypercubic inference
#'
#' Prepare a newick tree with leaf annotations for hypercubic inference.
#' 
#' Please cite 
#'  HyperTraPS-CT: Inference and prediction for accumulation pathways with flexible data and model structures
#' Olav N. L. Aga, Morten Brun, Kazeem A. Dauda, Ramon Diaz-Uriarte, Konstantinos Giannakis, Iain G. Johnston
#' bioRxiv 2024.03.07.583841; doi: https://doi.org/10.1101/2024.03.07.58384
#' When using this code
#' 
curate.tree = function(tree.filename, data.filename, losses = FALSE) {
  # read in Newick tree and root
  my.tree = read.tree(tree.filename)
  my.rooted.tree = root(my.tree, 1, resolve.root = TRUE)
  
  # read in barcode data
  my.data = read.csv(data.filename)
  colnames(my.data)[1] = "label"
  
  # prune tree to include only those tips in the barcode dataset
  tree = drop.tip(my.rooted.tree,
                  my.rooted.tree$tip.label[-match(my.data$label, my.rooted.tree$tip.label,nomatch=0)])
  
  tree$node.label = as.character(length(tree$tip.label) + 1:tree$Nnode)
  tree.labels = c(tree$tip.label, tree$node.label)
  
  cat("\n------- Painting ancestors...\n  ")
  
  # initialise "recursive" algorithm
  change = T
  new.row = my.data[1,]
  changes = data.frame()
  
  # while we're still making changes
  while(change == T) {
    change = F
    # loop through all nodes
    for(tree.ref in 1:length(tree.labels)) {
      this.label = tree.labels[tree.ref]
      # see if this node exists in our barcode dataset
      if(!(this.label %in% my.data$label)) {
        # if not, check to see if its children are all characterised
        descendant.refs = Children(tree, tree.ref)
        if(all(tree.labels[descendant.refs] %in% my.data$label)) {
          
          ## ancestral state reconstruction
          # pull the rows in our barcode dataset corresponding to children of this node
          descendant.rows = which(my.data$label %in% tree.labels[descendant.refs])
          if(losses == FALSE) {
            # bitwise AND to construct the ancestral state
            new.barcode = apply(my.data[descendant.rows,2:ncol(my.data)], 2, prod)
          } else {
            # bitwise OR to construct the ancestral state
            new.barcode = apply(my.data[descendant.rows,2:ncol(my.data)], 2, max)
          }
          # add this ancestral state to the barcode dataset
          new.data = new.row
          new.data$label[1] = this.label
          new.data[1,2:ncol(new.data)] = new.barcode
          my.data = rbind(my.data, new.data)
          
          ## adding transitions to our observation set
          # loop through children
          for(d.ref in descendant.refs) {
            # pull the barcodes and branch lengths together and add to data frame
            d.row = which(my.data$label == tree.labels[d.ref])
            # get the reference for this edge
            e.ref = which(tree$edge[,2] == d.ref)
            changes = rbind(changes, 
                            data.frame(from=paste0(new.data[2:ncol(new.data)], collapse=""),
                                       to=paste0(my.data[d.row,2:ncol(new.data)], collapse=""),
                                       time=tree$edge.length[e.ref],
                                       from.node=this.label,
                                       to.node=tree.labels[d.ref]))
          }
          # we made a change, so keep the loop going
          change = T
        }
      }
    }
  }
  srcs = matrix(as.numeric(unlist(lapply(changes$from, strsplit, split=""))), byrow=TRUE, ncol=ncol(new.data)-1)
  dests = matrix(as.numeric(unlist(lapply(changes$to, strsplit, split=""))), byrow=TRUE, ncol=ncol(new.data)-1)
  
  rL = list("tree" = tree,
            "data" = my.data,
            "transitions" = changes,
            "srcs" = srcs,
            "dests" = dests,
            "times" = changes$time)
  return(rL)
}