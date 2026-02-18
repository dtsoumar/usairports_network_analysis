#------------------------------------------------------------------------------#
#                       Complex Systems and Networks                           #
#                               USairports                                     #
#------------------------------------------------------------------------------#

library(igraphdata)
library(igraph)


data(USairports)
summary(USairports)
ug <- USairports
E(ug)[[1:5]]
V(ug)[[1:5]]

#set the weights from the number of passengers
ug <- set.edge.attribute(ug,"weight", value = E(ug)$Passengers) 

is.directed(ug)   # directed
is.weighted(ug)   # weighted
is_simple(ug)     # do loops or / and multiple edges
which_multiple(ug)# logical vector for multiple edges
which_loop(ug)    # logical vector for loops
vcount(ug)        # order of the graph
ecount(ug)        # size of the graph

## to find the multiple edges and the loops
m<-which_multiple(ug) #15208
sum(m)
l<- which_loop(ug) # 53
sum(l)


length(USairports[["BGR", "JFK", edges = TRUE]][[1]] )
USairports[["BGR", "JFK", edges = TRUE]][[1]][[1:2]]

# make the graph simple without loops
newug<- simplify(ug, remove.loops = T, remove.multiple = F)

# find the airports at West Palm Beach/Palm Beach and Seattle
V(newug)[City == "West Palm Beach/Palm Beach, FL"] # 1 airport
V(newug)[City == "Seattle, WA"] # 3 airports

###### The minimum path to go from "West Palm Beach/Palm Beach, FL" to "Seattle, WA"

sp1 <- shortest_paths(newug, from="PBI",to=c("BFI","SEA", "LKE"),
                      mode = "out",
                      output = "epath")
sp1
sp1$epath         
as_ids(sp1$epath[[1]])
as_ids(sp1$epath[[2]])
as_ids(sp1$epath[[3]])



# Flight Path from PBI to BFI 

#PBI -> HPN
length(newug[["PBI", "HPN", edges = TRUE]][[1]] )
(PBI_HPN<-newug[["PBI", "HPN", edges = TRUE]][[1]][[1:4]])
#HPN->TEB
length(newug[["HPN", "TEB", edges = TRUE]][[1]] )
(HPN_TEB<-newug[["HPN", "TEB", edges = TRUE]][[1]][[1:1]])
#TEB->ANC
length(newug[["TEB","ANC" , edges = TRUE]][[1]] )
(TEB_ANC<-newug[["TEB","ANC", edges = TRUE]][[1]][[1:1]])
#ANC->JNU
length(newug[["ANC","JNU", edges = TRUE]][[1]] )
(ANC_JNU<-newug[["ANC","JNU", edges = TRUE]][[1]][[1:5]])
#JNU->BFI
length(newug[["JNU","BFI", edges = TRUE]][[1]] )
(JNU_BFI<-newug[["JNU","BFI", edges = TRUE]][[1]][[1:1]])

# Flight Path from PBI to SEA

#PBI -> HPN
length(newug[["PBI", "HPN", edges = TRUE]][[1]] )
(PBI_HPN<-newug[["PBI", "HPN", edges = TRUE]][[1]][[1:4]])
#HPN->TEB
length(newug[["HPN", "TEB", edges = TRUE]][[1]] )
(HPN_TEB<-newug[["HPN", "TEB", edges = TRUE]][[1]][[1:1]])
#TEB->ANC
length(newug[["TEB","ANC" , edges = TRUE]][[1]] )
(TEB_ANC<-newug[["TEB","ANC", edges = TRUE]][[1]][[1:1]])
#ANC->JNU
length(newug[["ANC","JNU", edges = TRUE]][[1]] )
(ANC_JNU<-newug[["ANC","JNU", edges = TRUE]][[1]][[1:5]])
#JNU->SEA
length(newug[["JNU","SEA", edges = TRUE]][[1]] )
(JNU_SEA<-newug[["JNU","SEA", edges = TRUE]][[1]][[1:4]])

# Flight Path from PBI to LKE

