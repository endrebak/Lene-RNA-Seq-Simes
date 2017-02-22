library(rtracklayer)

gr = import("data/download/gencode.gtf")
gr.tiled = tile(gr, width=50)
gr.genes = gr[elementMetadata(gr)$type=="gene"]
gr.genes.tiled = tile(gr.genes, width=50)
gr.overlaps = findOverlaps(gr.genes.tiled, gr.tiled)

## elementM= elementMetadata(gr[subjectHits(gr.overlaps)])$type