#PBI -> HPN
length(newug[["PBI", "HPN", edges = TRUE]][[1]] )
(PBI_HPN<-newug[["PBI", "HPN", edges = TRUE]][[1]][[1:4]])
#HPN->TEB
length(newug[["HPN", "TEB", edges = TRUE]][[1]] )
(HPN_TEB<-newug[["HPN", "TEB", edges = TRUE]][[1]][[1:1]])
#TEB->ANC
length(newug[["TEB","ANC" , edges = TRUE]][[1]] )
(TEB_ANC<-newug[["TEB","ANC", edges = TRUE]][[1]][[1:1]])
#ANC->JNU
length(newug[["ANC","JNU", edges = TRUE]][[1]] )
(ANC_JNU<-newug[["ANC","JNU", edges = TRUE]][[1]][[1:5]])
#JNU->BFI
length(newug[["JNU","BFI", edges = TRUE]][[1]] )
(JNU_BFI<-newug[["JNU","BFI", edges = TRUE]][[1]][[1:1]])
#BFI->FRD
length(newug[["BFI","FRD", edges = TRUE]][[1]] )
(BFI_FRD<-newug[["BFI","FRD", edges = TRUE]][[1]][[1:3]])
#FRD->LKE
length(newug[["FRD","LKE", edges = TRUE]][[1]] )
(FRD_LKE<-newug[["FRD","LKE", edges = TRUE]][[1]][[1:2]])


x <- c("PBI", "BFI", "SEA", "LKE", "HPN", "TEB", "ANC", "JNU", "FRD")
x


y <- c(as_ids(sp1$epath[[1]]),
       as_ids(sp1$epath[[2]]),
       as_ids(sp1$epath[[3]]) )

y


V(newug)$w <- strength(newug)

g_path <- induced_subgraph(newug, x)
g_path

'%!in%' <- function(x,y)!('%in%'(x,y))


for (i in 1:10){
  g_path <- delete_edges(g_path, as_ids(E(g_path))[as_ids(E(g_path)) %!in% y]) 
}
g_path

V(g_path)$City
V(g_path)$membership <- as.numeric(as.factor(V(g_path)$City))

col <- rainbow(n = 4, alpha = 0.8)
green1 <- rgb(0,1,0,.7)
grey1 <- rgb(.7,.7,.7,.8)

# g_path <- delete_edge_attr(g_path, "color")


E(g_path)$color <- grey1

E(g_path)$color[[1]] <- green1
E(g_path)$color[[6]] <- green1
E(g_path)$color[[7]] <- green1
E(g_path)$color[[10]] <- green1
E(g_path)$color[[14]] <- green1
E(g_path)$color[[15]] <- green1
E(g_path)$color[[16]] <- green1
E(g_path)$color[[20]] <- green1


#E(g_path)$color <- ifelse(E(g_path)$color=="green1", "green1", "lightgrey")

#E(g_path)$color[E(g_path)$color==NA] <- as.character("lightgrey")
#is.na(E(g_path)$color) <- as.character("lightgrey")


par(bg="black")
plot(g_path,
     layout=layout_with_gem,
     edge.width=50*(1/(E(g_path)$Seats))+2,
     vertex.size=ifelse(V(g_path)$w==max(V(g_path)$w),40, 80*(V(g_path)$w)/max(V(g_path)$w)+10),
     edge.arrow.size=.5,
     vertex.color= ifelse(V(g_path)$name=="PBI", "blue", ifelse(V(g_path)$City=="Seattle, WA", "purple", ifelse(V(g_path)$name=="JNU", "red", "orange"))),
     vertex.label=V(g_path)$name,
     vertex.label.dist=ifelse(V(g_path)$name=="PBI" | V(g_path)$name=="SEA", 0,2),
     vertex.label.cex=2,
     vertex.label.color="white",#ifelse(V(g_path)$name=="PBI" | V(g_path)$name=="SEA", "white","black"),
     vertex.label.family="sans",
     edge.color=E(g_path)$color
     
)+
  
  legend(x=1.3, y=-.5, legend = c("Start","Destination", "Vulnerable", "Intermediate Airports"),
         pch=21, 
         text.col="white",
         #col = "white",
         pt.bg = c("blue", "purple", "red", "orange"),
         pt.cex = 2.5,
         cex = 1.3
         )
  legend(x=-2.3,y=-1, legend=c("Min number of Seats", "Other Flights"),
         
         col=c(green1,grey1),
         lty=1,
         cex=1.2,
         lw=10,
         text.col = "white"
         )
